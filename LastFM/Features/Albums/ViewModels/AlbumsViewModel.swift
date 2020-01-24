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
        }
    
    private var isLoadingMoreSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isRefreshSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isLoadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var albumsSubject: PublishSubject<[Album]> = PublishSubject<[Album]>()
    
    private var albumList: [Album] = []
    private var total: Int = 0
    private var page: Int = 1
    private var disposeBag = DisposeBag()
    private let dataSourceProvider: DataSourceProvider<AlbumsResponseModel>!
    public var output: Output!
    var artistName: String = "" {
        didSet {
            page = 1
            fetchAlbums()
            isLoadingSubject.accept(true)
        }
    }
    
    init(dataSourceProvider: DataSourceProvider<AlbumsResponseModel>) {
        self.dataSourceProvider = dataSourceProvider
        output = Output(isLoadingMore: isLoadingSubject.asObservable(), isRefresh: isRefreshSubject.asObservable(), isLoading: isLoadingSubject.asObservable(), albums: albumsSubject.asObservable())
        handleAlbumDataResponse()
    }
    

    private func fetchAlbums() {
        let albumsParameters = AlbumsParameters.init(artistName: artistName, page: page)
        self.dataSourceProvider.setApiParameters(params: albumsParameters.dictionary)
        self.dataSourceProvider.execute()
    }

    private func mapToAlbumResponse(albumListResponse: [AlbumModel]?)-> [Album] {
        if let albumListResponse = albumListResponse {
            return albumListResponse.map{Album.init(name: $0.name, image: $0.images?.first?.url, numberOfPlays: $0.playcount)}
        }else {
            return []
        }
    }
    
    private func resetAllLoaders() {
        isLoadingMoreSubject.accept(false)
        isRefreshSubject.accept(false)
        isLoadingSubject.accept(false)
    }
    
    private func handleError() {
        resetAllLoaders()
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
        dataSourceProvider
            .observableResponse
            .subscribe(onNext: { [weak self] (response) in
                guard let self = self else { return }
                if let albumResponse = response.0 {
                    self.handleAlbumListResponse(albumResponse: albumResponse)
                }else if let error = response.1 {
                    self.handleError()
                }
            }, onError: { [weak self] (error) in
                guard let self = self else { return }
                self.handleError()
            }).disposed(by: disposeBag)
    }
}
