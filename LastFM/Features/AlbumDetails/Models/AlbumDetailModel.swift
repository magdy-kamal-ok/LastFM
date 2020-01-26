//
//  AlbumDetailModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/25/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import Realm

struct AlbumDetailModel {
    
    var artist: Artist
    var album: Album
    var tracks: [Track]
    
    init(artist: Artist, album: Album, tracks:[Track]) {
        self.album = album
        self.artist = artist
        self.tracks = tracks
    }
    init(localAlbumDetailsModel: LocalAlbumDetailsModel) {
        self.album = Album(id: localAlbumDetailsModel.album?.albumId, name: localAlbumDetailsModel.album?.name, image: localAlbumDetailsModel.album?.image, numberOfPlays: Int(localAlbumDetailsModel.album?.numberOfPlays ?? "0"))
        self.artist = Artist(id: localAlbumDetailsModel.artist?.artistId, name: localAlbumDetailsModel.artist?.name, image: localAlbumDetailsModel.artist?.image, numberOfListeners: localAlbumDetailsModel.album?.numberOfPlays)
        self.tracks = localAlbumDetailsModel.tracks.map{Track(name: $0.name, duration: $0.duration)}
    }
}

public struct Track {
    var name: String?
    var duration: String?
}
