//
//  AlbumDetailsCoordinator.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/26/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import UIKit
class AlbumDetailsCoordinator: NSObject, Coordinator
{
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var artist: Artist!
    var album: Album!
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AlbumsDetailsBuilder.viewController(artist: artist, album: album, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
