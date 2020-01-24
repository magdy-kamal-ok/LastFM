//
//  SearchArtistParameters.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

struct SearchArtistParameters: Encodable {
    
    private var method: String = Constants.searchArtistMethod
    private var api_key: String = Constants.apiKey
    private var format: String = Constants.format
    private var artist: String = ""
    private var page: Int = 0
    
    init(artistName: String, page: Int) {
        self.artist = artistName
        self.page = page
    }
}
