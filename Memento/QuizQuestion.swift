//
//  QuizQuestion.swift
//  Memento
//
//  Created by hkhakh on 11/14/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import Foundation

struct Options {
    var option1: String
    var option2: String
    var option3: String
    var option4: String
}

struct QuizQuestion: Hashable {
    var hashValue: Int {
        return question.hashValue
    }
    
    var question: String
    var imageName: String
    var options: [String]
    var answer: String
    
    static func == (lhs: QuizQuestion, rhs: QuizQuestion) -> Bool {
        return lhs.question == rhs.question && lhs.imageName == rhs.imageName && lhs.options == rhs.options && lhs.answer == rhs.answer
    }
}





