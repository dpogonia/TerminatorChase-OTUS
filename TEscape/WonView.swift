//
//  WonView.swift
//  TEscape
//
//  Created by user on 17.06.2025.
//

import SwiftUI

struct WonView: View {
    var body: some View {
        VStack {
            Text("hasta la vista baby!")
                .font(.title)
            Image("won")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
        }
    }
}

#Preview {
    WonView()
}
