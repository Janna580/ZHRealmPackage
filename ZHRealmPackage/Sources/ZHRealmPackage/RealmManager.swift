//
//  File.swift
//  
//
//  Created by Zhanna on 3/17/23.
//

import RealmSwift
import Foundation

protocol RealmManagerProtocol {
    func save<T: Object>(_ object: T, completion: @escaping () -> Void)
    func delete<T: Object>(ofType type: T.Type, for key: String, completion: @escaping () -> Void)
    func fetchAll<T: Object>(ofType type: T.Type, completion: @escaping(_ result: [T]) -> Void)
    func fetchAll<T: Object>(ofType type: T.Type, filter predicate: NSPredicate, completion: @escaping(_ result: [T]) -> Void)
    func fetch<T: Object>(ofType type: T.Type, for key: String, completion: @escaping(_ result: T?) -> Void)
}

class RealmManager {
    
    private var realm: Realm?
    private var configuration: Realm.Configuration?
    
    init(configuration: Realm.Configuration? = nil) {
        self.configuration = configuration
        setupRealm()
    }
    
    private func setupRealm() {
        let fileManager = FileManager.default
        var config = configuration ?? Realm.Configuration.defaultConfiguration
        config.deleteRealmIfMigrationNeeded = true
        if let url = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).last {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                config.fileURL = url.appendingPathComponent("app.realm")
                realm = try Realm(configuration: config)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension RealmManager: RealmManagerProtocol {

    func save<T: Object>(_ object: T, completion: @escaping () -> Void) {
        guard let realm = self.realm else { return }
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete<T: Object>(ofType type: T.Type, for key: String, completion: @escaping () -> Void) {
        guard let realm = self.realm else { return }
        fetch(ofType: T.self, for: key, completion: { object in
            if let object = object {
                do {
                    try realm.write {
                        realm.delete(object)
                    }
                    completion()
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
    }
   
    func fetchAll<T: Object>(ofType type: T.Type, completion: @escaping(_ result: [T]) -> Void) {
        guard let realm = self.realm else { return }
        let objects: [T] = realm.objects(type).compactMap { $0 }
        completion(objects)
    }
    
    func fetchAll<T: Object>(ofType type: T.Type, filter predicate: NSPredicate, completion: @escaping(_ result: [T]) -> Void) {
        guard let realm = self.realm else { return }
        let objects: [T] = realm.objects(type).filter(predicate).compactMap { $0 }
        completion(objects)
    }
    
    func fetch<T: Object>(ofType type: T.Type, for key: String, completion: @escaping(_ result: T?) -> Void) {
        guard let realm = self.realm else { return }
        let object = realm.object(ofType: type, forPrimaryKey: key)
        completion(object)
    }
}
