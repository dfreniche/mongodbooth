// (C) Diego Freniche 2022 - MIT License

import Foundation
import RealmSwift

struct VCardRealmRepository: VCardRepository {
    let realm: Realm?

    func load() async -> [VCard] {
        let vCards = realm?.objects(VCard.self)
        return vCards?.sorted(by: { $0._id < $1._id }) ?? []

    }
    
    func save(vCard: VCard) async -> Bool {
        do {
            try realm?.write {
                vCard._partition = RealmBuilder.user?.id ?? ""

                realm?.add(vCard)
            }
            return true
        } catch {
            print("Error adding pixel Art \(error)")
            return false
        }
    }
    

//    func load() async -> [PixelArt] {
//        let pixelArts = realm?.objects(PixelArtRealm.self)
//
//        var arrayOfPixelArt: [PixelArt] = []
//
//        pixelArts?.enumerated().forEach { _, pixelArtRealm in
//            arrayOfPixelArt.append(pixelArtRealm.asPixelArt())
//        }
//
//        return arrayOfPixelArt
//    }
//
//    func save(pixelArts: [PixelArt]) async -> Bool {
//        for pixelArt in pixelArts {
//            let success = await save(pixelArt: pixelArt)
//            if !success {
//                return false
//            }
//        }
//        return true
//    }

//    func save(pixelArt: PixelArt) async -> Bool {
//        do {
//            try realm?.write {
//                realm?.add(PixelArtRealm(from: pixelArt))
//            }
//            return true
//        } catch {
//            print("Error adding pixel Art \(error)")
//            return false
//        }
//    }
//
//    func delete(pixelArt: PixelArt) async -> Bool {
//        do {
//            try realm?.write {
//                if let found = realm?.objects(PixelArtRealm.self).filter({ $0.uuid == pixelArt.id })
//                {
//                    realm?.delete(found)
//                }
//            }
//
//            return true
//        } catch {
//            print("Error deleting pixel Art \(error)")
//            return false
//        }
//    }
}
