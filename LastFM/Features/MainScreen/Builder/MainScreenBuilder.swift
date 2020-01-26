//
//  MainScreenBuilder.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/25/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit

public struct MainScreenBuilder {

    public static func viewController() -> UIViewController {
        let mainScreenViewModel = MainScreenViewModel()
        let viewController = MainScreenViewController(with: mainScreenViewModel)
        return viewController
    }
}
