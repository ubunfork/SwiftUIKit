//
//  CoversScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-11-26.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import SwiftUI


/**
 This screen has an additional context that helps verify the
 functionality when presenting both a sheet and a cover from
 the same root view.
 */
struct CoversScreen: View {
    
    @StateObject private var context = FullScreenCoverContext()
    @StateObject private var sheetContext = SheetContext()
    
    var body: some View {
        MenuList("Full Screen Covers") {
            Section {
                MenuListText("SwiftUIKit has additional utils that make it easier to manage and present covers.")
            }
            
            Section(header: Text("Actions")) {
                ForEach(DemoPresentable.allCases) { item in
                    MenuListItem(icon: item.listIcon, title: item.listText(for: "cover"))
                        .button(action: { presentCover(item) })
                }
            }
            Section(header: Text("Sheet (for testing purpose)")) {
                MenuListItem(icon: .sheet, title: "Show an flag sheet")
                    .button(action: presentSheet)
                    .sheet(context: sheetContext)
            }
        }.fullScreenCover(context: context)
    }
}

private extension CoversScreen {
    
    var closeButton: some View {
        Button("Close", action: { context.dismiss() })
    }
    
    func presentCover(_ presentable: DemoPresentable) {
        context.present(
            NavigationView {
                view(for: presentable)
                    .navigationBarItems(trailing: closeButton)
            }
        )
    }
    
    func presentSheet() {
        sheetContext.present(
            NavigationView {
                view(for: .flag)
            }
        )
    }
    
    func view(for presentable: DemoPresentable, addClose: Bool = false) -> some View {
        presentable.cover
            .navigationTitle("Hello, you!")
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct CoversScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoversScreen()
    }
}
#endif
