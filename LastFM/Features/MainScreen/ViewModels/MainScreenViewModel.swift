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
    
    init() {
        self.albumDetailsRrepository = AlbumsDetialsRepository(dataSourceProvider: nil, cachingManager: RealmCachingManager(), artist: nil, album: nil)
        output = Output(isLoading: isLoadingSubject.asObservable(), albumDetails: self.albumDetailsRrepository.output.albumDetailsList.asObservable(), error: errorSubject.asObservable())
        
    }
    
    func fetchAlbumDetials() {
        albumDetailsRrepository.fetchAlbumListDetails()
    }
    
    private func handleError() {
        
    }
    

}
