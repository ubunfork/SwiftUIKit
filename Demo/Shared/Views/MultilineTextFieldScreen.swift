//
//  MultilineTextFieldScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2020-11-27.
//  Copyright © 2020 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import SwiftUI


struct MultilineTextFieldScreen: View {
    
    @State private var text = "Here's some multiline text that you can edit if you're feeling adventurous!\n\n...shouldn't this just exist in SwiftUI?"
    
    var body: some View {
        MenuList("Views") {
            Section {
                MenuListText("MultilineTextField wraps a UIKit view to bring multiline text editing to SwiftUI.")
            }
            
            Section(header: Text("Example")) {
                MultilineTextField(text: $text) { textField in
                    textField.font = UIFont.preferredFont(forTextStyle: .body)
                }.frame(height: 250)
            }
        }
    }
}

struct MultilineTextFieldScreen_Previews: PreviewProvider {
    static var previews: some View {
        MultilineTextFieldScreen()
    }
}
#endif
