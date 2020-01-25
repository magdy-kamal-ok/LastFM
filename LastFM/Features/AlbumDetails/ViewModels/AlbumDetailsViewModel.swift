//
//  AlbumDetailsViewModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumDetailsViewModel {

    struct Output {
            let isLoading: Observable<Bool>
            let tracks: Observable<[TrackModel]>
            let error: Observable<ErrorModel>
            let isCached: Observable<Bool>
        }
    

    private var isLoadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var tracksSubject: PublishSubject<[TrackModel]> = PublishSubject<[TrackModel]>()
    private var errorSubject: PublishSubject<ErrorModel> = PublishSubject<ErrorModel>()
    
    private var disposeBag = DisposeBag()
    private var isCached = false
    private var artist: Artist
    private var album: Album
    private let dataSourceProvider: DataProvider<AlbumDetailsResponseModel>!
    private let albumDetailsRrepository: AlbumsDetialsRepository
    public var output: Output!
    
    init(dataSourceProvider: DataProvider<AlbumDetailsResponseModel>, artist: Artist, album: Album) {
        self.dataSourceProvider = dataSourceProvider
        self.artist = artist
        self.album = album
        self.albumDetailsRrepository = AlbumsDetialsRepository(dataSourceProvider: dataSourceProvider, cachingManager: RealmCachingManager(), artist: artist, album: album)
        output = Output(isLoading: isLoadingSubject.asObservable(), tracks: tracksSubject.asObservable(), error: errorSubject.asObservable(), isCached: albumDetailsRrepository.output.isCached)
        bindIsCachedVariable()
        handleAlbumDetailsDataResponse()
        fetchAlbumDetials()

        
    }
    
    private func saveAlbumDetails() {
        albumDetailsRrepository.saveAlbumToCache()
    }

    private func deleteAlbumDetails() {
        albumDetailsRrepository.deleteAlbumFromCache()
    }
    
    public func handleDownloadButtonAction() {
        if isCached {
            self.deleteAlbumDetails()
        }else {
            self.saveAlbumDetails()
        }
    }
    private func fetchAlbumDetials() {
        albumDetailsRrepository.fetchAlbumDetails()
    }

   
    
    private func handleError() {
        
    }
    
    private func bindIsCachedVariable() {
        output
        .isCached
        .asObservable().subscribe(onNext: { [weak self] (isCached) in
                guard let self = self else {return}
                self.isCached = isCached
            }).disposed(by: disposeBag)
    }
    
    private func handleAlbumDetailsDataResponse() {
        albumDetailsRrepository
            .output
            .albumDetails
            .subscribe(onNext: { [weak self] (response) in
                guard let self = self else { return }
                if let tracks = response.albumDetailsModel?.tracksModel?.tracks {
                    self.tracksSubject.onNext(tracks)
                }else  {
                    self.tracksSubject.onNext([])
                }
            }, onError: { [weak self] (error) in
                guard let self = self else { return }
                self.handleError()
            }).disposed(by: disposeBag)
    }
}
