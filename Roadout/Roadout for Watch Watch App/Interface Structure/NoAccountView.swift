//
//  NoAccountView.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

struct NoAccountView: View {
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: true) {
                VStack(spacing: 5) {
                    Text("")
                    VStack(spacing: 3) {
                        Image(systemName: "questionmark")
                            .font(.system(size: 27, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                        Text("No User")
                            .font(.system(size: 23, weight: .medium))
                            .foregroundColor(Color("Main Yellow"))
                    }
                    Text("Please open the iPhone app to log in or create your Roadout account. Connecting to the watch may require force qutting and reopening the app on your iPhone.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .navigationTitle("Roadout")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct NoAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NoAccountView()
    }
}

