//File Name: MeViewController.swift
//Team Name: MemTech
//Group number: Group 6
//Developers: Harinder
//Version 1.0
//Changes:
//1.0 - Created file
//Known bugs:

import Foundation
import UIKit
import Firebase

class MeViewController:UIViewController {
    var email = ""
    var name = ""
    var DOB = ""
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFromDatabase()
        print(name)
    }
    
    func fetchFromDatabase(){
        let uid = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.email = value?["email"] as? String ?? ""
            self.name = value?["name"] as? String ?? ""
            self.DOB = value?["dateOfBirth"] as? String ?? ""
            //let user = User(username: username)
            self.putItOnProfile()
        }, withCancel: nil)
    }
    
    func putItOnProfile(){
        nameField.text = name
        emailField.text = email
        ageField.text = DOB
    }
    
}





