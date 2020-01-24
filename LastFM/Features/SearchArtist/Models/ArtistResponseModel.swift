//
//  ArtistResponseModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

struct ArtistResponseModel: Decodable {
    var results: ArtistResultsModel?
    
    struct ArtistResultsModel: Decodable {
        var total: String?
        var artistMatches: ArtistMatchesModel?
        enum CodingKeys: String, CodingKey {
            case total = "opensearch:totalResults"
            case artistMatches = "artistmatches"
        }
    }
    
    struct ArtistMatchesModel: Decodable {
        var artist: [ArtistModel]?
    }
}

struct ArtistModel: Decodable {
    var name: String?
    var images: [ImageModel]?
    var listeners: String?
    var id: String?
    enum CodingKeys: String, CodingKey {
        case id     = "mbid"
        case images = "image"
        case name
        case listeners
    }
}

struct ImageModel: Decodable {
    var url: String?

    enum CodingKeys: String, CodingKey {
        case url    = "#text"
    }
}
