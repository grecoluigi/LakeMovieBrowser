//
//  UIImageView+.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import UIKit
extension UIImageView {
    func fade(to image: UIImage) {
        UIView.transition(with: self,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.image = image },
                          completion: nil)
    }
}
