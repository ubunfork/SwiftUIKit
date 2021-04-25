//
//  AlertContext.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-06-07.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import Combine
import SwiftUI

/**
 This class is shared by many presentation-specific contexts,
 like `AlertContext`, `SheetContext` and `ToastContext`. The
 context can be used to manage a generic view as well as its
 presentation state.
 
 To use the context, first create an observed instance, then
 bind it to a presentation-specific view modifier that takes
 an `isPresented` binding and a `content` vuew builder, then
 call any of the context's `present` functions.
 
 For instance, using the `AlertContext` involves these steps:
 
 ```swift
 @StateObject var context = AlertContext()
 
 view.alert(context: context)
 
 context.present(Alert(title: "Hello, world!"))
 ```
 
 Have a look at more specific contexts for more information.
 
 `NOTE` In SwiftUI 1, you must use `@ObservedObject` instead
 of `@StateObject`, but this can cause presentation glitches.
 */
public class PresentationObservable<Content>: ObservableObject {
    
    public init() {}
    
    @Published public var isActive = false
    
    @Published public internal(set) var content: (() -> Content)? {
        didSet { isActive = content != nil }
    }
    

        
    public func dismiss() {
        isActive = false
    }
    
    public func presentContent(_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }
}
