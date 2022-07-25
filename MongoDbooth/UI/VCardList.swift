//
//  VCardList.swift
//  MongoDbooth
//
//  Created by Diego Freniche Brito on 20/7/22.
//

import SwiftUI
import RealmSwift

struct VCardList: View {
    
    @State var vcards: [VCard]
    @State var realm: Realm?
    @State var repository: VCardRepository?
    
    var body: some View {
        NavigationView {
            List($vcards) { vCard in
                NavigationLink(destination: VCardView(vcard: vCard.wrappedValue)) {
                    HStack {
                        Text("\(vCard.wrappedValue.name)")
                        Text("\(vCard.wrappedValue.surname)")
                            .bold()
                    }
                }
            }
            .task {
                realm = await RealmBuilder().getRealm(.mongoDBSync)
                repository = VCardRealmRepository(realm: realm)

                if let repository = repository {
                    vcards = await LoadVCardsUseCase(repository: repository).execute()
                }
            }
            .navigationTitle("Scanned Badges")
        }
    }
}

