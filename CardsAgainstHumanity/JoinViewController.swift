//
//  MainViewController.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController, BrowserViewControllerDelegate {
    
    // MARK: Status bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: Browser view controller delegate
    
    func browserViewControllerDidCancel(browserViewController: BrowserViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerDidFinish(browserViewController: BrowserViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showBrowser" {
            
            let navigation = segue.destinationViewController as UINavigationController
            let viewController = navigation.viewControllers.first as BrowserViewController
            viewController.delegate = self
        }
    }
}
