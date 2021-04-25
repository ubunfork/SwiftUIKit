//
//  CornerRadiusStyle.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-03-10.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This struct represents a style with a property that matches
 the `SwiftUI`s `cornerRadius` modifier.
 
 You can use the style's property with the standard modifier
 or use the `cornerRadius(_ style:)` `View` extension.
 
 You can specify your own standard styles by creating static,
 calculated `CornerRadiusStyle` extension properties.
 */
public struct CornerRadiusStyle {
    
    public init(radius: CGFloat) {
        self.radius = radius
    }
    
    public let radius: CGFloat
}
