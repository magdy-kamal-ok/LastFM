//
//  MainScreenViewController.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/25/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit
import RxSwift

class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    private var albumDetailsList: [AlbumDetailModel]?
    private var mainScreenViewModel: MainScreenViewModel!
    private var disposeBag = DisposeBag()
    
    init(with viewModel: MainScreenViewModel) {
        let bundel = Bundle(for: MainScreenViewController.self)
        super.init(nibName: "MainScreenViewController", bundle: bundel)
        self.mainScreenViewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindAlbumDetailsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addRightNavItem()
        title = "Main Screen"
        mainScreenViewModel.fetchAlbumDetials()
    }

    func addRightNavItem() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic-search"), style: .plain, target: self, action:#selector(didPressSearchIcon))
        rightBarButtonItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func didPressSearchIcon(){
        mainScreenViewModel.didClickSearchBarIcon()
    }
}
extension MainScreenViewController {

    private func setupCollectionView() {
        albumsCollectionView.registerCellNib(cellClass: MainScreenCollectionViewCell.self)
        albumsCollectionView.delegate = self
        albumsCollectionView.dataSource = self
    }
    
    private func bindAlbumDetailsList() {
        mainScreenViewModel
        .output
        .albumDetails
        .asObservable().subscribe(onNext: { [weak self] (albumDetailsList) in
            guard let self = self else {return}
            self.albumDetailsList = albumDetailsList
            self.albumsCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
}
extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumDetailsList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(forIndexPath: indexPath) as MainScreenCollectionViewCell
        cell.configureCell(albumDetailsModel: albumDetailsList![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let albumDetails = albumDetailsList![indexPath.row]
    mainScreenViewModel.disSelectAlbumDetail(albumDetailModel: albumDetails)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 230)
    }
}
