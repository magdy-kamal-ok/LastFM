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
            let albumDetails: Observable<AlbumDetailModel>
            let error: Observable<ErrorModel>
            let isCached: Observable<Bool>
        }
    

    private var isLoadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var albumDetailsSubject: PublishSubject<AlbumDetailModel> = PublishSubject<AlbumDetailModel>()
    private var errorSubject: PublishSubject<ErrorModel> = PublishSubject<ErrorModel>()
    
    private var disposeBag = DisposeBag()
    private var isCached = false
    private var artist: Artist
    private var album: Album
    private let albumDetailsRrepository: AlbumsDetialsRepository
    public var output: Output!
    private weak var coordinator: AlbumDetailsCoordinator?

    init(albumDetailsRrepository: AlbumsDetialsRepository, artist: Artist, album: Album, coordinator: Coordinator?) {
        self.artist = artist
        self.album = album
        self.albumDetailsRrepository = albumDetailsRrepository
        output = Output(isLoading: isLoadingSubject.asObservable(), albumDetails: albumDetailsRrepository.output.albumDetails.asObservable(), error: errorSubject.asObservable(), isCached: albumDetailsRrepository.output.isCached)
        bindIsCachedVariable()
        self.coordinator = coordinator as? AlbumDetailsCoordinator
    }
    
    private func saveAlbumDetails(album: Album? = nil) {
        if let album = album {
            albumDetailsRrepository.fetchAlbumDetails(with: album, isAutomaticalyCaching: true)
        }else {
            albumDetailsRrepository.saveAlbumToCache()
        }
    }

    private func deleteAlbumDetails() {
        albumDetailsRrepository.deleteAlbumFromCache()
    }
    
    public func handleDownloadButtonAction(album: Album? = nil) {
        if isCached {
            self.deleteAlbumDetails()
        }else {
            self.saveAlbumDetails(album: album)
        }
    }
    public func fetchAlbumDetials() {
        albumDetailsRrepository.fetchAlbumDetails()
    }
    
    public func checkifAlbumExists() {
        albumDetailsRrepository.checkIfIsAlbumAlreadySaved()
    }
    
    private func handleError(error: ErrorModel?) {
        if let error = error {
            errorSubject.onNext(error)
        }else {
            let error = ErrorModel(code: LocalError.unknownError.errorCode, message: LocalError.unknownError.localizedDescription, error: LocalError.unknownError.localizedDescription, url: nil)
            errorSubject.onNext(error)
        }
    }
    
    private func bindIsCachedVariable() {
        output
            .isCached
            .asObservable().subscribe(onNext: { [weak self] (isCached) in
                    guard let self = self else {return}
                    self.isCached = isCached
                }).disposed(by: disposeBag)
    }
}
