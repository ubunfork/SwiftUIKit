//
//  TabViewItem.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2021-04-05.
//  Copyright © 2021 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This protocol can be implemented by types that contain info
 regarding how they are to be displayed in a `TabView`.
 */
public protocol TabViewItem: Hashable {
    
    var icon: Image { get}
    var title: String { get }
    var selectedIcon: Image { get }
    var selectedTitle: String { get }
}

@available(iOS 13.0, tvOS 13.0, macOS 11.0, watchOS 7.0, *)
public extension View {
    
    /**
     Use this function to bind any view in a `TabView` to an
     instance of a type that implements `TabViewItem`.
     */
    func tabItem<Type: TabViewItem>(_ item: Type, selection: Type) -> some View {
        self.tag(item)
            .tabItem {
                item == selection ? item.selectedIcon : item.icon
                Text(item == selection ? item.selectedTitle : item.title)
            }
    }
}
