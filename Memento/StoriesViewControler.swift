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
    // ------------------------------------------------------- //
    // These variables are used to store data locally
    // ------------------------------------------------------- //
    var storiesDirectoryPath:String!
    var stories:[Story]!
    var titles:[String]!
    // ------------------------------------------------------- //
    override func viewDidLoad() {
        super.viewDidLoad()
        //var ref: DatabaseReference!
        //ref = Database.database().reference(fromURL: "https://memento-da996.firebaseio.com/")
        //ref.updateChildValues(["test" : 123])
        
        // Logout button:
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        checkIfUserIsLoggedIn()
        // ------------------------------------------------------- //
        // Create a Document directory for this app to save data
        // locally
        // ------------------------------------------------------- //
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let documentDirectorPath:String = paths[0]
        // Create a new path for the new images folder
        storiesDirectoryPath = (documentDirectorPath as NSString).appending("/stories")
        var objcBool:ObjCBool = true
        let doesExist = FileManager.default.fileExists(atPath: storiesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if doesExist == false{
            do{
                try FileManager.default.createDirectory(atPath: storiesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
        // ------------------------------------------------------- //
     
    }
    func uploadQuiz(story: Story){
        // New Quiz entries
        // I have no idea how to create these based on memroy fields
        var peopleQuestions: [QuizQuestion] = []
        var placesQuestions: [QuizQuestion] = []
        var datesQuestions: [QuizQuestion] = []
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
                for question in peopleQuestions{
                    peopleRef.updateChildValues(["question": question.question,"imageName":question.imageName,"option1": question.options[0], "option2":question.options[1], "option3": question.options[2], "option4": question.options[3],"answer": question.answer])
                }
                for question in placesQuestions{
                    placesRef.updateChildValues(["question":question.question,"imageName":question.imageName, "option1": question.options[0], "option2":question.options[1],"option3": question.options[2], "option4": question.options[3],"answer": question.answer])
                }
                for question in datesQuestions{
                    datesRef.updateChildValues(["question": question.question,"imageName": question.imageName,"option1": question.options[0], "option2":question.options[1], "option3": question.options[2], "option4": question.options[3],"answer": question.answer])
                }
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
