//
//  SearchArtistViewController.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit
import RxSwift

class SearchArtistViewController: BaseSearchArtistViewController {

    private var searchArtistViewModel: SearchArtistViewModel!
    private var artistList: [Artist] = []
    private var disposeBag = DisposeBag()
    
    init(with viewModel: SearchArtistViewModel) {
        let bundel = Bundle(for: SearchArtistViewController.self)
        super.init(nibName: "SearchArtistViewController", bundle: bundel)
        self.searchArtistViewModel = viewModel
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
        bindArtistError()
        bindSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Search Artists"
        setNavigationBarButton()
    }
    
    private func setNavigationBarButton() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func setupCellNibNames() {
        artistsTableView.registerCellNib(cellClass: ArtistTableViewCell.self)
    }
    
    override func getCellsCount(with section: Int) -> Int {
        return artistList.count
    }
    
    override func getCellHeight(indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func getCustomCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ArtistTableViewCell
        cell.configureCell(artist: artistList[indexPath.row])
        return cell
    }
    
    override func handlePaginationRequest() {
        searchArtistViewModel.loadMoreArtists()
    }
    
    override func swipeRefreshTableView() {
        searchArtistViewModel.resetArtistList()
    }
    
    override func getSectionsCount() -> Int {
        return 1
    }
    
    override func didSelectCellAt(indexPath: IndexPath) {
        if let _ = artistList[indexPath.row].name {
            searchArtistViewModel.didSelectArtist(artist: artistList[indexPath.row])
        }
        
        
    }
    
    private func showErrorAlert(error: ErrorModel) {
        let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
extension SearchArtistViewController {
   
    private func bindArtistError() {
        searchArtistViewModel
            .output
            .error
            .bind {
                [weak self](error) in
                guard let self = self else {return}
                self.showErrorAlert(error: error)
            }.disposed(by: disposeBag)
    }
    
    private func bindArtistList() {
        searchArtistViewModel
            .output
            .artists
            .asObservable()
            .subscribe(onNext: { [weak self] (artists) in
                guard let self = self else {return}
                self.artistList = artists
                self.artistsTableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func bindIsRefresh() {
        searchArtistViewModel
            .output
            .isRefresh
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
        searchArtistViewModel
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
        searchArtistViewModel
            .output
            .isLoading
            .map { !$0 }
            .bind(to: self.loadingIndicator.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    
    private func bindSearchBar() {
        artistSearchBar
            .rx
            .text
            .orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .bind { (searchText) in
                self.searchArtistViewModel.artistName = searchText
        }.disposed(by: disposeBag)
    }
}
