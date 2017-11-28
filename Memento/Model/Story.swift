//
//  Story.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-17.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit
import os.log

class Story : NSObject, NSCoding{
    // ------------------------------------------------------- //
    // ------------------- Story properties ------------------ //
    // ------------------------------------------------------- //
    var title: String
    var memories: [Memory]
    
    // Types to save objects of this class
    struct propertyKey{
        static let title = "title"
        static let memories = "memories"
    }
    
    // Path to save objects of this class
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("stories")
    
    // ------------------------------------------------------- //
    // -------------------- Initialization ------------------- //
    // ------------------------------------------------------- //
    init?(title: String, memories: [Memory]){
        if title.isEmpty || memories.count == 0{
            print("Story initializer failed -> title/memories is empty")
            return nil
        }
        self.title = title
        self.memories = memories
    }
    // ------------------------------------------------------- //
    // ----------------------- NSCoding ---------------------- //
    // ------------------------------------------------------- //
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: propertyKey.title)
        aCoder.encode(memories, forKey: propertyKey.memories)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail
        guard let title = aDecoder.decodeObject(forKey: propertyKey.title) as? String else {
            os_log("Unable to decode the name for a Memory object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let memories = aDecoder.decodeObject(forKey: propertyKey.memories) as? [Memory] else {
            os_log("Unable to decode the date for a Memory object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Must call designated initializer.
        self.init(title: title, memories: memories)
    }
}

