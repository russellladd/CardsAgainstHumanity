//
//  NewGameViewController.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/19/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController, FloorViewControllerDelegate {
    
    // MARK: Status bar
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: Floor view controller delegate
    
    func floorViewControllerDidQuit(floorViewController: FloorViewController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showFloor" {
            
            let viewController = segue.destinationViewController as FloorViewController
            viewController.delegate = self
        }
    }
}
