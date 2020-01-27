//
//  SearchArtistBuilder.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//
import UIKit

public struct SearchArtistBuilder {


    public static func viewController(coordinator: Coordinator) -> UIViewController {
        let requestHandler = RequestFactory(url: Constants.baseUrl)
        let dataSourceProvider = DataProvider<ArtistResponseModel>(requestHandler: requestHandler)
        let searchArtistViewModel = SearchArtistViewModel(dataSourceProvider: dataSourceProvider, coordinator: coordinator)
        let viewController = SearchArtistViewController(with: searchArtistViewModel)
        return viewController
    }
}
