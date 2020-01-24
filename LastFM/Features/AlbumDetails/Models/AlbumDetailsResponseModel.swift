//
//  AlbumDetailsResponseModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

struct AlbumDetailsResponseModel: Decodable {
    var albumDetailsModel: AlbumDetailsModel?
    
    enum CodingKeys: String, CodingKey {
        case albumDetailsModel     = "album"
    }
}

struct AlbumDetailsModel: Decodable {
    
    var albumName: String?
    var artistName: String?
    var playcount: String?
    var listeners: String?
    var images: [ImageModel]?
    var tracksModel: TracksListModel?
    enum CodingKeys: String, CodingKey {
        case albumName      = "name"
        case artistName     = "artist"
        case images         = "image"
        case tracksModel    = "tracks"
        case playcount
        case listeners

    }
    
    struct TracksListModel: Decodable {
        var tracks: [TrackModel]?
        enum CodingKeys: String, CodingKey {
            case tracks     = "track"
        }
    }
    
}

struct TrackModel: Decodable {
    var name: String?
    var duration: String?
}
