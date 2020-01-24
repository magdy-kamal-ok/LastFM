//
//  AlbumsParameters.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

struct AlbumsParameters: Encodable {
    
    private var method: String = Constants.albumsMethod
    private var api_key: String = Constants.apiKey
    private var format: String = Constants.format
    private var artist: String = ""
    private var page: Int = 0
    
    init(artistName: String, page: Int) {
        self.artist = artistName
        self.page = page
    }
}
