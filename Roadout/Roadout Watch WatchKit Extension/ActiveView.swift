//
//  ActiveView.swift
//  Roadout Watch WatchKit Extension
//
//  Created by David Retegan on 11.12.2021.
//

import SwiftUI

struct ActiveView: View {
    var body: some View {
        ScrollView {
            VStack {
                Spacer(minLength: 10)
                Image(systemName: "lock")
                    .frame(width: 60, height: 50, alignment: .center)
                    .foregroundColor(Color("Main Yellow"))
                    .font(.system(size: 40))
                Text("Spot is locked")
                    .font(.system(size: 18, weight: .medium))
                Spacer(minLength: 25)
                Button("Unlock") {
                    
                }
                .foregroundColor(.black)
                .background(Color("Main Yellow"))
                .cornerRadius(20)
                
            }
        }
        .navigationTitle("Reservation")
        .navBarAutomaticTitleDisplayMode()
    }
}

struct ActiveView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveView()
    }
}

extension View {
    @ViewBuilder
    func navBarAutomaticTitleDisplayMode() -> some View {
        if #available(watchOSApplicationExtension 8.0, *) {
            self.navigationBarTitleDisplayMode(.automatic)
        } else {
            
        }
    }
}
