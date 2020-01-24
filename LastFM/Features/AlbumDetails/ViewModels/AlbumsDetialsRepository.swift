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
            let albumDetails: Observable<AlbumDetailsResponseModel>
            let isSaved: Observable<Bool>
            let isDeleted: Observable<Bool>
            let error: Observable<ErrorModel>
        }
    
    private let dataSourceProvider: DataProvider<AlbumDetailsResponseModel>!
    private let cachingManager: CachingManagerProtocol!
    private var albumDetailsSubject: BehaviorRelay = BehaviorRelay<AlbumDetailsResponseModel>(value: AlbumDetailsResponseModel())
    private var isSavedSubject: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    private var isDeletedSubject: BehaviorRelay = BehaviorRelay<Bool>(value: false)
    private var errorSubject: PublishSubject = PublishSubject<ErrorModel>()
    private var disposeBag = DisposeBag()
    private var artist: Artist
    private var album: Album
    public var output: Output!
    
    deinit {
        print("Killed")
    }
    init(dataSourceProvider: DataProvider<AlbumDetailsResponseModel>, cachingManager: CachingManagerProtocol, artist: Artist, album: Album) {
        self.dataSourceProvider = dataSourceProvider
        self.cachingManager = cachingManager
        self.album = album
        self.artist = artist
        output = Output(albumDetails: albumDetailsSubject.asObservable(), isSaved: isSavedSubject.asObservable(), isDeleted: isDeletedSubject.asObservable(), error: errorSubject.asObservable())
        handleAlbumDataResponse()
        fetchAlbumDetails()
    }
    
    private func fetchAlbumDetails() {
        let albumDetailsParameters = AlbumDetailsParameters(artistName: artist.name!, album: album.name!)
        self.dataSourceProvider.setApiParameters(params: albumDetailsParameters.dictionary)
        self.dataSourceProvider.execute()
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
    
    public func saveAlbumToCache() {
        let albumDetailsDesponse = albumDetailsSubject.value
        let localArtistModel = LocalArtistModel(artistId: artist.id, name: artist.name, image: artist.image, numberOfListners: artist.numberOfListeners)
        let localAlbumModel = LocalAlbumModel(albumId: album.id, name: album.name, image: album.image, numberOfPlays: albumDetailsDesponse.albumDetailsModel?.playcount)
        var localTracks: [LocalTrackModel] = []
        if let tracks = albumDetailsDesponse.albumDetailsModel?.tracksModel?.tracks {
         localTracks = tracks.map{LocalTrackModel.init(name: $0.name, duration: $0.duration)}
        }
        let localAlbumDetailsModel = LocalAlbumDetailsModel(artist: localArtistModel, album: localAlbumModel, tracks: localTracks)
        if let _ = cachingManager.insert(genericDataModel: localAlbumDetailsModel) {
            isSavedSubject.accept(true)
        }else {
            failedSavingToCache()
        }
    }
    
    func deleteAlbumFromCache() {
        let predicate = NSPredicate.init(format: "artistId=%@ And albumId=%@", self.artist.id, self.album.id)
        if let _ =  cachingManager.delete(predicate: predicate, type: LocalAlbumDetailsModel.self) {
            
            }else {
                failedDeleteFromCache()
            }
    }
    
    private func handleAlbumDetailsResponse(albumDetailsDesponse: AlbumDetailsResponseModel) {
        albumDetailsSubject.accept(albumDetailsDesponse)
    }
    
    private func handleAlbumDataResponse() {
        dataSourceProvider
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
