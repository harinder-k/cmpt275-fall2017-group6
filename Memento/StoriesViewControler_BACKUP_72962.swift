// Creates a question based on memory name and memory date
func createQuestionType1 (memName: String, correctDate: String) -> QuizQuestion {
    // need to know how date is formatted to create options (also need to decide how specific we should go eg. year vs month vs date)
    let q = "When did \(memName) take place?"
    let ops = [correctDate, "", "", ""]
    let question = QuizQuestion(question: q, imageName: "", options: ops, answer: correctDate)
    return question
}

// Creates a question based on an image and the date it was taken
func createQuestionType2 (photoName: String, correctDate: String) -> QuizQuestion {
    // need to know how date is formatted to create options (also need to decide how specific we should go eg. year vs month vs date)
    let q = "When was this photo taken?"
    let ops = [correctDate, "", "", ""]
    let question = QuizQuestion(question: q, imageName: photoName, options: ops, answer: correctDate)
    return question
}

// Creates a question based on an image and the place where it was taken
func createQuestionType3 (photoName: String, correctPlace: String) -> QuizQuestion {
    let q = "Where was this photo taken?"
    let ops = [correctPlace, "", "", ""]
    let question = QuizQuestion(question: q, imageName: photoName, options: ops, answer: correctPlace)
    return question
}

// Creates a question based on an image and the date its memory's date
func createQuestionType4 (photoName: String, correctPerson: String, otherOptions: [String]) -> QuizQuestion {
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
    
    // creating questions and saving into a single object
    let (peopleQuestions, placesQuestions, datesQuestions) = createQuestions(story: story)
    
    // Reference to database
    var ref: DatabaseReference!
    ref = Database.database().reference(fromURL: "https://memento-da996.firebaseio.com/")
    // Reference to users in database seperated by their uid
    let uid = Auth.auth().currentUser?.uid
    let usersRef = ref.child("users").child(uid!)
    
    // create for loop to add all questions
    usersRef.updateChildValues([
        "quizzes" : [
            "people" : [
                "1" : peopleQuestions[0],
                "2" : peopleQuestions[1]
            ],
            "places" : [
                "1" : placesQuestions[0],
                "2" : placesQuestions[1]
            ],
            "dates" : [
                "1" : datesQuestions[0],
                "2" : datesQuestions[2],
            ]
        ]
        ]
    )
    
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
