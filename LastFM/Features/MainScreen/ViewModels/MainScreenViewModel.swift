//
//  MainScreenViewModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/25/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MainScreenViewModel {

    struct Output {
            let isLoading: Observable<Bool>
            let albumDetails: Observable<[AlbumDetailModel]>
            let error: Observable<ErrorModel>
        }
    

    private var isLoadingSubject: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var errorSubject: PublishSubject<ErrorModel> = PublishSubject<ErrorModel>()
    
    private var disposeBag = DisposeBag()
    private let albumDetailsRrepository: AlbumsDetialsRepository
    public var output: Output!
    private weak var coordinator: MainScreenCoordinator?
    
    init(coordinator: Coordinator?) {
        self.albumDetailsRrepository = AlbumsDetialsRepository(dataSourceProvider: nil, cachingManager: RealmCachingManager(), artist: nil, album: nil)
        output = Output(isLoading: isLoadingSubject.asObservable(), albumDetails: self.albumDetailsRrepository.output.albumDetailsList.asObservable(), error: errorSubject.asObservable())
        self.coordinator = coordinator as? MainScreenCoordinator
        
    }
    
    func disSelectAlbumDetail(albumDetailModel: AlbumDetailModel) {
        coordinator?.showAlbumDetailsView(with: albumDetailModel.album, arist: albumDetailModel.artist)
    }
    func didClickSearchBarIcon() {
        coordinator?.showSearchView()
    }
    func fetchAlbumDetials() {
        albumDetailsRrepository.fetchAlbumListDetails()
    }
    
    private func handleError() {
        
    }
    

}
