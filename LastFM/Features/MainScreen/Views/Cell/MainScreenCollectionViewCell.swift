//
//  MainScreenCollectionViewCell.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/25/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit

class MainScreenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistListenserLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(albumDetailsModel: AlbumDetailModel) {
        
        artistNameLabel.text = albumDetailsModel.artist.name
        artistListenserLabel.text = albumDetailsModel.artist.numberOfListeners
        albumNameLabel.text = albumDetailsModel.album.name
        if let imageUrl = albumDetailsModel.album.image, let url = URL(string: imageUrl)  {
            self.albumImageView.af_setImage(withURL: url)
        }
        if let imageUrl = albumDetailsModel.artist.image, let url = URL(string: imageUrl)  {
            self.artistImageView.af_setImage(withURL: url)
        }
    }
}
