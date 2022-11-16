//
//  UIAlertController+.swift
//  MovieBrowser
//
//  Created by Luigi Greco on 16/11/22.
//

import Foundation
import UIKit

extension UIAlertController {
    static func alert(_ title: String, _ message: String?, completion: @escaping (UIAlertAction) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok".localized, style: .default, handler: completion)
        alert.addAction(cancelAction)
        
        if let topVC = UIViewController.topViewController {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
}
