//
//  VCard.swift
//  MongoDbooth
//
//  Created by Diego Freniche Brito on 20/7/22.
//

import Foundation
import RealmSwift
import CoreLocation

class VCard: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var _partition: String = "partitionKey"
    
    @Persisted public var qrRead: String
    @Persisted public var version: String
    @Persisted public var name: String
    @Persisted public var surname: String
    @Persisted public var organization: String
    @Persisted public var title: String
    @Persisted public var email: String
    @Persisted public var url: String
    @Persisted public var latitude: Double
    @Persisted public var longitude: Double
    
    public var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }

    @Persisted public var date = Date()

    
    public convenience init(from vCard: String) {
        self.init()
        
        self.qrRead = vCard
        
        let vCardLines = vCard.components(separatedBy: .newlines)
        if !vCardLines.isEmpty {
            for line in vCardLines {
                if line.starts(with: "VERSION:") {
                    version = line.replacingOccurrences(of: "VERSION:", with: "")
                }
                
                if line.starts(with: "N:") {
                    let nameComponents = line.replacingOccurrences(of: "N:", with: "").components(separatedBy: ";")
                    surname = nameComponents[0]
                    name = nameComponents[1]
                }
                
                if line.starts(with: "ORG:") {
                    organization = line.replacingOccurrences(of: "ORG:", with: "")
                }
                
                if line.starts(with: "EMAIL:") {
                    email = line.replacingOccurrences(of: "EMAIL:", with: "")
                }
                
                if line.starts(with: "EMAIL;WORK;INTERNET:") {
                    email = line.replacingOccurrences(of: "EMAIL;WORK;INTERNET:", with: "")
                }
                
                if line.starts(with: "TITLE:") {
                    title = line.replacingOccurrences(of: "TITLE:", with: "")
                }
                
                if line.starts(with: "URL:") {
                    url = line.replacingOccurrences(of: "URL:", with: "")
                }
            }
        }
    }
}
