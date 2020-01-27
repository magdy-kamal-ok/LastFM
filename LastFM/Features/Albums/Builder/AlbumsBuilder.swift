//
//  AlbumsBuilder.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit

public struct AlbumsBuilder {

    public static func viewController(artist: Artist, coordinator: Coordinator) -> UIViewController {
        let requestHandler = RequestFactory(url: Constants.baseUrl)
        let dataProvider = DataProvider<AlbumsResponseModel>(requestHandler: requestHandler)
        let albumsViewModel = AlbumsViewModel(dataProvider: dataProvider, artist: artist, coordinator: coordinator)
        let viewController = AlbumsViewController(with: albumsViewModel, artist: artist)
        return viewController
    }
}
