//
//  Memory.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-09.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit
import os.log

class Memory : NSObject, NSCoding{
    
    // ------------------------------------------------------- //
    // ------------------- Memory properties ----------------- //
    // ------------------------------------------------------- //
    var name: String
    var date: String
    var photos: [MemoryData]
    
    // Types to save objects of this class
    struct propertyKey{
        static let name = "name"
        static let date = "date"
        static let photos = "photos"
    }
    // ------------------------------------------------------- //
    // -------------------- Initializers --------------------- //
    // ------------------------------------------------------- //
    init?(name: String, date: String, photos: [MemoryData]){
        if name.isEmpty || date.isEmpty{
            print("Memory initializer failed -> name/date is empty")
            return nil
        }
        self.name = name
        self.date = date
        self.photos = photos
    }
    init?(name: String, date: String){
        if name.isEmpty || date.isEmpty{
            print("Memory initializer failed -> name is empty")
            return nil
        }
        self.name = name
        self.date = date
        self.photos = []
    }
    // ------------------------------------------------------- //
    // ----------------------- Getters ----------------------- //
    // ------------------------------------------------------- //
    func addPhoto(image: UIImage) -> Bool{
        let newPhoto = MemoryData(image: image, place: "", people: [], date: "")
        self.photos.append(newPhoto!)
        print("addPhoto succeeded -> photo was successfuly added to memory")
        return true
    }
    func addPhoto(newPhoto: MemoryData) -> Bool{
        self.photos.append(newPhoto)
        print("addPhoto succeeded -> photo was successfuly added to memory")
        return true
    }
    // ------------------------------------------------------- //
    // ----------------------- Setters ----------------------- //
    // ------------------------------------------------------- //
    func removePhoto(index: Int) -> Bool{
        if index < 0 {
            print("removePhoto failed -> index < 0")
            return false
        }
        _ = photos.remove(at: index)
        print("removePhoto succeeded -> photo was successfuly added to memory")
        return true
    }
    // ------------------------------------------------------- //
    // ----------------------- NSCoding ---------------------- //
    // ------------------------------------------------------- //
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: propertyKey.name)
        aCoder.encode(date, forKey: propertyKey.date)
        aCoder.encode(photos, forKey: propertyKey.photos)
    }
    required convenience init?(coder aDecoder: NSCoder){
        // The name is required. If we cannot decode a name string, the initializer should fail
        guard let name = aDecoder.decodeObject(forKey: propertyKey.name) as? String else {
            os_log("Unable to decode the name for a Memory object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let date = aDecoder.decodeObject(forKey: propertyKey.date) as? String else {
            os_log("Unable to decode the date for a Memory object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photos = aDecoder.decodeObject(forKey: propertyKey.photos) as? [MemoryData]
        
        // Must call designated initializer.
        self.init(name: name, date: date, photos: photos!)
    }
    
}


