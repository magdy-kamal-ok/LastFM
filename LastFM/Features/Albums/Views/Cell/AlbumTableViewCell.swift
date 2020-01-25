//
//  AlbumTableViewCell.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift
import RxCocoa

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumPlaysCountLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    private var disposeBag = DisposeBag()
    var albumDetailsViewModel: AlbumDetailsViewModel?
    var didPressDownloadButton: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        didPressDownloadButton = nil
        albumDetailsViewModel = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(artist: Artist, album: Album) {
        albumNameLabel.text = album.name
        if let playsCount = album.numberOfPlays {
            albumPlaysCountLabel.text = String(playsCount)
        }
        if let imageUrl = album.image, let url = URL(string: imageUrl)  {
            self.albumImageView.af_setImage(withURL: url)
        }
        let requestHandler = RequestFactory.init(url: Constants.baseUrl)
        let dataSourceProvider = DataProvider<AlbumDetailsResponseModel>(requestHandler: requestHandler)
        albumDetailsViewModel = AlbumDetailsViewModel(dataSourceProvider: dataSourceProvider, artist: artist, album: album)
        bindDownloadButtonImage()
    }
    
    @IBAction func didPressDownloadButton(_ sender: UIButton) {
        albumDetailsViewModel?.handleDownloadButtonAction()
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
