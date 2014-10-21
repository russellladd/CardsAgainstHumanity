//
//  HandLayout.swift
//  CardsAgainstHumanity
//
//  Created by Russell Ladd on 10/18/14.
//  Copyright (c) 2014 GRL5. All rights reserved.
//

import UIKit

class HandLayout: UICollectionViewLayout {
    
    // MARK: Properties
    
    var cardHeightToWidthRatio: CGFloat = 1.5 {
        didSet {
            invalidateLayout()
        }
    }
    
    var pulledCardIndexPath: NSIndexPath? {
        didSet {
            invalidateLayout()
        }
    }
    
    var pulledCardOffset: CGFloat = 0.0 {
        didSet {
            invalidateLayout()
        }
    }
    
    // MARK: Layout
    
    var cardToCardOffset = CGFloat(0.0)
    var cardHeight = CGFloat(0.0)
    
    var contentSize = CGSizeZero
    
    override func prepareLayout() {
        
        let contentHeight = collectionView!.bounds.size.height - collectionView!.contentInset.top - collectionView!.contentInset.bottom
        
        cardToCardOffset = contentHeight / CGFloat(collectionView!.numberOfItemsInSection(0))
        
        cardHeight = collectionView!.bounds.size.width * cardHeightToWidthRatio
        
        contentSize = CGSizeMake(collectionView!.bounds.size.width, contentHeight)
    }
    
    override func collectionViewContentSize() -> CGSize {
        return contentSize
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        return map(0..<collectionView!.numberOfItemsInSection(0)) { item in
            return self.layoutAttributesForItemAtIndexPath(NSIndexPath(forItem: item, inSection: 0))
        }
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        var pullOffset = CGFloat(0.0)
        
        if let pulledCardIndexPath = pulledCardIndexPath {
            if pulledCardIndexPath.item < indexPath.item {
                
                pullOffset = pulledCardOffset * CGFloat((collectionView!.numberOfItemsInSection(0) - pulledCardIndexPath.item) - (indexPath.item - pulledCardIndexPath.item)) / CGFloat(collectionView!.numberOfItemsInSection(0) - pulledCardIndexPath.item)
            }
        }
        
        layoutAttributes.frame = CGRectMake(0.0, CGFloat(indexPath.item) * cardToCardOffset + pullOffset, contentSize.width, cardHeight)
        
        return layoutAttributes
    }
}
