//
//  RealmManager.swift
//  Revolution
//
//  Created by Hai IT. Hoang Minh on 31/07/2021.
//  Copyright © 2021 TonyHoang. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmResult: Int {
    case failed = 0
    case success = 1
}

typealias RealmDataCallBack = (_ result: RealmResult) -> Void

class RealmManager {
    static let shared = RealmManager()
    private var realm: Realm!
    
    private init() {
//        let config = Realm.Configuration(objectTypes: [RealmVideo.self])
//        self.realm = try! Realm(configuration: config)
    }
    
    func saveObject<T: Object>(object: T, completion: RealmDataCallBack?) {
        do {
            try realm.write {
                realm.add(object)
            }
            completion?(.success)
        } catch {
            completion?(.failed)
        }
    }
    
    func saveArrayToDatabase<T: Object>(with objects: [T], completion: RealmDataCallBack?) {
        do {
            try realm.write {
                realm.add(objects)
            }
            completion?(.success)
        } catch {
            completion?(.failed)
        }
    }
    
    func upsertArrayToDatabase<T: Object>(with objects: [T], completion: RealmDataCallBack?) {
        do {
            try realm.write {
                realm.add(objects, update: .modified)
            }
            completion?(.success)
        } catch {
            completion?(.failed)
        }
    }
    
    func getObjects<T: Object>(from objectType: T.Type) -> Results<T> {
        return realm.objects(objectType)
    }
    
    func deleteAllFromDatabase(completion: RealmDataCallBack?) {
        do {
            try realm.write {
                realm.deleteAll()
            }
            completion?(.success)
        } catch {
            completion?(.failed)
        }
    }
    
    func deleteObject<T: Object>(with objectType: T.Type, completion: RealmDataCallBack?) {
        do {
            try realm.write {
                let objects = realm.objects(objectType)
                realm.delete(objects)
            }
            completion?(.success)
        } catch {
            completion?(.failed)
        }
    }
    
    func deleteObject<T: Object>(with object: T, completion: RealmDataCallBack?) {
        do {
            try realm.write {
                let objects = realm.objects(T.self)
                if let deletedObject = objects.first(where: { $0 === object }) {
                    realm.delete(deletedObject)
                }
            }
            completion?(.success)
        } catch {
            completion?(.failed)
        }
    }
    
}
