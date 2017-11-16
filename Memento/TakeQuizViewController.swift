//File Name: TakeQuizViewController.swift
//Team Name: MemTech
//Group number: Group 6
//Developers: Abhi, Harinder
//Version 1.2
//Changes:
//1.0 - Created file and added title using stringOassed
//1.1 - Mapped buttons to functions and implemented basic quiz
//1.2 - Implemented quiz
//TODO: Move to json
//Known bugs: Crashes with personal quizzes


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
    @IBOutlet weak var feedbackLabel: UILabel!                                                  // to inform the user whether or not their answer was correct
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    
    lazy var optionButtons: [UIButton] = [self.option1Button, self.option2Button, self.option3Button, self.option4Button]
    
    @IBOutlet weak var nextButton: UIButton!
    
    var quiz = [QuizQuestion]()                                                                 // array of structs to hold quiz content
    
    let animalQuestions = ["What is the fastest land animal?", "What is the tallest animal?", "What is a group of lions called?", "How many legs does a spider have?", "Which of the following animals is a herbivore?"]
    
    let animalOptions = [Options(option1: "Deer", option2: "Cougar", option3: "Cheetah", option4: "Penguin"), Options(option1: "Antelope", option2: "Giraffe", option3: "Horse", option4: "Ostrich"), Options(option1: "Pride", option2: "Gang", option3: "School", option4: "Pack"), Options(option1: "4", option2: "6", option3: "7", option4: "8"), Options(option1: "Bear", option2: "Fox", option3: "Frog", option4: "Elephant")]
    
    let animalAnswers = ["Cheetah", "Giraffe", "Pride", "8", "Elephant"]
    
    let geographyQuestions = ["Which country has the highest population?", "What is the capital of Spain?", "In which city is the Eiffel Tower located?", "Which country is the largest by land area?", "What is the biggest continent on Earth?"]
    
    let geographyOptions = [Options(option1: "India", option2: "China", option3: "United States of America", option4: "Japan"), Options(option1: "Madrid", option2: "Seville", option3: "Barcelona", option4: "Valencia"), Options(option1: "London", option2: "Tokyo", option3: "New York", option4: "Paris"), Options(option1: "Canada", option2: "United States of America", option3: "Russia", option4: "China"), Options(option1: "Africa", option2: "Asia", option3: "North America", option4: "Antarctica")]
    
    let geographyAnswers = ["China", "Madrid", "Paris", "Russia", "Aaia"]
    
    let famousPeopleQuestions = ["Who is the current president of the United States of America?", "Who invented the telephone?", "Which famous celebrity has the nickname 'The Rock'?", "Who discovered gravity?", "Who was the first person to walk on the moon?"]
    
    let famousPeopleOptions = [Options(option1: "Barack Obama", option2: "Donald Trump", option3: "Bill Clinton", option4: "George W. Bush"), Options(option1: "Nikola Tesla", option2: "Thomas Edison", option3: "Alenxander Graham Bell", option4: "Alan Turing"), Options(option1: "Dwayne Johnson", option2: "Jason Statham", option3: "Vin Diesel", option4: "Matt Damon"), Options(option1: "Albert Einstein", option2: "Isaac Newton", option3: "Neils Bohr", option4: "Charles Darwin"), Options(option1: "Buzz Aldrin", option2: "Charles Conrad", option3: "Alan Shepard", option4: "Neil Armstrong")]
    
    let famousPeopleAnswers = ["Donald Trump", "Alenxander Graham Bell", "Dwayne Johnson", "Isaac Newton", "Neil Armstrong"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = quizName + titleEnd
        
        if personalQuizSelected {
            makePersonalQuiz()
        } else {
            makeGeneralQuiz()
        }
//        extractFromJson()
        //askQuestion()
    }
    
    // Precondition:    Personal quiz content is avvilable
    // Postcondition:   Quiz content is arranged into array of structs
    func makePersonalQuiz() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let quizzesSnapshot = snapshot.childSnapshot(forPath: "quizzes")
            let peopleQuizSnapshot = quizzesSnapshot.childSnapshot(forPath: "people")
            
            print("\(peopleQuizSnapshot.value)")
            var personalQuizQuestion = [PersonalQuizQuestion]()
            for i in 0...1 {
                let questionIndex = "\(i+1)"
                let questionSnapshot = peopleQuizSnapshot.childSnapshot(forPath: questionIndex) as DataSnapshot
                let questionValue = quizzesSnapshot.value as! [String:Any]
                quizzesSnapshot.value(forKeyPath: "questions")
                personalQuizQuestion.append(PersonalQuizQuestion(question: quizzesSnapshot.value(forKeyPath: "questions") as! String, imageName: quizzesSnapshot.value(forKeyPath: "imageName") as! String, option1: quizzesSnapshot.value(forKeyPath: "option1") as! String, option2: quizzesSnapshot.value(forKeyPath: "option2") as! String, option3: quizzesSnapshot.value(forKeyPath: "option3") as! String, option4: quizzesSnapshot.value(forKeyPath: "option4") as! String, answer: quizzesSnapshot.value(forKeyPath: "answer") as! String))
//                personalQuizQuestion.append(PersonalQuizQuestion(question: questionValue["question"] as! String, imageName: questionValue["imageName"] as! String, option1: questionValue["option1"] as! String, option2: questionValue["option2"] as! String, option3: questionValue["option3"] as! String, option4: questionValue["option4"] as! String, answer: questionValue["answer"] as! String))
                print(personalQuizQuestion[i])
            }
            
            
