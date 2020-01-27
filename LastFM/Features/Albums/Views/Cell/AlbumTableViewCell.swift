//
//  AlbumTableViewCell.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumPlaysCountLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    private var disposeBag = DisposeBag()
    private var album: Album?
    var albumDetailsViewModel: AlbumDetailsViewModel?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        albumDetailsViewModel = nil
        album = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(artist: Artist, album: Album) {
        self.album = album
        albumNameLabel.text = album.name
        if let playsCount = album.numberOfPlays {
            albumPlaysCountLabel.text = String(playsCount)
        }
        self.albumImageView.downloadImageFromUrlString(url: album.image)
        let requestHandler = RequestFactory(url: Constants.baseUrl)
        let dataSourceProvider = DataProvider<AlbumDetailsResponseModel>(requestHandler: requestHandler)
        albumDetailsViewModel = AlbumDetailsViewModel(dataSourceProvider: dataSourceProvider, artist: artist, album: album, coordinator: nil)
        albumDetailsViewModel?.checkifAlbumExists()
        bindDownloadButtonImage()
    }
    
    @IBAction func didPressDownloadButton(_ sender: UIButton) {
        albumDetailsViewModel?.handleDownloadButtonAction(album: album)
    }
    private func bindDownloadButtonImage() {
        albumDetailsViewModel?
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
}
