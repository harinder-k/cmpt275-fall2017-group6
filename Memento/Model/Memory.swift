//
//  Memory.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-09.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit

class Memory {
    // ------------------------------------------------------- //
    // ------------------- Memory properties ----------------- //
    // ------------------------------------------------------- //
    var name: String
    var date: String
    var photos: [MemoryImage] 
    // ------------------------------------------------------- //
    // -------------------- Initialization ------------------- //
    // ------------------------------------------------------- //
    init?(name: String, date: String, photos: [MemoryImage]){
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
        let newPhoto = MemoryImage(image: image)
        self.photos.append(newPhoto)
        print("addPhoto succeeded -> photo was successfuly added to memory")
        return true
    }
    func addPhoto(newPhoto: MemoryImage) -> Bool{
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
    
}

struct MemoryImage {
    var image : UIImage
    var place: String = ""
    var people: [String] = []
    var date: String = ""
    init(image: UIImage){
        self.image = image
        self.place = ""
        self.people = []
        self.date = ""
    }
}

