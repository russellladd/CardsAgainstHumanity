//
//  CardCell.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    // MARK: Text label
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var cahLabel: UILabel!
    
    // MARK: Card view
    
    @IBOutlet weak var cardView: UIView!
    
    var faceUp: Bool = false {
        didSet {
            self.textLabel.hidden = !faceUp
            self.cahLabel.hidden = faceUp
        }
    }
    
    func setFaceUp(faceUp: Bool, animated: Bool) {
        
        let transition: UIViewAnimationOptions = faceUp ? .TransitionFlipFromRight : .TransitionFlipFromLeft
        
        UIView.transitionWithView(cardView, duration: animated ? 0.5 : 0.0, options: transition, animations: {
            
            self.faceUp = faceUp
            
            }, completion: nil)
    }
    
    // MARK: Scroll view
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cardView.layer.cornerRadius = 20.0
        
        cardView.layer.shadowColor = UIColor(white: 0.75, alpha: 1.0).CGColor
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.shadowRadius = 1.0
        cardView.layer.shadowOffset = CGSizeZero
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardView.layer.shadowPath = UIBezierPath(roundedRect: CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height), cornerRadius: 20.0).CGPath
    }
}
