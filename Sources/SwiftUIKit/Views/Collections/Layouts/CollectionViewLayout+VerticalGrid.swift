//
//  CollectionViewLayout+VerticalGrid.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-11-10.
//  Copyright © 2020 Daniel Saidi. All rights reserved.

import UIKit

public extension CollectionViewLayout {
    
    /**
     This layout makes a `CollectionView` render itself as a
     vertical grid with `itemsPerRow` items per grid row.
     
     You can apply this layout with `layout: .verticalGrid()`
     in the `CollectionView` init. The default params create
     a grid where each item is 200 points tall and have a 20
     point margin.
     */
    static func verticalGrid(
        itemsPerRow: Int,
        itemHeight: CGFloat = 200,
        itemInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)) -> CollectionViewLayout {
        CollectionViewLayout { sectionIndex, layoutEnvironment in
            let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let layoutItem = NSCollectionLayoutItem(layoutSize: layoutSize)
            layoutItem.contentInsets = itemInsets
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(1), heightDimension: .absolute(itemHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: layoutItem, count: itemsPerRow)
            return NSCollectionLayoutSection(group: group)
        }
    }
}
