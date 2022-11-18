//
//  UIView+.swift
//  MovieBrowser
//
//  Created by Luigi on 17/11/2022.
//

import UIKit

extension UIView {
    func addShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}

