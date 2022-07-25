//
//  MongoDboothTests.swift
//  MongoDboothTests
//
//  Created by Diego Freniche Brito on 19/7/22.
//

import XCTest
@testable import MongoDbooth

class MongoDboothTests: XCTestCase {

    
    func testVCard1() throws {
        let vCard = VCard(from: vcardStub1)
        XCTAssert(!vCard.name.isEmpty)
        XCTAssertEqual("3.0", vCard.version)

        XCTAssertEqual("Diego", vCard.name)
        XCTAssertEqual("Freniche", vCard.surname)
        XCTAssertEqual("HR Specialist", vCard.title)
        XCTAssertEqual("diego.freniche@mongodb.com", vCard.email)

        XCTAssertEqual("Crafting Software Innovation", vCard.organization)
    }
    
    func testVCard2() throws {
        let vCard = VCard(from: vcardStub2)
        XCTAssert(!vCard.name.isEmpty)
        XCTAssertEqual("3.0", vCard.version)

        XCTAssertEqual("Diego", vCard.name)
        XCTAssertEqual("Freniche", vCard.surname)
        XCTAssertEqual("Developer Advocate", vCard.title)
        XCTAssertEqual("diego@m.com", vCard.email)
        XCTAssertEqual("www.google.com", vCard.url)
        XCTAssertEqual("MongoDB", vCard.organization)
    }
}
