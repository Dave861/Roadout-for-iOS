//
//  ContentView.swift
//  Roadout Watch WatchKit Extension
//
//  Created by David Retegan on 11.12.2021.
//

import SwiftUI
import WatchKit

struct ContentView: View {
    
    @State var spotUnlocked = false
        
    var body: some View {
        if spotUnlocked == false {
            VStack {
                Spacer(minLength: 10)
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(Color("Main Yellow"))
                        .font(.system(size: 26))
                    Text(Date(), style: .time)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color("Main Yellow"))
                }
                .frame(height: 40, alignment: .center)
                Text("Spot is locked".watchLocalize())
                    .font(.system(size: 18, weight: .medium))
                Spacer(minLength: 15)
                Button("Unlock".watchLocalize()) {
                    spotUnlocked = true
                    
                    WKInterfaceDevice.current().play(.success)
                    print("Yes")
                }
                .foregroundColor(.black)
                .background(Color("Main Yellow"))
                .cornerRadius(20)
                
            }
            .navigationTitle("Roadout")
            .navBarLargeTitleDisplayMode()
        } else {
            VStack {
                Spacer(minLength: 10)
                HStack {
                    Image(systemName: "lock.open")
                        .foregroundColor(Color("Main Yellow"))
                        .font(.system(size: 34))
                }
                .frame(height: 40, alignment: .center)
                Text("Spot is unlocked".watchLocalize())
                    .font(.system(size: 18, weight: .medium))
                Spacer(minLength: 15)
                Button("Directions".watchLocalize()) {
                    spotUnlocked = false
                }
                .foregroundColor(.black)
                .background(Color("Main Yellow"))
                .cornerRadius(20)
            }
            .navigationTitle("Roadout")
            .navBarLargeTitleDisplayMode()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    @ViewBuilder
    func navBarLargeTitleDisplayMode() -> some View {
        if #available(watchOSApplicationExtension 8.0, *) {
            self.navigationBarTitleDisplayMode(.automatic)
        } else {
            
        }
    }
}
