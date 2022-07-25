//
//  MongoDboothApp.swift
//  MongoDbooth
//
//  Created by Diego Freniche Brito on 19/7/22.
//

import SwiftUI

@main
struct MongoDboothApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                QRScannerView()
                    .tabItem {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                    }

                VCardList(vcards: [])
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Contacts")
                }
            }.task {
                let _ = await RealmBuilder().getRealm(.mongoDBSync)
            }
        }
    }
}
