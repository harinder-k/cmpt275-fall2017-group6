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

class MeViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var email = ""
    var name = ""
    var DOB = ""
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFromDatabase()
        print(name)
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
    
    
    @IBAction func addProfilePicTapped(_ sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = false;
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(image, animated: true)
        {
            // After it is complete
        }
    }
    
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profileImage.image = pickedImage
            
            
            //////////////////////
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            let storage = Storage.storage().reference()
            let temp = storage.child("users").child(uid!).child("temp.jpg")
            
            let metadata = StorageMetadata()
            metadata.contentType = "pickedImage/jpeg"
            /////////////////////
            
        }
        else{
            //Error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
