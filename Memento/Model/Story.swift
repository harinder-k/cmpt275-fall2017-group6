//
//  Story.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-17.
//  Copyright © 2017 memTech. All rights reserved.
//

//see https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html for referance

import os.log
import UIKit
import os.log

<<<<<<< HEAD
class Story: NSObject, NSCoding {
=======
class Story : NSObject, NSCoding{
>>>>>>> fatemeh-v3
    // ------------------------------------------------------- //
    // ------------------- Story properties ------------------ //
    // ------------------------------------------------------- //
    var title: String
    var memories: [Memory]
<<<<<<< HEAD
 
    // Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("stories")
    
    //Types
    struct PropertyKey {
=======
    
    // Types to save objects of this class
    struct propertyKey{
>>>>>>> fatemeh-v3
        static let title = "title"
        static let memories = "memories"
    }
    
<<<<<<< HEAD
=======
    // Path to save objects of this class
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("stories")
    
>>>>>>> fatemeh-v3
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
<<<<<<< HEAD

    
    //MARK: NSCoading
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.title)
        aCoder.encode(memories, forKey: PropertyKey.memories)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        guard let title = aDecoder.decodeObject(forKey: PropertyKey.title) as? String
            else {
                os_log("Unable to decode the title for a Story object.",log: OSLog.default, type: .debug)
                return nil
        }
        
        let memories = aDecoder.decodeObject(forKey: PropertyKey.memories) as? [Memory]
        
        //must call designated initializer
        self.init(title: title, memories: memories!)
    }
    
=======
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
>>>>>>> fatemeh-v3
}

