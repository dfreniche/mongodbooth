//
//  ImageButton.swift
//  MongoDbooth
//
//  Created by Diego Freniche Brito on 21/7/22.
//

import SwiftUI

struct ImageButton: View {
    
    let iconName: String
    let label: String
    let action: (()->Void)?
    
    init(iconName: String, label: String, action: (()->Void)? = nil) {
        self.action = action
        self.iconName = iconName
        self.label = label
    }
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack {
                Image(systemName: iconName)
                    .tint(.white)
                Text(label)
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .padding()
        .background(Color.green)
        .cornerRadius(15)
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        ImageButton(iconName: "xmark.square.fill", label: "Close")
    }
}
