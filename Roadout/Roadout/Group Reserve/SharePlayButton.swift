//
//  SharePlayButton.swift
//  Roadout
//
//  Created by David Retegan on 19.12.2021.
//

import SwiftUI
import GroupActivities

@available(iOS 15.0, *)
struct SharePlayButton: View {
    @StateObject var groupStateObserver = GroupStateObserver()
    var body: some View {
        ZStack {
            Color(uiColor: UIColor(named: "Background")!)
                .ignoresSafeArea()
            if groupStateObserver.isEligibleForGroupSession {
                Button {
                    SharePlayManager.sharedInstance.activateSession()
                } label: {
                    Image(systemName: "shareplay")
                        .font(.system(size: 20))
                        .foregroundColor(Color(uiColor: UIColor(named: "Redish")!))
                }
                }
            }
    }
}
@available(iOS 15.0, *)
struct SharePlayButton_Previews: PreviewProvider {
    static var previews: some View {
        SharePlayButton()
    }
}
