//
//  AppDelegate.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        window = UIWindow()
        window!.makeKeyAndVisible()
        window!.frame = UIScreen.mainScreen().bounds
        
        switch window!.traitCollection.userInterfaceIdiom {
            
        case .Phone:
            window!.rootViewController = (UIStoryboard(name: "Phone", bundle: nil).instantiateInitialViewController() as UIViewController)
        case .Pad:
            window!.rootViewController = (UIStoryboard(name: "Pad", bundle: nil).instantiateInitialViewController() as UIViewController)
        default:
            assertionFailure("Device must be phone or pad")
        }
        
        return true
    }
}
