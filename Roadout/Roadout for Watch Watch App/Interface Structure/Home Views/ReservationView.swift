//
//  ReservationView.swift
//  Roadout for Watch Watch App
//
//  Created by David Retegan on 23.10.2022.
//

import SwiftUI

struct ReservationView: View {
    @ObservedObject var resManager: ReservationManager

    var body: some View {
        switch $resManager.reservationData.reservationStatus.wrappedValue {
            case -1:
                ErrorReservationView(resManager: resManager)
            case 0:
                ReservationActiveView(resManager: resManager)
            case 1:
                ReservationUnlockedView(resManager: resManager)
            case 2:
                NoReservationView(resManager: resManager)
            case 3:
                NoReservationView(resManager: resManager)
            default:
                LoadingReservationView(resManager: resManager)
        }
    }
}

