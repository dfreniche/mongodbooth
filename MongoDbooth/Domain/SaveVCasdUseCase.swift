// (C) Diego Freniche 2022 - MIT License

import Foundation

struct SaveVCasdUseCase: UseCase {
    typealias InType = VCard

    typealias OutType = Bool

    let repository: VCardRepository

    func execute(inParameter: VCard?) async -> Bool {
        // check business rules
        guard let vcard = inParameter else { return false }
        return await repository.save(vCard: vcard)
    }
}
