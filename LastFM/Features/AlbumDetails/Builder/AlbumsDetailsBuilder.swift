//
//  AlbumsDetailsBuilder.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/25/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit

public struct AlbumsDetailsBuilder {

    public static func viewController(artist: Artist, album: Album, coordinator: Coordinator) -> UIViewController {
        let requestHandler = RequestFactory(url: Constants.baseUrl)
        let dataSourceProvider = DataProvider<AlbumDetailsResponseModel>(requestHandler: requestHandler)
        let albumDetailsViewModel = AlbumDetailsViewModel(dataSourceProvider: dataSourceProvider, artist: artist, album: album, coordinator: coordinator)
        let viewController = AlbumDetailsViewController(with: albumDetailsViewModel, artist: artist, album: album)
        return viewController
    }
}
