//
//  SearchArtistViewModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchArtistViewModel {

    struct Output {
            let isLoadingMore: Observable<Bool>
            let isRefresh: Observable<Bool>
            let isLoading: Observable<Bool>
            let artists: Observable<[Artist]>
            let error: Observable<ErrorModel>
        }
    
    private var isLoadingMoreSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isRefreshSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isLoadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var artistsSubject: PublishSubject<[Artist]> = PublishSubject<[Artist]>()
    private var errorSubject: PublishSubject = PublishSubject<ErrorModel>()
    private weak var coordinator: SearchArtistCoordinator?

    private var artistList: [Artist] = []
    private var total: Int = 0
    private var page: Int = 1
    private var disposeBag = DisposeBag()
    private let dataSourceProvider: DataProvider<ArtistResponseModel>!
    public var output: Output!
    var artistName: String = "" {
        didSet {
            page = 1
            fetchArtists()
            isLoadingSubject.accept(true)
        }
    }
    
    init(dataSourceProvider: DataProvider<ArtistResponseModel>, coordinator: Coordinator?) {
        self.dataSourceProvider = dataSourceProvider
        output = Output(isLoadingMore: isLoadingMoreSubject.asObservable(), isRefresh: isRefreshSubject.asObservable(), isLoading: isLoadingSubject.asObservable(), artists: artistsSubject.asObservable(), error: errorSubject.asObservable())
        handleArtistDataResponse()
        self.coordinator = coordinator as? SearchArtistCoordinator
    }
    
    public func loadMoreArtists() {
        if !isLoadingMoreSubject.value && artistList.count < total {
            page = page + 1
            isLoadingMoreSubject.accept(true)
            fetchArtists()
        }
    }
    public func resetArtistList() {
        if !artistName.isEmpty {
            page = 1
            artistList.removeAll()
            isRefreshSubject.accept(true)
            fetchArtists()
        }else {
            isRefreshSubject.accept(false)
        }
    }
    
    public func didSelectArtist(artist: Artist) {
        coordinator?.showAlbumsList(with: artist)
    }

    private func fetchArtists() {
        let searchArtistParameters = SearchArtistParameters(artistName: artistName, page: page)
        self.dataSourceProvider.setApiParameters(params: searchArtistParameters.dictionary)
        self.dataSourceProvider.execute()
    }

    private func mapToArtistResponse(artistListResponse: [ArtistModel]?)-> [Artist] {
        if let artistListResponse = artistListResponse {
            return artistListResponse.map{Artist(id: $0.id ?? $0.name, name: $0.name, image: $0.images?.first?.url, numberOfListeners: $0.listeners)}
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
    

    
    private func addArtistToList(artistResponse: ArtistResponseModel) {
        let mappedArtists = mapToArtistResponse(artistListResponse: artistResponse.results?.artistMatches?.artist)
        artistList.append(contentsOf: mappedArtists)
        artistsSubject.onNext(artistList)
        resetAllLoaders()
    }
    
    private func handleArtistListResponse(artistResponse: ArtistResponseModel) {
        if let totalArtists = artistResponse.results?.total {
            total = Int(totalArtists) ?? 0
        }
        if !isLoadingMoreSubject.value {
            artistList.removeAll()
        }
        addArtistToList(artistResponse: artistResponse)
    }
    
    private func handleArtistDataResponse() {
        dataSourceProvider
            .observableResponse
            .subscribe(onNext: { [weak self] (response) in
                guard let self = self else { return }
                if let artistResponse = response.0 {
                    self.handleArtistListResponse(artistResponse: artistResponse)
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
