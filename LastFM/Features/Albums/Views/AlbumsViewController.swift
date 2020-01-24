//
//  AlbumsViewController.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumsViewController: BaseAlbumsViewController {

    private var albumsViewModel: AlbumsViewModel!
    private var albumsList: [Album] = []
    private var disposeBag = DisposeBag()
    private var artistName: String = ""
    
    init(with viewModel: AlbumsViewModel, artistName: String) {
        let bundel = Bundle(for: AlbumsViewController.self)
        super.init(nibName: "AlbumsViewController", bundle: bundel)
        self.artistName = artistName
        self.albumsViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPagination()
        setupSwipeRefresh()
        bindIsLoading()
        bindIsRefresh()
        bindIsLoadingMore()
        bindArtistList()
        albumsViewModel.artistName = artistName

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = self.artistName
    }
    
    override func setupCellNibNames() {
        albumsTableView.registerCellNib(cellClass: AlbumTableViewCell.self)
    }
    
    override func getCellsCount(with section: Int) -> Int {
        return albumsList.count
    }
    
    override func getCellHeight(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func getCustomCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as AlbumTableViewCell
        cell.configureCell(album: albumsList[indexPath.row])
        return cell
    }
    
    override func handlePaginationRequest() {
        albumsViewModel.loadMoreAlbums()
    }
    
    override func swipeRefreshTableView() {
        albumsViewModel.resetAlbumList()
    }
    
    override func getSectionsCount() -> Int {
        return 1
    }
}

extension AlbumsViewController {
    
    private func bindArtistList() {
        albumsViewModel
        .output
        .albums
        .asObservable().subscribe(onNext: { [weak self] (albums) in
            guard let self = self else {return}
            self.albumsList = albums
            self.albumsTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func bindIsRefresh() {
        albumsViewModel
               .output
               .isLoadingMore
               .asObservable()
               .bind { [weak self](flag) in
                       guard let self = self else {return}
                       if flag {
                           self.startRefreshTableView()
                       }else {
                           self.endRefreshTableView()
                       }
               }.disposed(by: disposeBag)
        
    }
    
    private func bindIsLoadingMore() {
        albumsViewModel
        .output
        .isLoadingMore
        .asObservable()
        .bind { [weak self](flag) in
                guard let self = self else {return}
                if flag {
                    self.showLoadingMoreView()
                }else {
                    self.removeLoadingMoreView()
                }
        }.disposed(by: disposeBag)
    }
    
    private func bindIsLoading() {
        albumsViewModel
        .output
        .isLoadingMore
        .map { !$0 }
        .bind(to: self.loadingIndicator.rx.isHidden)
        .disposed(by: self.disposeBag)
    }
    
}
