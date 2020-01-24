//
//  AlbumsResponseModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

struct AlbumsResponseModel: Decodable {
    var topAlbums: TopAlbumListModel?
    
    enum CodingKeys: String, CodingKey {
        case topAlbums     = "topalbums"
    }
}

struct TopAlbumListModel: Decodable {
    var albums: [AlbumModel]?
    var otherAttributes: OtherAttributes
    enum CodingKeys: String, CodingKey {
        case albums     = "album"
        case otherAttributes = "@attr"
    }
    
    struct OtherAttributes: Decodable {
        var total: String?
    }
}

struct AlbumModel: Decodable {
    var name: String?
    var playcount: Int?
    var artist: ArtistModel?
    var images: [ImageModel]?
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case images     = "image"
        case id         = "mbid"
        case artist
        case playcount
        case name
    }
}
