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

class MeViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var email = ""
    var name = ""
    var DOB = ""
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFromDatabase()
        print(name)
        
        imagePicker.delegate = self
    }
    
    
    func fetchFromDatabase(){      //Fetch the information from the firebase database
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
    
    func putItOnProfile(){   //Display all the information on the me tab
        nameField.text = name
        emailField.text = email
        ageField.text = DOB
    }
    
    @IBAction func addProfilePicTapped(_ sender: Any) {
        imagePicker.allowsEditing = false;
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFit
            profileImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}





