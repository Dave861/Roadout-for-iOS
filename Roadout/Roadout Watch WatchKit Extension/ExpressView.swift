//
//  ExpressView.swift
//  Roadout Watch WatchKit Extension
//
//  Created by David Retegan on 11.12.2021.
//

import SwiftUI

struct ExpressView: View {
    var body: some View {
        List {
            Group {
                VStack(alignment: .leading) {
                    Text("Buna Ziua")
                        .font(.system(size: 18, weight: .medium))
                    Text("15 Free Spots")
                        .foregroundColor(Color("ExpressFocus"))
                }
            }
            Group {
                VStack(alignment: .leading) {
                    Text("Airport")
                        .font(.system(size: 18, weight: .medium))
                    Text("20 Free Spots")
                        .foregroundColor(Color("ExpressSecond"))
                }
            }
            Group {
                VStack(alignment: .leading) {
                    Text("Marasti")
                        .font(.system(size: 18, weight: .medium))
                    Text("18 Free Spots")
                        .foregroundColor(Color("ExpressFocus"))
                }
            }
            Group {
                VStack(alignment: .leading) {
                    Text("Old Town")
                        .font(.system(size: 18, weight: .medium))
                    Text("5 Free Spots")
                        .foregroundColor(Color("ExpressSecond"))
                }
            }
            Group {
                VStack(alignment: .leading) {
                    Text("21 Decembrie")
                        .font(.system(size: 18, weight: .medium))
                    Text("22 Free Spots")
                        .foregroundColor(Color("ExpressFocus"))
                }
            }
            Group {
                VStack(alignment: .leading) {
                    Text("Mihai Viteazu")
                        .font(.system(size: 18, weight: .medium))
                    Text("27 Free Spots")
                        .foregroundColor(Color("ExpressSecond"))
                }
            }
            Group {
                VStack(alignment: .leading) {
                    Text("Eroilor")
                        .font(.system(size: 18, weight: .medium))
                    Text("28 Free Spots")
                        .foregroundColor(Color("ExpressFocus"))
                }
            }
            Group {
                VStack(alignment: .leading) {
                    Text("Gheorgheni")
                        .font(.system(size: 18, weight: .medium))
                    Text("15 Free Spots")
                        .foregroundColor(Color("ExpressSecond"))
                }
            }
            Group {
                VStack(alignment: .leading) {
                    Text("Manastur")
                        .font(.system(size: 18, weight: .medium))
                    Text("6 Free Spots")
                        .foregroundColor(Color("ExpressFocus"))
                }
            }
            Group {
                VStack(alignment: .leading) {
                    Text("Andrei Muresanu")
                        .font(.system(size: 18, weight: .medium))
                    Text("5 Free Spots")
                        .foregroundColor(Color("ExpressSecond"))
                }
            }
            
        }
        .navigationTitle("Express")
        .navBarAutomaticTitleDisplayMode()
    }
}

struct ExpressView_Previews: PreviewProvider {
    static var previews: some View {
        ExpressView()
    }
}
