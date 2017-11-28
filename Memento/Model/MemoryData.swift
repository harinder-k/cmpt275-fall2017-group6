//
//  MemoryData.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-27.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit
import os.log

class MemoryData : NSObject, NSCoding {
    // ------------------------------------------------------- //
    // ------------------- Memory properties ----------------- //
    // ------------------------------------------------------- //
    var image : UIImage
    var place: String
    var people: [String]
    var date: String
    
    // Types to save objects of this class
    struct propertyKey{
        static let image = "image"
        static let place = "place"
        static let date = "date"
        static let people = "people"
    }
    // ------------------------------------------------------- //
    // -------------------- Initializers --------------------- //
    // ------------------------------------------------------- //
    init?(image: UIImage, place: String, people: [String], date: String){
        self.image = image
        self.place = place
        self.people = people
        self.date = date
    }
    // ------------------------------------------------------- //
    // ----------------------- NSCoding ---------------------- //
    // ------------------------------------------------------- //
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: propertyKey.image)
        aCoder.encode(place, forKey: propertyKey.place)
        aCoder.encode(people, forKey: propertyKey.people)
        aCoder.encode(date, forKey: propertyKey.date)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The image is required. If we cannot decode a name string, the initializer should fail
        guard let image = aDecoder.decodeObject(forKey: propertyKey.image) as? UIImage else {
            os_log("Unable to decode the name for a MemoryData object.", log: OSLog.default, type: .debug)
            return nil
        }
        let place = aDecoder.decodeObject(forKey: propertyKey.place) as? String
        let people = aDecoder.decodeObject(forKey: propertyKey.people) as? [String]
        let date = aDecoder.decodeObject(forKey: propertyKey.date) as? String
        
        // Must call designated initializer.
        self.init(image: image, place: place!, people: people!, date: date!)
    }
    
}
