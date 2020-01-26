//
//  AppCoordinator.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/26/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: NSObject, Coordinator
{
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let child = MainScreenCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        addViewToNavigationStack(coordinator: child)
        child.start()
    }
    
    func showAlbumsList(with arist: Artist){
        let child = AlbumListCoordinator(navigationController: navigationController)
        child.artist = arist
        child.parentCoordinator = self
        addViewToNavigationStack(coordinator: child)
        child.start()
    }
    
    func showAlbumDetailsView(with album : Album, arist: Artist){
        let child = AlbumDetailsCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        child.artist = arist
        child.album = album
        addViewToNavigationStack(coordinator: child)
        child.start()
    }
    
    func showSearchView() {
        let child = SearchArtistCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        addViewToNavigationStack(coordinator: child)
        child.start()
    }
//    func showTeamsView(with competition : Competitions?) {
//        let child = TeamsCoordinator(navigationController: navigationController)
//        child.competitioon = competition
//        child.parentCoordinator = self
//        addViewToNavigationStack(coordinator: child)
//        child.start()
//    }
//    func showMatchesView(with team : TeamsModel?) {
//        let child = MatchCoordinator(navigationController: navigationController)
//        child.team = team
//        child.parentCoordinator = self
//        addViewToNavigationStack(coordinator: child)
//        child.start()
//    }

    func addViewToNavigationStack(coordinator : Coordinator){
        navigationController.delegate = self
        childCoordinators.append(coordinator)
    }
}
extension AppCoordinator : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
    }
}
extension AppCoordinator {
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
