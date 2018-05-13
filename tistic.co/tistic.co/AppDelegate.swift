//
//  AppDelegate.swift
//  tistic.co
//
//  Created by Yan Khamutouski on 3/14/18.
//  Copyright © 2018 Yan Khamutouski. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        UITabBar.appearance().tintColor = UIColor(red:0.47, green:0.69, blue:0.44, alpha:1.0)
        UITabBar.appearance().backgroundColor = UIColor(red:0.97, green:0.95, blue:0.95, alpha:1.0)
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        if (Auth.auth().currentUser?.uid != nil) {
            showMainScreen()
            self.refreshUserStatus()
        }
        
        return true
    }
    func showMainScreen() {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "MainTabBar") as UIViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        self.updateStatusOfUser()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        self.refreshUserStatus()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.updateStatusOfUser()
    }
    private func updateStatusOfUser() {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(uid)
            ref.updateChildValues(["status":"offline"]) { (error, reference) in
                if error != nil {
                    print(error!)
                    return
                }
            }
        }
    }
   private func refreshUserStatus() {
        if let uid = Auth.auth().currentUser?.uid {
            let ref = Database.database().reference().child("users").child(uid)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String : Any] {
                    if let statusCustom = dictionary["statusCustom"] as? String {
                        ref.updateChildValues(["status": statusCustom], withCompletionBlock: { (error, referecne) in
                            if error != nil {
                                print(error!)
                            }
                        })
                    }
                    else {
                        ref.updateChildValues(["status": "online"], withCompletionBlock: { (error, referecne) in
                            if error != nil {
                                print(error!)
                            }
                        })
                    }
                }
            }, withCancel: nil)
        }
    }

}

