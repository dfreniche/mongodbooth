// (C) Diego Freniche 2022 - MIT License

import Foundation
import Realm
import RealmSwift
import SwiftDotenv

/// Builds a new Realm Instance. It could be in-memory, using a local DB or synced to MongoDB Atlas depending on selected ``RealmConfig``
public class RealmBuilder {
    public enum RealmConfig {
        case inMemory
        case development
        case mongoDBSync

        public static func config(using: RealmConfig) -> Realm.Configuration {
            switch using {
            case .inMemory:
                return Realm.Configuration(fileURL: nil,
                                           inMemoryIdentifier: "MongoDBooth.InMemory",
                                           syncConfiguration: nil,
                                           encryptionKey: nil,
                                           readOnly: false,
                                           schemaVersion: 1,
                                           migrationBlock: nil,
                                           deleteRealmIfMigrationNeeded: false,
                                           shouldCompactOnLaunch: nil,
                                           objectTypes: nil,
                                           seedFilePath: nil)
            case .development:
                return Realm.Configuration(fileURL: URL(string: RLMRealmPathForFile("MongoDBooth.realm")),
                                           inMemoryIdentifier: nil,
                                           syncConfiguration: nil,
                                           encryptionKey: nil,
                                           readOnly: false,
                                           schemaVersion: 1,
                                           migrationBlock: nil,
                                           deleteRealmIfMigrationNeeded: true,
                                           shouldCompactOnLaunch: nil,
                                           objectTypes: nil,
                                           seedFilePath: nil)
            case .mongoDBSync:
                return Realm.Configuration()
            }
        }
    }

    public func getRealm(_ config: RealmConfig) async -> Realm? {
        if config == .mongoDBSync {
            return await getMongoDBSyncRealm()
        }
        
        do {
            return try await Realm(configuration: RealmConfig.config(using: config))
        } catch {
            print("💀 something bad happened \(error)")
            return nil
        }
    }
    
    public static var user: User?
    public static var syncedRealm: Realm?
    
    public func getMongoDBSyncRealm() async -> Realm? {

        guard RealmBuilder.syncedRealm == nil else { return RealmBuilder.syncedRealm }
        
        let app = App(id: getAppIdFromDotEnv())
        do {
            let loginResult = try await app.login(credentials: Credentials.anonymous)

            if let user = app.currentUser {

                RealmBuilder.user = user
                // The partition determines which subset of data to access.
                let partitionValue = "\(user.id)"
                print(partitionValue)
                // Get a sync configuration from the user object.
                let configuration = user.configuration(partitionValue: partitionValue)
                
                // Open the realm asynchronously to ensure backend data is downloaded first.
                Realm.asyncOpen(configuration: configuration) { (result) in
                    switch result {
                    case .failure(let error):
                        print("Failed to open realm: \(error.localizedDescription)")
                        // Handle error...
                        RealmBuilder.syncedRealm = nil
                    case .success(let realm):
                        // Realm opened
                        RealmBuilder.syncedRealm = realm
                    }
                }
            }

        } catch {
            
        }
        return RealmBuilder.syncedRealm
    }
    
    // load in environment variables
    // add a value for your App Id in config.env if you want to use Atlas Device Sync
    func getAppIdFromDotEnv() -> String {
        //
        do {
            try Dotenv.configure(atPath: Bundle.main.path(forResource: "config.env", ofType: nil) ?? "")
        } catch {
            print(error)
        }
        
        // access values
        let appId: String = Dotenv["appId"]?.stringValue ?? ""
        print(appId)
        
        return appId
    }
}
