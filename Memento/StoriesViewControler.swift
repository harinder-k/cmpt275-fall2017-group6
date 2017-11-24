//
//  StoriesViewControler.swift
//  Memento
//
//  Created by hkhakh on 10/27/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StoriesViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //var ref: DatabaseReference!
        //ref = Database.database().reference(fromURL: "https://memento-da996.firebaseio.com/")
        //ref.updateChildValues(["test" : 123])
        
        // Logout button:
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        checkIfUserIsLoggedIn()
     
    }
    
    // Creates a question based on memory name and memory date
    func createQuestionType1 (memName: String, memDate: String) -> QuizQuestion {
        // need to know how date is formatted to create options (also need to decide how specific we should go eg. year vs month vs date)
        let q = "When did \(memName) take place?"
        let ops = [memDate, "", "", ""]
        let question = QuizQuestion(question: q, image: "", options: ops, answer: memDate)
        return question
    }
    
    // Creates a question based on an image and the date it was taken
    func createQuestionType2 (photoName: String, photoDate: String) -> QuizQuestion {
        // need to know how date is formatted to create options (also need to decide how specific we should go eg. year vs month vs date)
        let q = "When was this photo taken?"
        let ops = [photoDate, "", "", ""]
        let question = QuizQuestion(question: q, image: photoName, options: ops, answer: photoDate)
        return question
    }
    
    // Creates a question based on an image and the place where it was taken
    func createQuestionType3 (photoName: String, photoPlace: String) -> QuizQuestion {
        let q = "Where was this photo taken?"
        let ops = [photoPlace, "", "", ""]
        let question = QuizQuestion(question: q, image: photoName, options: ops, answer: photoPlace)
        return question
    }
    
    // Creates a question based on an image and the date it was taken
    // In progress
//    func createQuestionType4 (photoName: String, people: String) -> QuizQuestion {
//        let q = "Who is in this photo?"
//        let ops = ["","","",""]
//    }
    
    //In progress
    func uploadQuiz(story: Story){
        // containers for questions
        var peopleQuestions: [QuizQuestion] = []
        var placesQuestions: [QuizQuestion] = []
        var datesQuestions: [QuizQuestion] = []
        
        // variables to track data to be able to populate options
        var numPeople = 0
        var peopleNames = [String]()
        
        for mem in story.memories {
            for photo in mem.photos {
                numPeople = numPeople + photo.people.count
                peopleNames.append(contentsOf: photo.people)
            }
        }
        
        // Creating different questions based on which data is avaiable
        for mem in story.memories {
            
            if mem.name != "Memory" && mem.date != "None" {
                datesQuestions.append(createQuestionType1(memName: mem.name, memDate: mem.date))
            }
            
            if !mem.photos.isEmpty {
                
                
                for photo in mem.photos {
                    // need to get name of image so that QuizQuestion.swift can search for it on Firebase
                    //let imgName = photo.image.??
                    // temp
                    let imgName = ""
                    
                    if photo.date != "" {
                        datesQuestions.append(createQuestionType2(photoName: imgName, photoDate: photo.date))
                    }
                    if photo.place != "" {
                        placesQuestions.append(createQuestionType3(photoName: imgName, photoPlace: photo.place))
                    }
                    if !photo.people.isEmpty {
                        //numPeople
                    }
                }
                
            }
        }
        // Reference to database
        var ref: DatabaseReference!
        ref = Database.database().reference(fromURL: "https://memento-da996.firebaseio.com/")
        // Reference to users in database seperated by their uid
        let uid = Auth.auth().currentUser?.uid
        let usersRef = ref.child("users").child(uid!)
        // References to nodes to database (people/places/dates)
        usersRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild("quizzes"){
                
                let peopleQuestionsCount = snapshot.childSnapshot(forPath: "quizzes/people").childrenCount
                let peopleRef = usersRef.child("quizzes/people/\(peopleQuestionsCount)")
                
                let placesQuestionsCount = snapshot.childSnapshot(forPath: "quizzes/places").childrenCount
                let placesRef = usersRef.child("quizzes/places/\(placesQuestionsCount)")
                
                let datesQuestionsCount = snapshot.childSnapshot(forPath: "quizzes/dates").childrenCount
                let datesRef = usersRef.child("quizzes/dates/\(datesQuestionsCount)")
             
                // Updating the database
//                for question in peopleQuestions{
//                    peopleRef.updateChildValues(["question": question.question,"imageName":question.imageName,"option1": question.options[0], "option2":question.options[1], "option3": question.options[2], "option4": question.options[3],"answer": question.answer])
//                }
//                for question in placesQuestions{
//                    placesRef.updateChildValues(["question":question.question,"imageName":question.imageName, "option1": question.options[0], "option2":question.options[1],"option3": question.options[2], "option4": question.options[3],"answer": question.answer])
//                }
//                for question in datesQuestions{
//                    datesRef.updateChildValues(["question": question.question,"imageName": question.imageName,"option1": question.options[0], "option2":question.options[1], "option3": question.options[2], "option4": question.options[3],"answer": question.answer])
//                }
            }
            else{
                // IDK what to do?!?!
            }
        }
        
    }
    // newStoryButtonPressed function is called when newStory is pressed
    // It pushes 'add new story view' to the navigation controller
    // and takes a story object back from 'add new story view' when user comes back to this view
    @IBAction func newStoryButtonPressed(_ sender: Any) {
        let editStoryViewController = storyboard?.instantiateViewController(withIdentifier: "EditStoryViewController") as! EditStoryViewController
        
        editStoryViewController.completionHandler = { story in
            print("photos = \(story.memories.count)")
            print(story.title)
            if story.memories.count > 0 {
                print("I have the memories here!")
                self.uploadQuiz(story: story)
                
            }
            return story.memories.count
        }
        navigationController?.pushViewController(editStoryViewController, animated: true)
        
    }
    // checkIfUserIsLoggedIn function checks if the user is loged in and presents the login page
    // if user hasnt already logedin
    @objc func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
            let uid = Auth.auth().currentUser?.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
            }, withCancel: nil)
        }
    }
    // Called when logout button is pressed
    // Logs the user out
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}
