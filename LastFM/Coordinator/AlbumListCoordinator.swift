//
//  AlbumListCoordinator.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/26/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import UIKit
class AlbumListCoordinator: NSObject, Coordinator
{
    weak var parentCoordinator: AppCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var artist: Artist!
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AlbumsBuilder.viewController(artist: artist, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showAlbumsDetails(with arist: Artist, album: Album){
        parentCoordinator?.showAlbumDetailsView(with: album, arist: arist)
    }
    
}
