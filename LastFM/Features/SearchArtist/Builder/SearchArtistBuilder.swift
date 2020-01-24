//
//  SearchArtistBuilder.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//
import UIKit

public struct SearchArtistBuilder: BuilderProtocol {


    public static func viewController() -> UIViewController {
        let requestHandler = RequestFactory.init(url: Constants.baseUrl)
        let dataSourceProvider = DataSourceProvider<ArtistResponseModel>(requestHandler: requestHandler)
        let searchArtistViewModel = SearchArtistViewModel(dataSourceProvider: dataSourceProvider)
        let viewController = SearchArtistViewController(with: searchArtistViewModel)
        return viewController
    }
}
public protocol BuilderProtocol {
    static func viewController() -> UIViewController
}
