//
//  ArtistTableViewCell.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit
import AlamofireImage

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
        if let imageUrl = artist.image, let url = URL(string: imageUrl)  {
            self.artistImageView.af_setImage(withURL: url)
        }
    }
}
