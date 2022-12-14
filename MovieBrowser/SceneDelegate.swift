//
//  SceneDelegate.swift
//  MovieBrowser
//
//  Created by Karol Wieczorek on 04/11/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let apiManager = ApiManager()
        let genresProvider = GenresProvider(apiManager: apiManager)
        let configurationProvider = ConfigurationProvider(apiManager: apiManager)
        configurationProvider.getConfiguration { result in
            switch result {
            case .success(let configuration):
                let baseURL = configuration.images.baseURL
                let imageSize = configuration.images.posterSizes[3] // picks "w342", ideally you could pick between all sizes because they could change
                ConfigurationSettings.shared.configureImagePath(imageBaseURL: baseURL, imageSize: imageSize)
            case .failure(let error):
                print("Error getting configuration \(error)")
            }
        }
        let genresVM = GenresViewModel(genresProvider: genresProvider)
        let genresViewController = GenresViewController(vm: genresVM)

        window?.rootViewController = UINavigationController(rootViewController: genresViewController)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

