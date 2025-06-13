//
//  SceneDelegate.swift
//  Foundly
//
//  Created by mars uzhanov on 16.02.2025.
//

import UIKit
import StreamChat

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        if(UserDefaults.standard.bool(forKey: "notFirstInApp") == false){
            UserDefaults.standard.set(true, forKey: "notFirstInApp")
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            window?.makeKeyAndVisible()
            window?.rootViewController = OnboardingPageViewController()
        } else {
            let isLoggedIn = UserDefaults.standard.string(forKey: "accessToken") != nil
            let rootVC = isLoggedIn ? CustomTabBarController() : UINavigationController(rootViewController: LoginViewController())
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(frame: windowScene.coordinateSpace.bounds)
            window?.windowScene = windowScene
            window?.rootViewController = rootVC
            window?.makeKeyAndVisible()
        }
        
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
//        window?.windowScene = windowScene
//
//        let registerVC = RegisterEmailViewController()
//        let navController = UINavigationController(rootViewController: registerVC)
//        window?.rootViewController = navController
//
//        window?.makeKeyAndVisible()
//        
        
    
    }
}

