//
//  AlbumTableViewCell.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumPlaysCountLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(album: Album) {
        albumNameLabel.text = album.name
        if let playsCount = album.numberOfPlays {
            albumPlaysCountLabel.text = String(playsCount)
        }
        if let imageUrl = album.image, let url = URL(string: imageUrl)  {
            self.albumImageView.af_setImage(withURL: url)
        }
    }
}
