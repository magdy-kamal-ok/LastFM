//
//  AlbumsBuilder.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/24/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit

public struct AlbumsBuilder {

    public static func viewController(artistName: String) -> UIViewController {
        let requestHandler = RequestFactory.init(url: Constants.baseUrl)
        let dataSourceProvider = DataSourceProvider<AlbumsResponseModel>(requestHandler: requestHandler)
        let albumsViewModel = AlbumsViewModel(dataSourceProvider: dataSourceProvider)
        let viewController = AlbumsViewController(with: albumsViewModel, artistName: artistName)
        return viewController
    }
}
