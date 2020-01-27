//
//  ArtistResponseModelStub.swift
//  LastFMTests
//
//  Created by Magdy Kamal on 1/27/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation

struct ArtistResponseModelStub: Decodable {
    var results: ArtistResultsModelStub?
    
    struct ArtistResultsModelStub: Decodable {
        var total: String?
        var artistMatches: ArtistMatchesModelStub?
        enum CodingKeys: String, CodingKey {
            case total = "opensearch:totalResults"
            case artistMatches = "artistmatches"
        }
    }
    
    struct ArtistMatchesModelStub: Decodable {
        var artist: [ArtistModelStub]?
    }
}

struct ArtistModelStub: Decodable {
    var name: String?
    var images: [ImageModelStub]?
    var listeners: String?
    var id: String?
    enum CodingKeys: String, CodingKey {
        case id     = "mbid"
        case images = "image"
        case name
        case listeners
    }
}

struct ImageModelStub: Decodable {
    var url: String?

    enum CodingKeys: String, CodingKey {
        case url    = "#text"
    }
}
