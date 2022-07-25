// (C) Diego Freniche 2022 - MIT License

import Foundation
import RealmSwift

protocol VCardRepository {
    /// Loads PixelArts from cache
    /// - Returns: an array of PixelArts or empty array if there's nothing
    func load() async -> [VCard]

    func save(vCard: VCard) async -> Bool
//    func delete(vCard: VCard) async -> Bool
}
