//
//  FindView.swift
//  Roadout Watch WatchKit Extension
//
//  Created by David Retegan on 11.12.2021.
//

import SwiftUI

struct FindView: View {
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 5)
                Text("Old Town")
                    .font(.system(size: 19, weight: .medium))
                    .foregroundColor(Color("Greyish"))
                Spacer(minLength: 5)
                Text("Section A")
                    .font(.system(size: 19, weight: .medium))
                Spacer(minLength: 5)
                Text("Spot 12")
                    .font(.system(size: 19, weight: .medium))
                Spacer(minLength: 20)
                Button("Continue") {
                    
                }
                .foregroundColor(.black)
                .background(Color("Greyish"))
                .cornerRadius(20)
            }
        }
        .navigationTitle("Find")
        .navBarAutomaticTitleDisplayMode()
    }
}

struct FindView_Previews: PreviewProvider {
    static var previews: some View {
        FindView()
    }
}
