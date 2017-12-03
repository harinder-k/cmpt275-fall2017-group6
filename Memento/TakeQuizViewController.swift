//File Name: TakeQuizViewController.swift
//Team Name: MemTech
//Group number: Group 6
//Developers: Abhi, Harinder
//Version 1.2
//Changes:
//1.0 - Created file and added title using stringOassed
//1.1 - Mapped buttons to functions and implemented basic quiz
//1.2 - Implemented quiz
//1.3 - Implemented personal quizzes
//TODO: Move to json


import Foundation
import UIKit
import Firebase

class TakeQuizViewController:UIViewController {
    let titleEnd = " Quiz"
    var personalQuizSelected = false
    let correctAnswerMessage = "Correct Answer!"
    let wrongAnswerMessage = "Wrong Answer"
    var numberOfQuestions = 5
    
    var correctAnswer = ""
    
    var quizName = ""                                                                           // set by QuizVieeController based on which button is passed
    var questionNum = -1
    var numCorrectAnswers = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    // to inform the user whether or not their answer was correct
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var optionButtons: [UIButton] = [self.option1Button, self.option2Button, self.option3Button, self.option4Button]
    
    @IBOutlet weak var nextButton: UIButton!
    
    // array of structs to hold quiz content
    var quiz = [QuizQuestion]()
    
    // container to hold images used in questions and iterator for said container
    var images:[UIImage] = []
    var imagesIndex = -1
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////// Quiz content for general quizzes ///////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    let animalQuestions = ["What is the fastest land animal?", "What is the tallest animal?", "What is a group of lions called?", "How many legs does a spider have?", "Which of the following animals is a herbivore?"]
    let animalOptions = [["Deer", "Cougar", "Cheetah", "Penguin"], ["Antelope", "Giraffe", "Horse", "Ostrich"], ["Pride", "Gang", "School", "Pack"], ["4", "6", "7", "8"], ["Bear", "Fox", "Frog", "Elephant"]]
    let animalAnswers = ["Cheetah", "Giraffe", "Pride", "8", "Elephant"]
    let geographyQuestions = ["Which country has the highest population?", "What is the capital of Spain?", "In which city is the Eiffel Tower located?", "Which country is the largest by land area?", "What is the biggest continent on Earth?"]
    let geographyOptions = [["India", "China", "United States of America", "Japan"], ["Madrid", "Seville", "Barcelona", "Valencia"], ["London", "Tokyo", "New York", "Paris"], ["Canada", "United States of America", "Russia", "China"], ["Africa", "Asia", "North America", "Antarctica"]]
    let geographyAnswers = ["China", "Madrid", "Paris", "Russia", "Aaia"]
    let famousPeopleQuestions = ["Who is the current president of the United States of America?", "Who invented the telephone?", "Which famous celebrity has the nickname 'The Rock'?", "Who discovered gravity?", "Who was the first person to walk on the moon?"]
    let famousPeopleOptions = [["Barack Obama", "Donald Trump", "Bill Clinton", "George W. Bush"], ["Nikola Tesla", "Thomas Edison", "Alenxander Graham Bell", "Alan Turing"], ["Dwayne Johnson", "Jason Statham", "Vin Diesel", "Matt Damon"], ["Albert Einstein", "Isaac Newton", "Neils Bohr", "Charles Darwin"], ["Buzz Aldrin", "Charles Conrad", "Alan Shepard", "Neil Armstrong"]]
    let famousPeopleAnswers = ["Donald Trump", "Alenxander Graham Bell", "Dwayne Johnson", "Isaac Newton", "Neil Armstrong"]
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////End Of quiz content for general quizzes//////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = quizName + titleEnd
        
