//
//  ArtistTableViewCell.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistListenserLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(artist: Artist) {
        artistNameLabel.text = artist.name
        artistListenserLabel.text = artist.numberOfListeners
        self.artistImageView.downloadImageFromUrlString(url: artist.image, placeHolder: "ic-empty-artist")
    }
}
