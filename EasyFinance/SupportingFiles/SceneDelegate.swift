//
//  SceneDelegate.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var splashWindow: UIWindow?
    
    static var statusBarHeight: CGFloat?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        presentSplash(scene: scene)
        
        SceneDelegate.statusBarHeight = scene.statusBarManager?.statusBarFrame.height
    }
    
    private func presentSplash(scene: UIWindowScene) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: SplashViewController.self))
        
        guard let splashViewController = viewController as? SplashViewController
            else { return }
        
        splashWindow = UIWindow(windowScene: scene)
        splashWindow?.frame = UIScreen.main.bounds
        splashWindow?.windowLevel = .normal + 1
        splashWindow?.rootViewController = splashViewController
        splashWindow?.isHidden = false
        
        let delay: TimeInterval = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: 0.2, animations: {
                splashViewController.view.alpha = 0
            }) { _ in
                self.splashWindow?.isHidden = true
            }
        }
    }
}
