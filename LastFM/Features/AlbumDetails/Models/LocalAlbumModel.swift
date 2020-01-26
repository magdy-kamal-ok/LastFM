//
//  LocalAlbumModel.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class LocalAlbumDetailsModel: Object {
    
    @objc dynamic var artist: LocalArtistModel?
    @objc dynamic var album: LocalAlbumModel?
    var tracks: List<LocalTrackModel> = List<LocalTrackModel>()
    @objc dynamic var compoundKey: String = ""
    @objc dynamic var albumId: String = "" 
    @objc dynamic var artistId: String = ""
    
    required init() {
        artist = LocalArtistModel()
        album = LocalAlbumModel()
    }
    
    required convenience init(artist: LocalArtistModel, album: LocalAlbumModel, tracks: [LocalTrackModel]) {
        self.init()
        self.artist = artist
        self.album = album
        let list = List<LocalTrackModel>()
        list.append(objectsIn: tracks)
        self.tracks = list
        if let albumId = self.album?.albumId {
            self.albumId = albumId
        }
        if let artistId = self.artist?.artistId {
            self.artistId = artistId
        }
        self.compoundKey = compoundKeyValue()
    }
    
    
    override class func primaryKey() -> String? {
        return "compoundKey";
    }
    
    private func compoundKeyValue() -> String {
        return "\(albumId)-\(artistId)"
    }
}

class LocalAlbumModel: Object {
    
    @objc dynamic var albumId: String = ""
    @objc dynamic var name: String?
    @objc dynamic var image: String?
    @objc dynamic var numberOfPlays: String?
    
    required init() {
    }
    
    required convenience init(albumId: String, name: String?, image: String?, numberOfPlays: String?) {
        self.init()
        self.albumId = albumId
        self.name = name
        self.image = image
        self.numberOfPlays = numberOfPlays
    }
    
    
    override class func primaryKey() -> String? {
        return "albumId"
    }
}

class LocalArtistModel: Object {
    
    @objc dynamic var artistId: String = ""
    @objc dynamic var name: String?
    @objc dynamic var image: String?
    @objc dynamic var numberOfListners: String?
    
     required init() {
    }
    
    required convenience init(artistId: String, name: String?, image: String?, numberOfListners: String?) {
        self.init()
        self.artistId = artistId
        self.name = name
        self.image = image
        self.numberOfListners = numberOfListners
    }
}

class LocalTrackModel: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var duration: String?
    
    required init() {
    }
    
    required convenience init(name: String?, duration: String?) {
        self.init()
        self.name = name
        self.duration = duration
    }

}
