//
//  AlbumDetailsViewController.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/25/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage

class AlbumDetailsViewController: UIViewController {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var tracksCollectionView: UICollectionView!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistListenserLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var downloadButton: UIButton!

    private var albumDetailsViewModel: AlbumDetailsViewModel!
    private var artist: Artist
    private var album: Album
    private var tracks: [Track]?
    private var disposeBag = DisposeBag()
   
    init(with viewModel: AlbumDetailsViewModel, artist: Artist, album: Album) {
        self.artist = artist
        self.album = album
        let bundel = Bundle(for: AlbumDetailsViewController.self)
        super.init(nibName: "AlbumDetailsViewController", bundle: bundel)
        self.albumDetailsViewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindIsLoading()
        bindTrackList()
        bindDownloadButtonImage()
        bindAlbumsDetailsError()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewData()
        albumDetailsViewModel.fetchAlbumDetials()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didPressDownloadButton(_ sender: UIButton) {
        albumDetailsViewModel.handleDownloadButtonAction()
    }

}
extension AlbumDetailsViewController {

    private func setupCollectionView() {
        tracksCollectionView.registerCellNib(cellClass: TrackCollectionViewCell.self)
        tracksCollectionView.delegate = self
        tracksCollectionView.dataSource = self
    }
    
    private func setupViewData() {
        title = album.name
        artistNameLabel.text = artist.name
        artistListenserLabel.text = artist.numberOfListeners
        if let imageUrl = album.image, let url = URL(string: imageUrl)  {
            self.albumImageView.af_setImage(withURL: url)
        }
        if let imageUrl = artist.image, let url = URL(string: imageUrl)  {
            self.artistImageView.af_setImage(withURL: url)
        }
    }
    
    private func showErrorAlert(error: ErrorModel) {
        let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
extension AlbumDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(forIndexPath: indexPath) as TrackCollectionViewCell
        cell.configureCell(track: tracks![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
}

extension AlbumDetailsViewController {
    
    private func bindAlbumsDetailsError() {
        albumDetailsViewModel
        .output
        .error
        .bind {
            [weak self](error) in
            guard let self = self else {return}
            self.showErrorAlert(error: error)
        }.disposed(by: disposeBag)
    }
    
    private func bindDownloadButtonImage() {
        albumDetailsViewModel
        .output
        .isCached
        .asObservable().subscribe(onNext: { [weak self] (isCached) in
            guard let self = self else {return}
            if isCached {
                self.downloadButton.setImage(UIImage(named: "ic-delete"), for: .normal)
            }else {
                self.downloadButton.setImage(UIImage(named: "ic-download"), for: .normal)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindTrackList() {
        albumDetailsViewModel
        .output
        .albumDetails
        .map{$0.tracks}
        .asObservable().subscribe(onNext: { [weak self] (tracks) in
            guard let self = self else {return}
            self.tracks = tracks
            self.tracksCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
   
    private func bindIsLoading() {
        albumDetailsViewModel
        .output
        .isLoading
        .map { !$0 }
        .bind(to: self.loadingIndicator.rx.isHidden)
        .disposed(by: self.disposeBag)
    }
    
}
