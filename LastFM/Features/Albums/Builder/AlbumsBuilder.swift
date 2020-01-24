//
//  AlbumsBuilder.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit

public struct AlbumsBuilder {

    public static func viewController(artist: Artist) -> UIViewController {
        let requestHandler = RequestFactory.init(url: Constants.baseUrl)
        let dataSourceProvider = DataProvider<AlbumsResponseModel>(requestHandler: requestHandler)
        let albumsViewModel = AlbumsViewModel(dataSourceProvider: dataSourceProvider)
        let viewController = AlbumsViewController(with: albumsViewModel, artist: artist)
        return viewController
    }
}
