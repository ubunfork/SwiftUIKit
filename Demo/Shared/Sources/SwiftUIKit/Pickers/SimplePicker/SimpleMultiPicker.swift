//
//  SimpleMultiPicker.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-11-12.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This view renders a `ForEach` with buttons that can be used
 to pick multiple options in a list of available options.
 
 Note that you have to wrap the `ForEach` in a suitable view
 to serve your needs. For instance, you can use a `List` for
 iOS or a `LazyVStack` in a `ScrollView` for tvOS, where the
 `List` component may not always work as expected.
 
 You can provide a `buttonBuilder` to generate custom button
 views for the available option. If you don't, the init will
 use `SimpleMultiPicker.standardButtonBuilder` by default.
 */
public struct SimpleMultiPicker<Value: SimplePickerValue>: SimplePicker {
    
    public init(
        selection: Binding<[Value]>,
        options: [Value],
        buttonBuilder: @escaping ButtonBuilder = Self.standardButtonBuilder) {
        self._selection = selection
        self.options = options
        self.buttonBuilder = buttonBuilder
    }
    
    @Binding public var selection: [Value]
    
    public let options: [Value]
    public let buttonBuilder: ButtonBuilder
    
    public typealias ButtonBuilder = (Value, _ isSelected: Bool) -> AnyView
    
    public var body: some View {
        ForEach(options, id: \.id) { value in
            Button(action: { toggle(value) }, label: {
                buttonBuilder(value, isSelected(value))
            })
        }
    }
}

private extension SimpleMultiPicker {
    
    func deselect(_ value: Value) {
        guard isSelected(value) else { return }
        selection.removeAll { $0.id == value.id }
    }

    func isSelected(_ value: Value) -> Bool {
        selection.map { $0.id }.contains(value.id)
    }
    
    func select(_ value: Value) {
        if isSelected(value) { return }
        selection.append(value)
    }

    func toggle(_ value: Value) {
        isSelected(value) ? deselect(value) : select(value)
    }
}

struct SimpleMultiPicker_Previews: PreviewProvider {
    
    class Context: ObservableObject {
        @Published var selection: [DemoSimplePickerValue] = [.first]
    }
    
    @ObservedObject static var context = Context()
    
    static var previews: some View {
        List {
            SimpleMultiPicker<DemoSimplePickerValue>(
                selection: $context.selection,
                options: DemoSimplePickerValue.allCases)
        }
    }
}
