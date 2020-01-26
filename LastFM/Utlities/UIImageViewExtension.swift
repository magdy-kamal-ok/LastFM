//
//  UIImageViewExtension.swift
//  LastFM
//
//  Created by Magdy Kamal on 1/26/20.
//  Copyright © 2020 OwnProjects. All rights reserved.
//

import UIKit
import AlamofireImage
extension UIImageView {
    
    func downloadImageFromUrlString(url: String?, placeHolder: String = "ic-empy-gallery") {
        let placeholderImage = UIImage(named: placeHolder)!
        if let imageUrl = url, let url = URL(string: imageUrl)  {
            
            self.af_setImage(withURL: url, placeholderImage: placeholderImage)

        }else {
            self.image = placeholderImage
        }
    }
}
