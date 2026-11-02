//
//  LostView.swift
//  TEscape
//
//  Created by user on 17.06.2025.
//

import SwiftUI

struct LostView: View {
    var body: some View {
        Image("lost")
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
    }
}

#Preview {
    LostView()
}
