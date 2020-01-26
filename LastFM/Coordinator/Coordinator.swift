//
//  Coordinator.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/26/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import Foundation
import UIKit
public protocol Coordinator: NSObject
{
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
