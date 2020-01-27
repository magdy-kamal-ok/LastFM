//
//  AlbumsViewModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumsViewModel {

    struct Output {
            let isLoadingMore: Observable<Bool>
            let isRefresh: Observable<Bool>
            let isLoading: Observable<Bool>
            let albums: Observable<[Album]>
            let error: Observable<ErrorModel>
        }
    
    private var isLoadingMoreSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isRefreshSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isLoadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var albumsSubject: PublishSubject<[Album]> = PublishSubject<[Album]>()
    private var errorSubject: PublishSubject = PublishSubject<ErrorModel>()
    
    private var albumList: [Album] = []
    private var total: Int = 0
    private var page: Int = 1
    private var artist: Artist
    private var disposeBag = DisposeBag()
    private let dataProvider: DataProvider<AlbumsResponseModel>!
    private weak var coordinator: AlbumListCoordinator?
    public var output: Output!
    var artistName: String = "" {
        didSet {
            page = 1
            fetchAlbums()
            isLoadingSubject.accept(true)
        }
    }
    
    init(dataProvider: DataProvider<AlbumsResponseModel>, artist: Artist, coordinator: Coordinator?) {
        self.dataProvider = dataProvider
        self.artist = artist
        output = Output(isLoadingMore: isLoadingMoreSubject.asObservable(), isRefresh: isRefreshSubject.asObservable(), isLoading: isLoadingSubject.asObservable(), albums: albumsSubject.asObservable(), error: errorSubject.asObservable())
        handleAlbumDataResponse()
        self.coordinator = coordinator as? AlbumListCoordinator
    }
    
    public func didPressAlbum(album: Album) {
        coordinator?.showAlbumsDetails(with: artist, album: album)
    }
    
    private func fetchAlbums() {
        let albumsParameters = AlbumsParameters(artistName: artistName, page: page)
        self.dataProvider.setApiParameters(params: albumsParameters.dictionary)
        self.dataProvider.execute()
    }

    private func mapToAlbumResponse(albumListResponse: [AlbumModel]?)-> [Album] {
        if let albumListResponse = albumListResponse {
            // i set album id with id and in case no i supposed that id is the name, because the api response some data does not have id
            return albumListResponse.map{Album(id: $0.id ?? $0.name, name: $0.name, image: $0.images?.first?.url, numberOfPlays: "\($0.playcount ?? 0)")}
        }else {
            return []
        }
    }
    
    private func resetAllLoaders() {
        isLoadingMoreSubject.accept(false)
        isRefreshSubject.accept(false)
        isLoadingSubject.accept(false)
    }
    
    private func handleError(error: ErrorModel?) {
         resetAllLoaders()
        if let error = error {
            errorSubject.onNext(error)
        }else {
            let error = ErrorModel(code: LocalError.unknownError.errorCode, message: LocalError.unknownError.localizedDescription, error: LocalError.unknownError.localizedDescription, url: nil)
            errorSubject.onNext(error)
        }
    }
    
    public func loadMoreAlbums() {
        if !isLoadingMoreSubject.value && albumList.count < total {
            page = page + 1
            isLoadingMoreSubject.accept(true)
            fetchAlbums()
        }
    }
    public func resetAlbumList() {
        if !artistName.isEmpty {
            page = 1
            albumList.removeAll()
            isRefreshSubject.accept(true)
            fetchAlbums()
        }else {
            isRefreshSubject.accept(false)
        }
    }
    
    private func addAlbumToList(albumListResponse: AlbumsResponseModel) {
        let mappedAlbums = mapToAlbumResponse(albumListResponse: albumListResponse.topAlbums?.albums)
        albumList.append(contentsOf: mappedAlbums)
        albumsSubject.onNext(albumList)
        resetAllLoaders()
    }
    
    private func handleAlbumListResponse(albumResponse: AlbumsResponseModel) {
        if let totalAlbums = albumResponse.topAlbums?.otherAttributes.total {
            total = Int(totalAlbums) ?? 0
        }
        if !isLoadingMoreSubject.value {
            albumList.removeAll()
        }
        addAlbumToList(albumListResponse: albumResponse)
        
    }
    
    private func handleAlbumDataResponse() {
        dataProvider
            .observableResponse
            .subscribe(onNext: { [weak self] (response) in
                guard let self = self else { return }
                if let albumResponse = response.0 {
                    self.handleAlbumListResponse(albumResponse: albumResponse)
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
