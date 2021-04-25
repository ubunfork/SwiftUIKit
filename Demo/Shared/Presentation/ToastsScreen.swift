//
//  ToastsScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-11-26.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

import SwiftUI


struct ToastsScreen: View {
    
    @StateObject private var context = SFToastObservable()
    
    var body: some View {
        MenuList("Toasts") {
            Section {
                MenuListText("SwiftUIKit has utils that make it easier to manage and present toasts.")
            }
            
            Section(header: Text("Actions")) {
                ForEach(DemoPresentable.allCases) { item in
                    MenuListItem(icon: item.listIcon, title: item.listText(for: "toast"))
                        .button(action: {
                                    present(item)
                            
                        })
                }
            }
        }.toast(context: context, duration: 5)
    }
}

private extension ToastsScreen {
    
    func present(_ presentable: DemoPresentable) {
        context.present(presentable)
    }
}

struct ToastsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ToastsScreen()
    }
}
