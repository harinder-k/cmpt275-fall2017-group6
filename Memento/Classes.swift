//
//  Classes.swift
//  Memento
//
//  Created by Matthew Thomas on 11/6/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import Foundation
import UIKit

class Memory{
    
    var Moments: [Moment] = []
    var dateRange : String
    var title: String
    
    init(){
        self.title = ""
        self.dateRange = ""
    }
    
    func setDateRange(start: [Int], finish: [Int] ){
        self.dateRange="\(start[0])//\(start[1])//\(start[2]) - (finish[0])//\(finish[1])//\(start[2]) "
    }
    
    func addMoment(newMom: Moment){
        self.Moments.append(newMom)
        var newIndex = self.getSize() - 1
        self.Moments[newIndex].setPos(index: newIndex)
    }
    
    func remMoment(index: Int){
        if (index < self.getSize()){
            self.Moments.remove(at: index)
            if !(index == self.getSize()){
            self.shiftOrderDown(start: index)
            }
        }
    }
    
    func shiftOrderDown(start: Int){
        for i in start...(self.getSize() - 1){
            self.Moments[i].setPos(index: i)
        }
    }
    
    func getSize()->Int{
        return self.Moments.count
    }
    
    func swapMoment(first: Moment, second: Moment){
        var temp = first.getPos()
        first.setPos(index: second.getPos())
        second.setPos(index: temp)
    }
    
    func setLatestMoment(pic: UIImage){
        self.Moments[self.getSize()-1].setPic(pic: pic)
    }
}

class Moment{
    
    var picture : UIImage
    var location : String
    var date : [Int] = []
    var position : Int
    
    init(){
        self.picture = UIImage(named: "plus")!
        self.date = [0,0,0]
        self.position = 0
        self.location = ""
    }
    
    func setLoc(loc: String){
        self.location = loc
    }
    func setPic(pic : UIImage){
        self.picture = pic
    }
    func setDate(date : [Int]){
        self.date = date
    }
    func setPos(index : Int){
        self.position = index
    }
    func getPos()-> Int{
        return self.position
    }
    func getDate()->[Int]{
        return self.date
    }
    func getPic()-> UIImage{
        return self.picture
    }
    func getLoc()->String{
        return self.location
    }
}
