//
//  ContentView.swift
//  Roadout Watch WatchKit Extension
//
//  Created by David Retegan on 11.12.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Text("What would you like to do?")
                .font(.footnote)
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
                .listRowPlatterColor(Color.clear)
            NavigationLink(destination: ActiveView()) {
                Group {
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(Color.white)
                            .frame(width: 30, height: 30, alignment: .center)
                            .font(.system(size: 25))
                        Text("Active Reservation")
                    }
                }
            }
            .listRowPlatterColor(Color("Action1"))
            NavigationLink(destination: ExpressView()) {
                Group {
                    HStack {
                        Image(systemName: "flag.2.crossed")
                            .foregroundColor(Color.white)
                            .frame(width: 30, height: 30, alignment: .center)
                            .font(.system(size: 18))
                        Text("Express Reserve")
                    }
                }
            }
            .listRowPlatterColor(Color("Action2"))
            NavigationLink(destination: FindView()) {
                Group {
                    HStack {
                        Image(systemName: "loupe")
                            .foregroundColor(Color.white)
                            .frame(width: 30, height: 30, alignment: .center)
                            .font(.system(size: 20))
                        Text("Find Spot")
                    }
                }
            }
            .listRowPlatterColor(Color("Action3"))
        }
        .navigationTitle("Roadout")
        .navBarLargeTitleDisplayMode()
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
            self.navigationBarTitleDisplayMode(.large)
        } else {
            
        }
    }
}
