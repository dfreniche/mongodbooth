// (C) Diego Freniche 2022 - MIT License

import Foundation

struct LoadVCardsUseCase: UseCase {
    typealias InType = Void

    typealias OutType = [VCard]

    let repository: VCardRepository

    func execute(inParameter _: Void? = nil) async -> [VCard] {
        // Business Rules

        await repository.load()
    }
}
