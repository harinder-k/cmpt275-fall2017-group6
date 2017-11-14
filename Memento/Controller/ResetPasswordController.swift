//
//  File Name: ResetPasswordController.swift
//  Team Name: MemTech
//  Group Number: Group 6
//  Developers: Fatemeh Darbehani
//  Version 1.0
//
//  Todo:
//  1. Check if email address exists and show appropriate alert
//  2. Redirect to the start page after sending reset password email
//
//  Known bug:
//  1. Reset password email takes too long to send
//  2. Seperator bars missing above and below email text field
//
//  Created by fatemeh darbehani on 2017-11-02.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(emailTextField)
        view.addSubview(resetPasswordButton)
        view.addSubview(navigationBar)
        view.addSubview(logoImageView)
        view.addSubview(descriptionLabel)
        setupNavigationBar()
        setupEmailTextField()
        setupResetPasswordButton()
        setupDescriptionLabel()
        setupLogoImageView()
        
    }
    // ------------------------------------------ //
    // -------------- UI Objects ---------------- //
    // ------------------------------------------ //
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let resetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Reset password", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        return button
    }()
    let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.barTintColor = UIColor(r: 80, g: 101, b: 161)
        let navigationItem = UINavigationItem(title: "")
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelAction))
        cancelItem.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = cancelItem
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Please enter the email address associated with your account to receive a link to reset your password."
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    // ------------------------------------------------------- //
    // ---------------- Seting up UI Objects ----------------- //
    // ------------------------------------------------------- //
    func setupLogoImageView() {
        // Need x, y, width, height constraint
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 50).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 255).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 255).isActive = true
    }
    func setupDescriptionLabel() {
        // Need x, y, width, height constraint
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 50).isActive = true
        descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    func setupNavigationBar() {
        // Need x, y, width, height constraint
        navigationBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navigationBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    func setupEmailTextField() {
        // Need x, y, width, height constraint
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -48).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }
    func setupResetPasswordButton() {
        // Need x, y, width, height constraint
        resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetPasswordButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 50).isActive = true
        resetPasswordButton.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        resetPasswordButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    // ----------------------------------------------------- //
    // ---------------------- Handlers --------------------- //
    // ----------------------------------------------------- //
    @objc func cancelAction(){
        //print("Back Button Clicked")
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleResetPassword() {
        guard let email = emailTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if(error != nil){
                print(error!)
                return
            }
            print("Email sent")
            // Email sent
        }
    }
}