//            let peopleDict = peopleQuizSnapshot.value as! [String:AnyObject]
//            let q1 = peopleDict["1"]!
//            let question = q1["question"]
//            print(question)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // Precondition:    General quiz content is available
    // Postcondition:   Quiz content is arranged into array of structs
    func makeGeneralQuiz() {
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
    }
    
    // Precondition:    THe user has not yet answered the question
    // Postcondition:   Feedback label and Next button are hidden from the user
    //                  and the option buttions are enabled
    func unansweredState() {
        for aButton in optionButtons {
            aButton.isEnabled = true
        }
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
    func finishedState() {
        questionLabel.isHidden = true
        feedbackLabel.isHidden = true
        nextButton.isHidden = true
        
        for aButton in optionButtons {
            aButton.isHidden = true
        }
        resultLabel.text = "You answered \(numCorrectAnswers) out of \(numberOfQuestions) questions correctly."
    }
    
    // Precondition:    A json file exists for the appropriate quiz and is well structured
    // Postcondition:   Quiz data is read from the json file
//    func extractFromJson(){
//        if let quizFilePath = Bundle.main.path(forResource: "Animals", ofType: "rtf", inDirectory: "Quiz"){
//            do {
//                let data = try Data(contentsOf : URL(fileURLWithPath: quizFilePath), options: .alwaysMapped)
//                let decoder = JSONDecoder()
//                let questions = try? decoder.decode([QuizQuestion].self, from: data)
//                print(questions![0].answer)
//                question = questions![0].question
//                NSLog(question)
//            } catch let error {
//                print(error.localizedDescription)
//            }
//        } else {
//            print("Invalid filename/path.")
//        }
//    }
    
    // Precondition:    There are questions left to be answered
    // Postcondition:   The question, image (if applicanle) and options are visible to the user
    func askQuestion() {
        unansweredState()
        questionNum = questionNum + 1
        questionLabel.text = quiz[questionNum].question
        option1Button.setTitle(quiz[questionNum].options.option1, for: UIControlState.normal)
        option2Button.setTitle(quiz[questionNum].options.option2, for: UIControlState.normal)
        option3Button.setTitle(quiz[questionNum].options.option3, for: UIControlState.normal)
        option4Button.setTitle(quiz[questionNum].options.option4, for: UIControlState.normal)
        
        correctAnswer = quiz[questionNum].answer
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
            finishedState()
        } else {
            askQuestion()
        }
    }
}
