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
import AVKit
import AVFoundation

class StoriesViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    // ------------------------------------------------------- //
    // These variables are used to store data locally
    // ------------------------------------------------------- //
    var stories:[Story] = []
    var videoURLs: [URL] = []
    var finishedStoriesArray: [Story] = []
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
    let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
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
        finishedStoriesTableView.delegate = self
        finishedStoriesTableView.dataSource = self
        // -------------------------------------------------------------------------------------------------- //
        // Logout button:
        navigationItem
            .leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        checkIfUserIsLoggedIn()
        // -------------------------------------------------------------------------------------------------- //
        // -------------------------------------------------------------------------------------------------- //
        // Load saved data from local directory
        // -------------------------------------------------------------------------------------------------- //
        let ArchiveURL = DocumentsDirectory.appendingPathComponent("FinishedStories")
        if let savedStoriesArray = self.loadStories() {
            stories += savedStoriesArray
        }
        self.refreshInProgressTable()
        if let savedFinishedStoriesArray = self.loadFinishedStories() {
            finishedStoriesArray += savedFinishedStoriesArray
        }
        if finishedStoriesArray.count < 1 {
            return
        }
        for i in 0...finishedStoriesArray.count - 1 {
            var outputURL: NSURL {
                // Use the CachesDirectory so the rendered video file sticks around as long as we need it to.
                // Using the CachesDirectory ensures the file won't be included in a backup of the app.
                let fileManager = FileManager.default
                if let tmpDirURL = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
                    return tmpDirURL.appendingPathComponent(finishedStoriesArray[i].title).appendingPathExtension("mp4") as NSURL
                }
                fatalError("URLForDirectory() failed")
            }
            videoURLs.append(outputURL as URL)
        }
        self.refreshFinishedStoriesTabel()
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
        let ArchiveURL = DocumentsDirectory.appendingPathComponent("FinishedStories")
        let isSuccessfulSavefinished = NSKeyedArchiver.archiveRootObject(finishedStoriesArray, toFile: ArchiveURL.path)
        if isSuccessfulSavefinished {
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
    func loadFinishedStories() -> [Story]? {
        let ArchiveURL = DocumentsDirectory.appendingPathComponent("FinishedStories")
        return NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? [Story]
    }
    func refreshFinishedStoriesTabel(){
        self.finishedStoriesTableView.reloadData()
    }
    func refreshInProgressTable(){
        self.inProgressTableView.reloadData()
    }
    
    // Creates a question based on memory name and memory date
    func createQuestionType1 (memName: String, correctDate: String) -> QuizQuestion {
        // need to know how date is formatted to create options (also need to decide how specific we should go eg. year vs month vs date)
        print("Q1")
        let q = "When did \(memName) take place?"
        let ops = [correctDate, "", "", ""]
        let question = QuizQuestion(question: q, imageName: "", options: ops, answer: correctDate)
        return question
    }
    
    // Creates a question based on an image and the date it was taken
    func createQuestionType2 (photoName: String, correctDate: String) -> QuizQuestion {
        // need to know how date is formatted to create options (also need to decide how specific we should go eg. year vs month vs date)
        print("Q2")
        let q = "When was this photo taken?"
        let ops = [correctDate, "", "", ""]
        let question = QuizQuestion(question: q, imageName: photoName, options: ops, answer: correctDate)
        return question
    }
    
    // Creates a question based on an image and the place where it was taken
    func createQuestionType3 (photoName: String, correctPlace: String) -> QuizQuestion {
        print("Q3")
        let q = "Where was this photo taken?"
        let ops = [correctPlace, "", "", ""]
        let question = QuizQuestion(question: q, imageName: photoName, options: ops, answer: correctPlace)
        return question
    }
    
    // Creates a question based on an image and the date its memory's date
    func createQuestionType4 (photoName: String, correctPerson: String, otherOptions: [String]) -> QuizQuestion {
        print("Q4")
        let q = "Who is in this photo?"
        var threeRandomNums:[Int] = []
        for index in 0...2 {
            var randomIndex:Int
            repeat {
                randomIndex = Int(arc4random_uniform(UInt32(otherOptions.count)))
            } while threeRandomNums.contains(randomIndex)
            threeRandomNums[index] = randomIndex
        }
        let ops = [correctPerson, otherOptions[threeRandomNums[0]], otherOptions[threeRandomNums[1]], otherOptions[threeRandomNums[2]]]
        let question = QuizQuestion(question: q, imageName: photoName, options: ops, answer: correctPerson)
        return question
    }
    
    // creates a question based on a memory's date and a person in one of its photos
    func createQuestionType5 (memName: String, correctPerson: String, otherOptions: [String]) -> QuizQuestion {
        print("Q5")
        let q = "Who was with you during \(memName)?"
        var threeRandomNums:[Int] = []
        for index in 0...2 {
            var randomIndex:Int
            repeat {
                randomIndex = Int(arc4random_uniform(UInt32(otherOptions.count)))
            } while threeRandomNums.contains(randomIndex)
            threeRandomNums[index] = randomIndex
        }
        let ops = [correctPerson, otherOptions[threeRandomNums[0]], otherOptions[threeRandomNums[1]], otherOptions[threeRandomNums[2]]]
        let question = QuizQuestion(question: q, imageName: "", options: ops, answer: correctPerson)
        return question
    }
    
    // creates a function based on an image and it's memory's name
    func createQuestionType6 (photoName: String, correctMemoryName: String, options: [String]) -> QuizQuestion {
        print("Q6")
        let q = "Which memory is this photo from?"
        var threeRandomNums:[Int] = []
        for index in 0...2 {
            var randomIndex:Int
            repeat {
                randomIndex = Int(arc4random_uniform(UInt32(options.count)))
            } while threeRandomNums.contains(randomIndex) && options[randomIndex] == correctMemoryName
            threeRandomNums[index] = randomIndex
        }
        let ops = [correctMemoryName, options[threeRandomNums[0]], options[threeRandomNums[1]], options[threeRandomNums[2]]]
        let question = QuizQuestion(question: q, imageName: photoName, options: ops, answer: correctMemoryName)
        return question
    }
    
    // creates three objects of types [QuizQuestion]
    // populated with questions based on data in story
    func createQuestions(story: Story) -> ([QuizQuestion], [QuizQuestion], [QuizQuestion]) {
        // containers for questions
        var peopleQuestions: [QuizQuestion] = []
        var placesQuestions: [QuizQuestion] = []
        var datesQuestions: [QuizQuestion] = []
        
        // variables to track data to be able to populate options
        var storyPeople:[String] = []
        var memNames:[String] = []
        
        for mem in story.memories {
            memNames.append(mem.name)
            for photo in mem.photos {
                storyPeople.append(contentsOf: photo.people)
            }
        }
        
        // Creating different questions based on which data is avaiable
        for mem in story.memories {
            
            var memPeople:[String] = []
            
            if mem.name != "Memory" && mem.date != "None" {
                datesQuestions.append(createQuestionType1(memName: mem.name, correctDate: mem.date))
            }
            
            if !mem.photos.isEmpty {
                for photo in mem.photos {
                    /////////////// need to get name of image so that QuizQuestion.swift can search for it on Firebase /////////////////
                    //let imgName = photo.image.??
                    let imgName = ""
                    
                    memPeople.append(contentsOf: photo.people)
                    
                    datesQuestions.append(createQuestionType2(photoName: imgName, correctDate: mem.date))
                    
                    if photo.place != "" {
                        placesQuestions.append(createQuestionType3(photoName: imgName, correctPlace: photo.place))
                    }
                    if !photo.people.isEmpty {
                        // Populating options for question type 4 with people not in the same photo
                        var incorrectType4Options:[String] = []
                        for person in storyPeople {
                            if !photo.people.contains(person) {
                                incorrectType4Options.append(person)
                            }
                        }
                        // Making the question if there are enough people not in the photo to show 3 incorrect options
                        if incorrectType4Options.count >= 3 {
                            
                            // setting one of the people in the phoo as the correct answer
                            let personIndex = Int(arc4random_uniform(UInt32(photo.people.count)))
                            peopleQuestions.append(createQuestionType4(photoName: imgName, correctPerson: photo.people[personIndex], otherOptions: incorrectType4Options))
                        }
                        
                        // Populating options for question type 5 with people not in the same memory
                        var incorrectType5Options:[String] = []
                        for person in storyPeople {
                            if !memPeople.contains(person) {
                                incorrectType5Options.append(person)
                            }
                        }
                        // Making the question if there are enough people not in the photo to show 3 incorrect options
                        if incorrectType5Options.count >= 3 {
                            
                            // setting one of the people in the memory as the correct answer
                            let personIndex = Int(arc4random_uniform(UInt32(memPeople.count)))
                            peopleQuestions.append(createQuestionType5(memName: mem.name, correctPerson: memPeople[personIndex], otherOptions: incorrectType5Options))
                        }
                    }
                    
                    if story.memories.count >= 4 {
                        datesQuestions.append(createQuestionType6(photoName: imgName, correctMemoryName: mem.name, options: memNames))
                    }
                }
            }
        }
        return (peopleQuestions, placesQuestions, datesQuestions)
    }
    
    //In progress
    func uploadQuiz(story: Story){
        print("uplpadQuiz called")
        // creating questions and saving into a single object
        let (peopleQuestions, placesQuestions, datesQuestions) = createQuestions(story: story)
        
        // Reference to database
        var ref: DatabaseReference!
        ref = Database.database().reference()
        // Reference to users in database seperated by their uid
        let uid = Auth.auth().currentUser?.uid
        let usersRef = ref.child("users").child(uid!)
        
        var numberOfExistingPeopleQs = 0
        var numberOfExistingPlacesQs = 0
        var numberOfExistingDatesQs = 0
        
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let quizzesSnapshot = snapshot.childSnapshot(forPath: "quizzes")
            numberOfExistingPeopleQs = Int(quizzesSnapshot.childSnapshot(forPath: "people").childrenCount)
            numberOfExistingPlacesQs = Int(quizzesSnapshot.childSnapshot(forPath: "places").childrenCount)
            numberOfExistingDatesQs = Int(quizzesSnapshot.childSnapshot(forPath: "dates").childrenCount)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        usersRef.updateChildValues([
            "quizzes" : [
                "people" : [
                ],
                "places" : [
                ],
                "dates" : [
                ]
            ]
        ])
        
        let peopleRef = usersRef.child("quizzes").child("people")
        let placesRef = usersRef.child("quizzes").child("places")
        let datesRef = usersRef.child("quizzes").child("dates")
        
        if !peopleQuestions.isEmpty {
            for qNumber in 0...(peopleQuestions.count - 1) {
                datesRef.updateChildValues([
                    "\(qNumber + numberOfExistingDatesQs + 1)": [
                        "question" : datesQuestions[qNumber].question,
                        "imageName" : datesQuestions[qNumber].imageName,
                        "option1" : datesQuestions[qNumber].options[0],
                        "option2" : datesQuestions[qNumber].options[1],
                        "option3" : datesQuestions[qNumber].options[2],
                        "option4" : datesQuestions[qNumber].options[3],
                        "answer" : datesQuestions[qNumber].answer
                    ]
                    ])
                }
        }
        
        if !placesQuestions.isEmpty {
            for qNumber in 0...(datesQuestions.count - 1) {
                datesRef.updateChildValues([
                    "\(qNumber + numberOfExistingDatesQs + 1)": [
                        "question" : datesQuestions[qNumber].question,
                        "imageName" : datesQuestions[qNumber].imageName,
                        "option1" : datesQuestions[qNumber].options[0],
                        "option2" : datesQuestions[qNumber].options[1],
                        "option3" : datesQuestions[qNumber].options[2],
                        "option4" : datesQuestions[qNumber].options[3],
                        "answer" : datesQuestions[qNumber].answer
                    ]
                    ])
            }
        }
        
        if !datesQuestions.isEmpty {
            for qNumber in 0...(datesQuestions.count - 1) {
                datesRef.updateChildValues([
                    "\(qNumber + numberOfExistingDatesQs + 1)": [
                        "question" : datesQuestions[qNumber].question,
                        "imageName" : datesQuestions[qNumber].imageName,
                        "option1" : datesQuestions[qNumber].options[0],
                        "option2" : datesQuestions[qNumber].options[1],
                        "option3" : datesQuestions[qNumber].options[2],
                        "option4" : datesQuestions[qNumber].options[3],
                        "answer" : datesQuestions[qNumber].answer
                    ]
                ])
            }
        }
            
        /*
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
 */
        
    }
    // -------------------------------------------------------------------------------------------------- //
    // newStoryButtonPressed function is called when newStory is pressed
    // It pushes 'add new story view' to the navigation controller
    // and takes a story object back from 'add new story view' when user comes back to this view
    // -------------------------------------------------------------------------------------------------- //
    @IBAction func newStoryButtonPressed(_ sender: Any) {
        let editStoryViewController = storyboard?.instantiateViewController(withIdentifier: "EditStoryViewController") as! EditStoryViewController
        
        editStoryViewController.completionHandler = { story, type in
            if type == 0 {
                print("photos = \(story.memories.count)")
                print(story.title)
                if story.memories.count > 0 {
                    print("I have the memories here!")
                    self.stories.append(story)
                    self.saveStories()
                    self.refreshInProgressTable()
                    self.uploadQuiz(story: story)
                    
                }
                return story.memories.count
            }
            else{
                print("photos = \(story.memories.count)")
                print(story.title)
                if story.memories.count > 0 {
                    let storyTitle = story.title
                    var outputURL: NSURL {
                        // Use the CachesDirectory so the rendered video file sticks around as long as we need it to.
                        // Using the CachesDirectory ensures the file won't be included in a backup of the app.
                        let fileManager = FileManager.default
                        if let tmpDirURL = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
                            return tmpDirURL.appendingPathComponent(storyTitle).appendingPathExtension("mp4") as NSURL
                        }
                        fatalError("URLForDirectory() failed")
                    }
                    self.videoURLs.append(outputURL as URL)
                    self.finishedStoriesArray.append(story)
                    //print("I have the memories here!")
                    self.saveStories()
                    self.refreshFinishedStoriesTabel()
                    self.refreshInProgressTable()
                    
                    
                }
                return story.memories.count
            }
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
    // ------------------------------------------------------- //
    func playVideo(index: Int){
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: videoURLs[index].path) {
            print("FILE AVAILABLE")
            let playViewController = AVPlayerViewController()
            let videoPath = NSURL(fileURLWithPath: videoURLs[index].path)
            let player = AVPlayer(url: videoPath as URL)
            //let playerLayer = AVPlayerLayer(player: player)
            //playerLayer.frame = self.view.bounds
            playViewController.player = player
            self.present(playViewController, animated: true){
                playViewController.player?.play()
            }
            //self.view.layer.addSublayer(playerLayer)
            //player.play()
        } else {
            print("FILE NOT AVAILABLE")
        }
    }
    func removefinishedStory(index: Int){
        print(index)
        finishedStoriesArray.remove(at: index)
        videoURLs.remove(at: index)
        self.refreshFinishedStoriesTabel()
    }
    func share(index: Int){
        
    }
    func showFinishedVideoActionSheet(index: Int) {
        // 1 Create an option menu
        let optionMenu = UIAlertController(title: nil, message: "Choose option:", preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        let y_start: CGFloat = self.view.frame.height - 120
        let height: CGFloat = 120
        let width: CGFloat = self.view.frame.width
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 0, y: y_start, width: width, height: height)
        // 2 Create play action
        let addInfoAction = UIAlertAction(title: "Play", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.playVideo(index: index)
            print("Go play video")
        })
        // 3 Create share action
        let shareAction = UIAlertAction(title: "Share to Facebook", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.share(index: index)
            print("Go play video")
        })
        // 4 Create remove photo action
        let removeAction = UIAlertAction(title: "Remove", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.removefinishedStory(index: index)
            print("Remove story")
        })
        
        // 5 Create cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        // 6
        optionMenu.addAction(addInfoAction)
        optionMenu.addAction(shareAction)
        optionMenu.addAction(removeAction)
        optionMenu.addAction(cancelAction)
        
        // 7
        self.present(optionMenu, animated: true, completion: nil)
    }
    private lazy var editStory: EditStoryViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // Instantiate View Controller
        var vc = storyboard.instantiateViewController(withIdentifier: "EditStoryViewController") as! EditStoryViewController
        return vc
    }()
    func EditStory(index: Int) {
        if index >= stories.count {
            return
        }
        editStory.memoriesArray = stories[index].memories
        editStory.myTitle = stories[index].title
        editStory.completionHandler = { story, type in
            if type == 0{
                print("photos = \(story.memories.count)")
                print(story.title)
                if story.memories.count > 0 {
                    //print("I have the memories here!")
                    self.stories.remove(at: index)
                    self.stories.append(story)
                    self.saveStories()
                    self.refreshInProgressTable()
                    self.uploadQuiz(story: story)
                    
                }
                return story.memories.count
            }
            else{
                print("photos = \(story.memories.count)")
                print(story.title)
                if story.memories.count > 0 {
                    let storyTitle = story.title
                    var outputURL: NSURL {
                        // Use the CachesDirectory so the rendered video file sticks around as long as we need it to.
                        // Using the CachesDirectory ensures the file won't be included in a backup of the app.
                        let fileManager = FileManager.default
                        if let tmpDirURL = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
                            return tmpDirURL.appendingPathComponent(storyTitle).appendingPathExtension("mp4") as NSURL
                        }
                        fatalError("URLForDirectory() failed")
                    }
                    self.stories.remove(at: index)
                    self.videoURLs.append(outputURL as URL)
                    self.finishedStoriesArray.append(story)
                    //print("I have the memories here!")
                    self.saveStories()
                    self.refreshFinishedStoriesTabel()
                    self.refreshInProgressTable()
                    
                }
                return story.memories.count
            }
        }
        navigationController?.pushViewController(editStory, animated: true)
    }
    func removeInProgressStory(index: Int){
        print(index)
        stories.remove(at: index)
        self.refreshInProgressTable()
    }
    func showStoriesActionSheet(index: Int) {
        // 1 Create an option menu
        let optionMenu = UIAlertController(title: nil, message: "Choose option:", preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        let y_start: CGFloat = self.view.frame.height - 120
        let height: CGFloat = 120
        let width: CGFloat = self.view.frame.width
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 0, y: y_start, width: width, height: height)
        // 2 Create edit action
        let editAction = UIAlertAction(title: "Edit", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.EditStory(index: index)
        })
        // 4 Create remove photo action
        let removeAction = UIAlertAction(title: "Remove", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.removeInProgressStory(index: index)
            print("Remove story")
        })
        
        // 5 Create cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        // 6
        optionMenu.addAction(editAction)
        optionMenu.addAction(removeAction)
        optionMenu.addAction(cancelAction)
        
        // 7
        self.present(optionMenu, animated: true, completion: nil)
    }
    // -------------------------------------------------------------------------------------------------- //
    //                                      inProgressTable view delegate                                 //
    // -------------------------------------------------------------------------------------------------- //
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == inProgressTableView{
            return self.stories.count
        }
        else {
            return self.videoURLs.count
        }
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == inProgressTableView{
            // create a new cell if needed or reuse an old one
            let cell:UITableViewCell = self.inProgressTableView.dequeueReusableCell(withIdentifier: inProgressCellReuseIdentifier) as UITableViewCell!
            
            print(stories.count)
            // set the text from the data model
            cell.imageView?.image = self.stories[indexPath.row].memories[0].photos[0].image
            cell.textLabel?.text = self.stories[indexPath.row].title
            
            return cell
        }
        else {
            // create a new cell if needed or reuse an old one
            let cell:UITableViewCell = self.finishedStoriesTableView.dequeueReusableCell(withIdentifier: finishedCellReuseIdentifier) as UITableViewCell!
            
            print(finishedStoriesArray.count)
            // set the text from the data model
            cell.imageView?.image = self.finishedStoriesArray[indexPath.row].memories[0].photos[0].image
            cell.textLabel?.text = self.finishedStoriesArray[indexPath.row].title
            return cell
        }
        
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You tapped cell number \(indexPath.row).")
        if tableView == inProgressTableView{
            self.showStoriesActionSheet(index: indexPath.row)
        }
        else{
            self.showFinishedVideoActionSheet(index: indexPath.row)
        }
    }
}