        if personalQuizSelected {
            startPersonalQuiz()
        } else {
            startGeneralQuiz()
        }
    }
    
    // downloads image from firebase indicated by string and returns it
    func downloadImage (imgName: String) {
        if imgName == "" {
            return
        }
        
        let imageReference = Storage.storage().reference().child("images")
        
        let downloadImageRef = imageReference.child(imgName)
        
        // assigning Memento logo in case there is a problem when downloading
//        var img: UIImage = #imageLiteral(resourceName: "icon")
        
        ////////////////////////////////////////////////////////////////////////////
        /////////////////////////// NEED TO WORK ON THIS ///////////////////////////
        ////////////////////////////////////////////////////////////////////////////
        downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            if let error = error {
                print(error)
            }
            else {
                let image = UIImage(data: data!)!
                self.imageView.isHidden = false
                self.imageView.image = image
            }
            print (error ?? "No error")
        }
    }
    
    // shuffles 1, 2, 3, 4 and returns as array of Ints
    func shuffleOneToFour() -> [Int] {
        var shuffledIndices:[Int] = []
        for _ in 0...3 {
            var randomIndex:Int
            repeat {
                randomIndex = Int(arc4random_uniform(UInt32(4))) + 1
            } while shuffledIndices.contains(randomIndex)
            shuffledIndices.append(randomIndex)
        }
        return shuffledIndices
    }
    
    // takes random indices upto numberOfQuestions from upto given index
    func pickRandomIndices (totalNum: Int) -> [Int] {
        var resultArray: [Int] = []
        
        // returning default array [0,1,2....]
        if totalNum < numberOfQuestions {
            numberOfQuestions = totalNum
            for index in 0...(totalNum - 1) {
                resultArray.append(index)
            }
            return resultArray
        }
        
        for _ in 0...(numberOfQuestions - 1) {
            var randomIndex:Int
            repeat {
                randomIndex = Int(arc4random_uniform(UInt32(totalNum)))
            } while resultArray.contains(randomIndex)
            resultArray.append(randomIndex)
        }
        return resultArray
    }
    
    // Precondition:    Personal quiz content is avvilable
    // Postcondition:   Quiz content is arranged into array of structs
    func startPersonalQuiz() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        var imagesNames:[String] = []
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("quizzes")
            {
                let quizzesSnapshot = snapshot.childSnapshot(forPath: "quizzes")
                if quizzesSnapshot.hasChild(self.quizName) {
                    let quizSnapshot = quizzesSnapshot.childSnapshot(forPath: self.quizName)
                    let numQsOnDatabase = Int(quizSnapshot.childrenCount)
                    
                    let databaseQIndices = self.pickRandomIndices(totalNum: numQsOnDatabase)
                    
                    // selecting random indices from quiz questions on database
                    for i in databaseQIndices {
                        // setting values from database
                        let questionSnapshot = quizSnapshot.childSnapshot(forPath: "\(i+1)") as DataSnapshot
                        let questionValue = questionSnapshot.value as! NSDictionary
                        let q = questionValue["question"] as? String ?? ""
                        let imgName = questionValue["imageName"] as? String ?? ""
                        
                        // randomizing order that the options appear in
                        let shuffledIndices = self.shuffleOneToFour()
                        let op1 = questionValue["option\(shuffledIndices[0])"] as? String ?? ""
                        let op2 = questionValue["option\(shuffledIndices[1])"] as? String ?? ""
                        let op3 = questionValue["option\(shuffledIndices[2])"] as? String ?? ""
                        let op4 = questionValue["option\(shuffledIndices[3])"] as? String ?? ""
                        let ans = questionValue["answer"] as? String ?? ""
                        
                        // creating quiz question using database values as appending into quiz array
                        self.quiz.append(QuizQuestion(question: q, imageName: imgName, options: [op1, op2, op3, op4], answer: ans))
                        
                        // keeping track of images
                        if imgName != "" {
                            imagesNames.append(imgName)
                        }
                    }
                    self.askQuestion()
                    
                } else {
                    let noRequestedQuizMessage = "Sorry, the \(self.quizName) quiz does not exist because you have not created a story with enough \(self.quizName) in it."
                    self.finishedState(message: noRequestedQuizMessage)
                }
            } else {
                let noQuizMessage = "Sorry, we have no personal quizzes for you yet. Please finish a story so that we can create questions based on your story."
                self.finishedState(message: noQuizMessage)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Precondition:    General quiz content is available
    // Postcondition:   Quiz content is arranged into array of structs
    func startGeneralQuiz() {
        switch (quizName) {
            case "Animals":
                for i in 0...(numberOfQuestions - 1) {
                quiz.append(QuizQuestion(question: animalQuestions[i], imageName: "", options: animalOptions[i], answer: animalAnswers[i]))
            }
            case "Geography":
                for i in 0...(numberOfQuestions - 1) {
                quiz.append(QuizQuestion(question: geographyQuestions[i], imageName: "", options: geographyOptions[i], answer: geographyAnswers[i]))
            }
            case "Famous People":
                for i in 0...(numberOfQuestions - 1)  {
                quiz.append(QuizQuestion(question: famousPeopleQuestions[i], imageName: "", options: famousPeopleOptions[i], answer: famousPeopleAnswers[i]))
            }
            default:
            break
        }
        askQuestion()
    }
    
    // Precondition:    THe user has not yet answered the question
    // Postcondition:   Image view, Feedback label and Next button are hidden from the user
    //                  and the option buttions are enabled
    func unansweredState() {
        for aButton in optionButtons {
            aButton.isEnabled = true
        }
        imageView.isHidden = true
        feedbackLabel.isHidden = true
        nextButton.isHidden = true
    }
    
    // Precondition:    The user has answered the question
    // Postcondition:   Feedback label and Next (or Finish) button are visible to the user
    //                  and the option buttons are disabled
    func answeredState() {
        for aButton in optionButtons {
            aButton.isEnabled = false
        }
        if questionNum == numberOfQuestions - 1 {
            nextButton.setTitle("Finish", for: UIControlState.normal)
        }
        feedbackLabel.isHidden = false
        nextButton.isHidden = false
    }
    
    // Precondition:    The user has pressed the Finish button
    // Postcondition:   All objects are hidden and result is shown
    func finishedState(message: String) {
        imageView.isHidden = true
        questionLabel.isHidden = true
        feedbackLabel.isHidden = true
        nextButton.isHidden = true
        
        for aButton in optionButtons {
            aButton.isHidden = true
        }
        resultLabel.text = message
    }
    
    // Precondition:    There are questions left to be answered
    // Postcondition:   The question, image (if applicanle) and options are visible to the user
    func askQuestion() {
        unansweredState()
        questionNum = questionNum + 1
        questionLabel.text = quiz[questionNum].question
        option1Button.setTitle(quiz[questionNum].options[0], for: UIControlState.normal)
        option2Button.setTitle(quiz[questionNum].options[1], for: UIControlState.normal)
        option3Button.setTitle(quiz[questionNum].options[2], for: UIControlState.normal)
        option4Button.setTitle(quiz[questionNum].options[3], for: UIControlState.normal)
        
        correctAnswer = quiz[questionNum].answer
        
        // apply corresponding image of question to image, if there is one
//        if quiz[questionNum].imageName != "" && !images.isEmpty {
//            imagesIndex = imagesIndex + 1
//            imageView.isHidden = false
//            imageView.image = images[imagesIndex]
//        }
        downloadImage(imgName: quiz[questionNum].imageName)
    }
    
    // Precondition:    An option button is tapped
    // Postconodition:  The result is shown to the user and recorded
    @IBAction func option1ButtonTapped(_ sender: Any) {
        if correctAnswer == option1Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
            numCorrectAnswers = numCorrectAnswers + 1
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
        answeredState()
    }
    
    // Precondition:    An option button is tapped
    // Postconodition:  The result is shown to the user and recorded
    @IBAction func option2ButtonTapped(_ sender: Any) {
        if correctAnswer == option2Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
            numCorrectAnswers = numCorrectAnswers + 1
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
        answeredState()
    }
    
    // Precondition:    An option button is tapped
    // Postconodition:  The result is shown to the user and recorded
    @IBAction func option3ButtonTapped(_ sender: Any) {
        if correctAnswer == option3Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
            numCorrectAnswers = numCorrectAnswers + 1
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
        answeredState()
    }
    
    // Precondition:    An option button is tapped
    // Postconodition:  The result is shown to the user and recorded
    @IBAction func option4ButtonTapped(_ sender: Any) {
        if correctAnswer == option4Button.title(for: UIControlState.normal) {
            feedbackLabel.text = correctAnswerMessage
            numCorrectAnswers = numCorrectAnswers + 1
        } else {
            feedbackLabel.text = wrongAnswerMessage
        }
        answeredState()
    }
    
    // Precondition:    The next button is tapped
    // Postcondition:   If there are more questions left, the next question is shown
    //                  If all questions have been asked, the result screen is shown
    @IBAction func nextButtonTapped(_ sender: Any) {
        if questionNum == numberOfQuestions - 1 {
            let resultMeesage = "You answered \(numCorrectAnswers) out of \(numberOfQuestions) questions correctly."
            finishedState(message: resultMeesage)
        } else {
            askQuestion()
        }
    }
}
