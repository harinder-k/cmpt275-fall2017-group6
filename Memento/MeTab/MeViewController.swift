//File Name: MeViewController.swift
//Team Name: MemTech
//Group number: Group 6
//Developers: Abhishek
//Version 3.0
//Changes: Created the file
//         Added functionality to access user info from database
//         

import Foundation
import UIKit
import Firebase

class MeViewController:UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var email = ""
    var name = ""
    var DOB = ""
    var profileURL = ""
    
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
            if snapshot.hasChild("profileImageURL"){
                self.profileURL = value?["profileImageURL"] as? String ?? ""
                self.putProfileImage()
            }
            //let user = User(username: username)
            self.putItOnProfile()
        }, withCancel: nil)
    }
    
    func putProfileImage (){
        let url = URL(string: profileURL)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            self.profileImage.image = UIImage(data: data!)
            }.resume()
    }
    
    func putItOnProfile(){   //Display all the information on the me tab
        nameField.text = name
        emailField.text = email
        ageField.text = DOB
    }
    
    
    @IBAction func addProfilePicTapped(_ sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = true;
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(image, animated: true)
        {
            // After it is complete
        }
    }
    
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            profileImage.image = pickedImage
            
            ///////////////////////
            let imageName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profileImages").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImage.image!){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if (error != nil){
                        print(error!)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                        let value = ["profileImageURL": profileImageUrl]
                        self.uploadimageURl(value: value as [String : AnyObject])
                    }
                    
                })
            }
            //////////////////////
            
            
        }
        else{
            //Error message
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadimageURl(value: [String: AnyObject]){
        let uid = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let userReference = ref.child("users").child(uid!)
        userReference.updateChildValues(value, withCompletionBlock:{
            (err, ref) in
            
            if err != nil{
                print(err!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
}
