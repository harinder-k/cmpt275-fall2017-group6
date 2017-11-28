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

class StoriesViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    // ------------------------------------------------------- //
    // These variables are used to store data locally
    // ------------------------------------------------------- //
    var stories:[Story] = []
    // ------------------------------------------------------- //
    // ------------------------------------------------------- //
    // These variables are used for the following table views:
    // -> inProgress table view
    // -> finishedStories table view
    // ------------------------------------------------------- //
    @IBOutlet weak var finishedStoriesTableView: UITableView!
    let finishedCellReuseIdentifier = "finished"
    @IBOutlet weak var inProgressTableView: UITableView!
    let inProgressCellReuseIdentifier = "inProgress"
    // ------------------------------------------------------- //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var ref: DatabaseReference!
        //ref = Database.database().reference(fromURL: "https://memento-da996.firebaseio.com/")
        //ref.updateChildValues(["test" : 123])
        // ------------------------------------------------------- //
        // Register the table view cell class and its reuse id
        self.finishedStoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: finishedCellReuseIdentifier)
        self.inProgressTableView.register(UITableViewCell.self, forCellReuseIdentifier: inProgressCellReuseIdentifier)
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        inProgressTableView.delegate = self
        inProgressTableView.dataSource = self
        // -------------------------------------------------------------------------------------------------- //
        // Logout button:
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        checkIfUserIsLoggedIn()
        // -------------------------------------------------------------------------------------------------- //
        // -------------------------------------------------------------------------------------------------- //
        // Load saved data from local directory
        // -------------------------------------------------------------------------------------------------- //
        if let savedStoriesArray = self.loadStories() {
            stories += savedStoriesArray
        }
        self.refreshInProgressTable()
        // ------------------------------------------------------- //
     
    }
    // ---------------------------------------------------------------- //
    // Saves list of Story objects in app's local directory
    // path to save the object: /PATH/TO/DOCUMENT/DIRECTORY/stories
    // ---------------------------------------------------------------- //
    private func saveStories(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(stories, toFile: Story.ArchiveURL.path)
        if isSuccessfulSave {
            print("Stories successfully saved.")
        } else {
            print("Failed to save stories...")
        }
    }
    // ---------------------------------------------------------------- //
    // Loads list of Story objects from app's local directory
    // path to saved objects: /PATH/TO/DOCUMENT/DIRECTORY/stories
    // ---------------------------------------------------------------- //
    func loadStories() -> [Story]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Story.ArchiveURL.path) as? [Story]
    }
    
    func refreshInProgressTable(){
        self.inProgressTableView.reloadData()
    }
    // -------------------------------------------------------------------------------------------------- //
    // Creates and uploads quizzes to database
    // -------------------------------------------------------------------------------------------------- //
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
    // -------------------------------------------------------------------------------------------------- //
    // newStoryButtonPressed function is called when newStory is pressed
    // It pushes 'add new story view' to the navigation controller
    // and takes a story object back from 'add new story view' when user comes back to this view
    // -------------------------------------------------------------------------------------------------- //
    @IBAction func newStoryButtonPressed(_ sender: Any) {
        let editStoryViewController = storyboard?.instantiateViewController(withIdentifier: "EditStoryViewController") as! EditStoryViewController
        
        editStoryViewController.completionHandler = { story in
            print("photos = \(story.memories.count)")
            print(story.title)
            if story.memories.count > 0 {
                print("I have the memories here!")
                self.stories.append(story)
                self.saveStories()
                self.refreshInProgressTable()
                //self.uploadQuiz(story: story)
                
            }
            return story.memories.count
        }
        navigationController?.pushViewController(editStoryViewController, animated: true)
        
    }
    // -------------------------------------------------------------------------------------------------- //
    // checkIfUserIsLoggedIn function checks if the user is loged in and presents the login page
    // if user hasnt already logedin
    // -------------------------------------------------------------------------------------------------- //
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
    // ------------------------------------------------------- //
    // Called when logout button is pressed
    // Logs the user out
    // ------------------------------------------------------- //
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    // -------------------------------------------------------------------------------------------------- //
    //                                      inProgressTable view delegate                                 //
    // -------------------------------------------------------------------------------------------------- //
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stories.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.inProgressTableView.dequeueReusableCell(withIdentifier: inProgressCellReuseIdentifier) as UITableViewCell!
        
        print(stories.count)
        // set the text from the data model
        cell.imageView?.image = self.stories[indexPath.row].memories[0].photos[0].image
        cell.textLabel?.text = self.stories[indexPath.row].title
        
        return cell
    }
    private lazy var editStory: EditStoryViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // Instantiate View Controller
        var vc = storyboard.instantiateViewController(withIdentifier: "EditStoryViewController") as! EditStoryViewController
        return vc
    }()
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row).")
        editStory.memoriesArray = stories[indexPath.row].memories
        editStory.myTitle = stories[indexPath.row].title
        stories.remove(at: indexPath.row)
        editStory.completionHandler = { story in
            print("photos = \(story.memories.count)")
            print(story.title)
            if story.memories.count > 0 {
                //print("I have the memories here!")
                self.stories.append(story)
                self.saveStories()
                self.refreshInProgressTable()
                //self.uploadQuiz(story: story)
                
            }
            return story.memories.count
        }
        navigationController?.pushViewController(editStory, animated: true)
    }
}
