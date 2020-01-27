//
//  AlbumsDetialsRepository.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumsDetialsRepository  {
    
    struct Output {
            let albumDetails: Observable<AlbumDetailModel>
            let albumDetailsList: Observable<[AlbumDetailModel]>
            let isCached: Observable<Bool>
            let error: Observable<ErrorModel>
        }
    
    private let dataProvider: DataProvider<AlbumDetailsResponseModel>?
    private let cachingManager: CachingManagerProtocol!
    private var albumDetailsModelSubject: BehaviorRelay = BehaviorRelay<AlbumDetailModel>(value: AlbumDetailModel(artist: Artist(), album: Album(), tracks: []))
    private var albumDetailsSubject: BehaviorRelay = BehaviorRelay<AlbumDetailsResponseModel>(value: AlbumDetailsResponseModel())
    private var albumDetailsListSubject: PublishSubject<[AlbumDetailModel]> = PublishSubject<[AlbumDetailModel]>()
    private var isCachedSubject: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    private var errorSubject: PublishSubject = PublishSubject<ErrorModel>()
    private var disposeBag = DisposeBag()
    private var artist: Artist?
    private var album: Album?
    private var isAutomaticalyCaching: Bool = false
    public var output: Output!
    
    init(dataProvider: DataProvider<AlbumDetailsResponseModel>?, cachingManager: CachingManagerProtocol, artist: Artist?, album: Album?) {
        self.dataProvider = dataProvider
        self.cachingManager = cachingManager
        self.album = album
        self.artist = artist
        output = Output(albumDetails: albumDetailsModelSubject.asObservable(), albumDetailsList: albumDetailsListSubject.asObservable(), isCached: isCachedSubject.asObservable(), error: errorSubject.asObservable())
        handleAlbumDataResponse()
    }
    
    public func fetchAlbumDetails() {
        guard let album = album, let artist = artist else {return}
        // check if the album is cached then get the cached data for faster view to appear to user
        checkIfIsAlbumAlreadySaved()
        if !isCachedSubject.value {
            let albumDetailsParameters = AlbumDetailsParameters(artistName: artist.name!, album: album.name!)
            self.dataProvider?.setApiParameters(params: albumDetailsParameters.dictionary)
            self.dataProvider?.execute()
        }
        
    }
    
    func fetchAlbumDetails(with album: Album, isAutomaticalyCaching: Bool) {
        self.isAutomaticalyCaching = isAutomaticalyCaching
        self.album = album
        fetchAlbumDetails()
        
    }
    
    private func handleError(error: ErrorModel?) {
        if let error = error {
            errorSubject.onNext(error)
        }else {
            let error = ErrorModel(code: LocalError.unknownError.errorCode, message: LocalError.unknownError.localizedDescription, error: LocalError.unknownError.localizedDescription, url: nil)
            errorSubject.onNext(error)
        }
    }
    
    private func failedSavingToCache() {
        let error = ErrorModel(code: LocalError.cachingFailed.errorCode, message: LocalError.cachingFailed.localizedDescription, error: LocalError.cachingFailed.localizedDescription, url: nil)
        self.handleError(error: error)
    }
    
    private func failedDeleteFromCache() {
        let error = ErrorModel(code: LocalError.removeFromCacheFailed.errorCode, message: LocalError.removeFromCacheFailed.localizedDescription, error: LocalError.removeFromCacheFailed.localizedDescription, url: nil)
        self.handleError(error: error)
    }
    
    private func failedToFetchFromCache() {
        let error = ErrorModel(code: LocalError.noCached.errorCode, message: LocalError.noCached.localizedDescription, error: LocalError.noCached.localizedDescription, url: nil)
        self.handleError(error: error)
    }
    
    func fetchAlbumListDetails() {
        if let albumDetailsList = cachingManager.fetchList(predicate: nil, type: LocalAlbumDetailsModel.self) {
            albumDetailsListSubject.onNext(albumDetailsList.map{AlbumDetailModel(localAlbumDetailsModel: $0)})
        }else {
            failedToFetchFromCache()
        }
    }
    
    /// convert the response data to local cached Tables, and insert converted data to Cache.
    public func saveAlbumToCache() {
        guard let album = album, let artist = artist else {return}
        let albumDetailsDesponse = albumDetailsSubject.value
        let localArtistModel = LocalArtistModel(artistId: artist.id, name: artist.name, image: artist.image, numberOfListners: artist.numberOfListeners)
        let localAlbumModel = LocalAlbumModel(albumId: album.id, name: album.name, image: album.image, numberOfPlays: album.numberOfPlays)
        var localTracks: [LocalTrackModel] = []
        if let tracks = albumDetailsDesponse.albumDetailsModel?.tracksModel?.tracks {
         localTracks = tracks.map{LocalTrackModel(name: $0.name, duration: $0.duration)}
        }
        let localAlbumDetailsModel = LocalAlbumDetailsModel(artist: localArtistModel, album: localAlbumModel, tracks: localTracks)
        if let _ = cachingManager.insert(genericDataModel: localAlbumDetailsModel) {
            isCachedSubject.accept(true)
        }else {
            isCachedSubject.accept(false)
            failedSavingToCache()
        }
    }
    
    func deleteAlbumFromCache() {
        guard let album = album, let artist = artist else {return}
        let predicate = NSPredicate(format: "artistId=%@ And albumId=%@", artist.id, (album.id)!)
        if let _ =  cachingManager.delete(predicate: predicate, type: LocalAlbumDetailsModel.self) {
                isCachedSubject.accept(false)
            }else {
                isCachedSubject.accept(true)
                failedDeleteFromCache()
            }
    }
    
    func deleteAlbumFromCache(album: Album) {
        self.album = album
        deleteAlbumFromCache()
    }
    
    public func checkIfIsAlbumAlreadySaved() {
        guard let album = album, let artist = artist else {return}
        if let localAlbumDetails = cachingManager.fetch(predicate: NSPredicate(format: "artistId=%@ And albumId=%@", artist.id, (album.id)!), type: LocalAlbumDetailsModel.self) {
            if localAlbumDetails.albumId == album.id {
                albumDetailsModelSubject.accept(AlbumDetailModel(localAlbumDetailsModel: localAlbumDetails))

                isCachedSubject.accept(true)
            }else {
                isCachedSubject.accept(false)
            }
            
        }
    }
    
    private func handleAlbumDetailsResponse(albumDetailsDesponse: AlbumDetailsResponseModel) {
        guard let album = album, let artist = artist else {return}
        let tracks = albumDetailsDesponse.albumDetailsModel?.tracksModel?.tracks?.map{Track(name: $0.name, duration: $0.duration)}  ?? []
        let albumDetails = AlbumDetailModel(artist: artist, album: album, tracks: tracks)
        albumDetailsModelSubject.accept(albumDetails)
        albumDetailsSubject.accept(albumDetailsDesponse)
        if isAutomaticalyCaching {
            saveAlbumToCache()
        }
    }
    
    private func handleAlbumDataResponse() {
        dataProvider?
            .observableResponse
            .subscribe(onNext: { [weak self] (response) in
                guard let self = self else { return }
                if let albumDetailsDesponse = response.0 {
                self.handleAlbumDetailsResponse(albumDetailsDesponse: albumDetailsDesponse)
                }else if let error = response.1 {
                    if let error = error as? ErrorModel {
                        self.handleError(error: error)
                    }else {
                        self.handleError(error: nil)
                    }
                }
            }, onError: { [weak self] (error) in
                guard let self = self else { return }
                if let error = error as? ErrorModel {
                    self.handleError(error: error)
                }else {
                    self.handleError(error: nil)
                }
            }).disposed(by: disposeBag)
    }
    
}
