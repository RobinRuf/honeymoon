//
//  TitleModifier.swift
//  Honeymoon
//
//  Created by Robin Ruf on 26.03.21.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.pink)
    }
}
