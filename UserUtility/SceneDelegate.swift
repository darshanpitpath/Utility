//
//  SceneDelegate.swift
//  UserUtility
//
//  Created by IPS on 07/04/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var isLoadFromBackground = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let objWindowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow.init(windowScene: objWindowScene)
        
        let mainStroryboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let splashViewController = mainStroryboard.instantiateViewController(identifier: "SplashVideoViewController") as? SplashVideoViewController, let objWindow = self.window{
            let objRootViewController = UINavigationController.init(rootViewController: splashViewController)
            objRootViewController.navigationBar.isHidden = true
            objWindow.rootViewController = objRootViewController
            objWindow.makeKeyAndVisible()
        }
       
        
    }
    func presentAlertOnRootWindow(){
        let objAlertView = UIAlertController.init(title: "Test scene Delegate", message: "Test Scene delegate", preferredStyle: .alert)
        let objAlertAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        objAlertView.addAction(objAlertAction)
        if let rootViewController = window?.rootViewController{
            rootViewController.present(objAlertView, animated: true, completion: nil)
        }
      }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        if let objNavigation = self.window?.rootViewController as? UINavigationController, self.isLoadFromBackground{
            DispatchQueue.main.async {
                objNavigation.viewControllers.last?.viewWillAppear(true)
            }
        }
        
        print("sceneDidBecomeActive")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("sceneWillEnterForeground")
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        self.isLoadFromBackground = true
        print("sceneDidEnterBackground")
    }
}


