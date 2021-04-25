//
//  SheetProvider.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-06-06.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This protocol can be implemented by anything (e.g. a struct,
 enum or class) that can provide a `sheet` view, that can be
 presented as a modal sheet.
 */
public protocol SheetProvider {
    
    var sheet: AnyView { get }
}
