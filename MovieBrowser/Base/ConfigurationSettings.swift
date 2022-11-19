//
//  ConfigurationSettings.swift
//  MovieBrowser
//
//  Created by Luigi on 18/11/2022.
//

import Foundation

class ConfigurationSettings {
    
    static let shared = ConfigurationSettings()
    
    private var imageBaseURL : String?
    private var imageSize : String?
    
    let limitMoviesToFifty : Bool = false
    
    func imageURL(from path: String) -> URL? {
        guard let imageBaseURL = imageBaseURL, let imageSize = imageSize else { return nil }
        return URL(string: imageBaseURL)?.appending(path: imageSize).appending(path: path)
    }
    
    func configureImagePath(imageBaseURL: String, imageSize: String) {
        self.imageBaseURL = imageBaseURL
        self.imageSize = imageSize
    }
}
