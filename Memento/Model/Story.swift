//
//  Story.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-17.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit

class Story {
    // ------------------------------------------------------- //
    // ------------------- Story properties ------------------ //
    // ------------------------------------------------------- //
    var title: String
    var memories: [Memory]
    
    var imagesDirectoryPath:String!
    var images:[UIImage]!
    var titles:[String]!
    
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
    // ----------------------- Getters ----------------------- //
    // ------------------------------------------------------- //
 
    // ------------------------------------------------------- //
    // ----------------------- Setters ----------------------- //
    // ------------------------------------------------------- //
}

