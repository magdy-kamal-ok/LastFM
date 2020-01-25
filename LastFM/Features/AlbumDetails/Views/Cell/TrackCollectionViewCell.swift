//
//  TrackCollectionViewCell.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/25/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(track: TrackModel) {
        trackNameLabel.text = track.name
        trackDurationLabel.text = track.duration
    }
}
