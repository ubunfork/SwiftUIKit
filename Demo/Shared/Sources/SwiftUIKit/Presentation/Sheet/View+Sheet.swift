//
//  View+Sheet.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-09-03.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension View {
    
    /**
     Present a sheet from a certain sheet context. The sheet
     will be presented when the context is active.
     */
    func sheet(context: SheetContext) -> some View {
        sheet(isPresented: .constant(false), content: context.content ?? EmptyView().any)
    }
}
