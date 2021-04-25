//
//  AsyncImageScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-11-26.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI


struct AsyncImageScreen: View {
    
    @State private var urlString = "https://picsum.photos/200/300"
    
    @StateObject private var sheetContext = SheetContext()
    
    var body: some View {
        MenuList("AsyncImage") {
            Section {
                MenuListText("This view can fetch images async from urls.")
            }
            
            Section(header: Text("URL")) {
                TextField("Enter URL", text: $urlString)
            }
            
            Section(header: Text("Actions")) {
                MenuListItem(icon: .photo, title: "Load image")
                    .button(action: loadImage)
                    .enabled(hasUrl)
            }
        }.sheet(context: sheetContext)
    }
}

private extension AsyncImageScreen {
    
    var hasUrl: Bool { url != nil }
    
    var url: URL? { URL(string: urlString) }
    
    var spinner: some View {
        #if os(iOS) || os(tvOS) || os(watchOS)
        return CircularProgressView()
        #else
        return Text("...")
        #endif
    }
    
    func loadImage() {
        guard let url = url else { return }
        sheetContext.present(
            NavigationView {
                AsyncImage(url: url, placeholder: { spinner })
                    .cornerRadius(10)
                    .padding()
                    .navigationTitle("Image, ohoy!")
            }
        )
    }
}

struct AsyncImageScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AsyncImageScreen()
        }
    }
}
