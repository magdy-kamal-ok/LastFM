//
//  MainScreenCoordinator.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/26/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import UIKit
class MainScreenCoordinator: NSObject, Coordinator
{
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let vc = MainScreenBuilder.viewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAlbumDetailsView(with album : Album, arist: Artist){
        parentCoordinator?.showAlbumDetailsView(with: album, arist: arist)
    }
    
    func showSearchView() {
        parentCoordinator?.showSearchView()
    }
}
