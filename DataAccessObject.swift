//
//  DataAccessObject.swift
//  HashBrown
//
//  Created by YoSeob Lee on 2017. 4. 17..
//  Copyright © 2017년 YoSeob Lee. All rights reserved.
//

import UIKit
import CoreData

class DataAccessObject: NSObject {
    func fetch( callback: ([String])->()){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
    
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Hash")
        do {
            let result = try managedContext.fetch(fetchRequest)
            callback(extractValue(list: result))
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Hash",
                                       in: managedContext)!
        
        let hash = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        // 3
        hash.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            var prefs = UserDefaults.standard
            prefs = UserDefaults(suiteName: "group.bigbro.detacter")!
            self.fetch(callback: { (list) in
                prefs.set(list, forKey: "hashs")
            })
        
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func extractValue(list: [NSManagedObject]) -> [String]{
        var ret = [String]()
        for hash in list {
            let text = hash.value(forKey: "name") as? String
            ret.append(text!)
        }
        return ret
    }
}
