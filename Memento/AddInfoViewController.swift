//
//  AddInfoViewController.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-13.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit

class AddInfoViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(BackToMemoryButton)
        view.addSubview(peopleTextField)
        view.addSubview(placeTextField)
        setupBackToMemoryButton()
        setupPlaceTextField()
        setupPeopleTextField()

        // Do any additional setup after loading the view.
    }

    // ------------------------------------------------------------ //
    // ----------------------- UI Objects ------------------------- //
    // ------------------------------------------------------------ //
    //Back to MemoryViewController
    let BackToMemoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161) //5065A1
        button.setTitle("Back To Memory", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleBackToMemoryButton), for: .touchUpInside)
        return button
    }()
    //Text input for People, For now only can add one person
    let peopleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "People"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    //Text input for location
    let placeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Location"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    //Text input for details... not in Memory object yet, maby should be??
    let detailsTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Details..."
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    // ------------------------------------------------------- //
    // ---------------- Seting up UI Objects ----------------- //
    // ------------------------------------------------------- //
    func setupBackToMemoryButton() {
        // Need x, y, width, height constraint
        BackToMemoryButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        BackToMemoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        BackToMemoryButton.leftAnchor.constraint(equalTo: BackToMemoryButton.rightAnchor, constant: -100).isActive = true
        BackToMemoryButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        BackToMemoryButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupPlaceTextField() {
        placeTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        placeTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        placeTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        placeTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupPeopleTextField() {
        peopleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
        peopleTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        peopleTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        peopleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    // ----------------------------------------------------- //
    // ---------------------- Handlers --------------------- //
    // ----------------------------------------------------- //
    @objc func handleBackToMemoryButton() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
