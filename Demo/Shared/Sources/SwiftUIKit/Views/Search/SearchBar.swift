//
//  SearchBar.swift
//  SwiftUIKit
//
//  Created by Daniel Saidi on 2020-12-13.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import SwiftUI

/**
 This view wraps a text field in a rounded rectangle, with a
 wrapped clear button and a trailing cancel button.
 */
public struct SearchBar: View {
    
    public init(
        title: String = "Search...",
        text: Binding<String>,
        cancelText: String = "Cancel",
        searchFieldBackgroundColor: Color = Color.primary.opacity(0.1),
        searchFieldCornerRadius: CGFloat = 10,
        searchFieldPadding: CGFloat = 5,
        searchFieldMargin: CGFloat = 8) {
        self.title = title
        self.text = text
        self.cancelText = cancelText
        self.searchFieldBackgroundColor = searchFieldBackgroundColor
        self.searchFieldCornerRadius = searchFieldCornerRadius
        self.searchFieldPadding = searchFieldPadding
        self.searchFieldMargin = searchFieldMargin
    }
    
    private let title: String
    private let text: Binding<String>
    private let cancelText: String
    private let searchFieldBackgroundColor: Color
    private let searchFieldCornerRadius: CGFloat
    private let searchFieldPadding: CGFloat
    private let searchFieldMargin: CGFloat
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                searchField
                cancelButton
            }.padding(searchFieldMargin)
            Divider()
        }
    }
}


// MARK: - Properties

public extension SearchBar {
    
    var hasText: Bool { !text.wrappedValue.isEmpty }
}


// MARK: - Views

private extension SearchBar {

    var cancelButton: some View {
        ConditionalView(hasText) {
            Button(action: cancel) {
                Text(cancelText)
            }
        }
    }
    
    var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(title, text: text).withClearButton(for: text)
        }
        .padding(searchFieldPadding)
        .background(searchFieldBackground)
    }
    
    var searchFieldBackground: some View {
        RoundedRectangle(cornerRadius: searchFieldCornerRadius)
            .foregroundColor(searchFieldBackgroundColor)
    }
}


// MARK: - Functions

private extension SearchBar {
    
    func cancel() {
        withAnimation(.linear(duration: 0.1)) {
            text.wrappedValue = ""
            hideKeyboard()
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        SearchBar(title: "Search", text: $text, cancelText: "Cancel")
    }
}
#endif
