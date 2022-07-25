//
//  VCardView.swift
//  MongoDbooth
//
//  Created by Diego Freniche Brito on 20/7/22.
//

import SwiftUI
import MapKit

struct VCardView: View {
    
    let vcard: VCard
    @State private var showQRData = false
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Section {
                HStack {
                    Text("\( vcard.name )")
                        .font(.title)
                        .foregroundColor(.green)
                    Text("\( vcard.surname )")
                        .font(.title)
                        .foregroundColor(.green)
                        .bold()
                }
                .padding()
            }
            
            Divider()
            
            Section {
                Text("\( vcard.organization )")
                    .font(.title2)
                Text("\( vcard.title )")
                    .font(.title3)
            }
            
            Divider()

            Section {
                Text("\( vcard.email )")
                Text("\( vcard.url )")
            }
            
            Divider()

            Section {
                Text("🕒 \( vcard.date )")
            }

            Spacer()
            
            Section {

                if showQRData {
                    Text(vcard.qrRead)
                } else {
                    Map(coordinateRegion: $region, interactionModes: [.all], showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: [vcard])  { pin in
                        MapMarker(coordinate: pin.coordinate,
                                           tint: Color.purple)
                    }
                    HStack {
                        FootText(text: "🌐 (\( vcard.latitude ), ")
                        FootText(text: "\( vcard.longitude ))")
                    }
                }
            }
            
            HStack {
                ImageButton(iconName: "qrcode.viewfinder", label: showQRData ? "Hide QR" : "Show QR") {
                    showQRData = !showQRData
                }
                
                ImageButton(iconName: "square.and.arrow.down.fill", label: "Save") {
                    Task {
                        let realm = await RealmBuilder().getRealm(.mongoDBSync)
                        let repository = VCardRealmRepository(realm: realm)
                        let _ = await SaveVCasdUseCase(repository: repository).execute(inParameter: vcard)
                        
                        dismiss()
                    }
                }
            }
        }.onAppear {
            self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: vcard.latitude, longitude: vcard.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
}

struct FootText: View {
    @State var text: String
    
    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundColor(.gray)
    }
}
