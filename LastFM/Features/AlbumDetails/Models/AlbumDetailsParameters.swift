//
//  AlbumDetailsParameters.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

struct AlbumDetailsParameters: Encodable {
    
    private var method: String = Constants.albumsDetailsMethod
    private var api_key: String = Constants.apiKey
    private var format: String = Constants.format
    private var artist: String = ""
    private var album: String = ""
    
    init(artistName: String, album: String) {
        self.artist = artistName
        self.album = album
    }
}
