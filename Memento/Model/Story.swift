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

class Story: NSObject, NSCoding {
    // ------------------------------------------------------- //
    // ------------------- Story properties ------------------ //
    // ------------------------------------------------------- //
    var title: String
    var memories: [Memory]
 
    // Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("stories")
    
    //Types
    struct PropertyKey {
        static let title = "title"
        static let memories = "memories"
    }
    
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
    
}

