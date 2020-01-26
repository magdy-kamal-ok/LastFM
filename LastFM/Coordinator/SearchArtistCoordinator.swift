//
//  SearchArtistCoordinator.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/26/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import UIKit
class SearchArtistCoordinator: NSObject, Coordinator
{
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SearchArtistBuilder.viewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAlbumsList(with arist: Artist){
        parentCoordinator?.showAlbumsList(with: arist)
    }
    
}
