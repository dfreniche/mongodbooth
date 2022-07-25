//
//  ContentView.swift
//  MongoDbooth
//
//  Created by Diego Freniche Brito on 19/7/22.
//

import SwiftUI

struct QRScannerView: View {
    
    @State var showQRReader = true
    @State var showVCard = false

    @State var vCard: VCard?
    
    var body: some View {
        VStack {
            HStack {
                if showQRReader {
                    ImageButton(iconName: "xmark.square.fill", label: "Close") {
                        showQRReader = false
                    }
                } else {
                    ImageButton(iconName: "qrcode.viewfinder", label: "Scan!") {
                        showQRReader = true
                    }
                }
            }.sheet(isPresented: $showVCard, onDismiss: { showVCard = false }) {
                VCardView(vcard: vCard ?? VCard())
            }
            if showQRReader {
                QRCodeReaderView(onQRCodeRead: { (qr, locations) in
                    print("Read: \( qr ) \( String(describing: locations) )")
                    vCard = VCard(from: qr)
                    
                    if let location = locations?.first {
                        vCard?.latitude = location.coordinate.latitude
                        vCard?.longitude = location.coordinate.longitude
                    }
                    showQRReader = false
                    showVCard = true
                })
            } else {
                
            }
        }
    }
}
