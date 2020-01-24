//
//  UICollectionViewExtension.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/23/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerCellNib<Cell: UICollectionViewCell>(cellClass: Cell.Type) {
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Cell.self))
    }
    
    
    func dequeue<Cell: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
    
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error in dequeue cell")
        }
        
        return cell
    }
}

