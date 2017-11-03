//
//  LoginController.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-10-30.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit
import Firebase
class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        view.addSubview(logoImageView)
        view.addSubview(loginRegisterSegmentedControl)
        //view.addSubview(dateOfBirthPciker)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.isHidden = true
        
        setupLogoImageView()
        setupLoginRegisterSegmentedControl()
        //setupDateOfBirthPicker()
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupForgotPassword()
        
    }
    // ------------------------------------------ //
    // -------------- UI Objects ---------------- //
    // ------------------------------------------ //
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email address"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let passwordSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confrim password"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let confirmPasswordSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let dateOfBirthTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Date of birth"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        /*
         image source: http://www.cambridge.org/elt/blog/profile-page/
         */
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = UIColor(r: 80, g: 101, b: 161)
        let font = UIFont.boldSystemFont(ofSize: 20)
        sc.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterControlToggle), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let dateOfBirthPciker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePickerMode.date
        dp.backgroundColor = UIColor.white
        dp.sizeToFit()
        dp.layer.cornerRadius = 5
        dp.layer.masksToBounds = true
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(UIColor(r: 80, g: 101, b: 161), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    // ------------------------------------------------------- //
    // ---------------- Seting up UI Objects ----------------- //
    // ------------------------------------------------------- //
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var confirmPasswordTextFieldHeightAnchor: NSLayoutConstraint?
    var dateOfBirthTextFieldHeightAnchor: NSLayoutConstraint?

    func setupForgotPassword() {
        // Need x, y, width, height constraint
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 50).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -48).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupLoginRegisterSegmentedControl() {
        // Need x, y, width, height constraint
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -48).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setupLogoImageView() {
        // Need x, y, width, height constraint
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: loginRegisterSegmentedControl.bottomAnchor, constant: 50).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 255).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 255).isActive = true
    }

    func setupInputsContainerView() {
        // Need x, y, width, height constraint
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -48).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 375)
        inputsContainerViewHeightAnchor?.isActive = true
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeperatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeperatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeperatorView)
        inputsContainerView.addSubview(confirmPasswordTextField)
        inputsContainerView.addSubview(confirmPasswordSeperatorView)
        inputsContainerView.addSubview(dateOfBirthTextField)
        
        
        setupNameTextField()
        setupNameSeperatorView()
        setupEmailTextField()
        setupEmailSeperatorView()
        setupPasswordTextField()
        setupPasswordSeperatorView()
        setupConfirmPasswordTextField()
        setupConfirmPasswordSeperatorView()
        setupDateOfBirthTextField()
        
        
        createDatePickerToolBar()
    }
    func setupLoginRegisterButton() {
        // Need x, y, width, height constraint
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 50).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupNameTextField() {
        // Need x, y, width, height constraint
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 20).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5)
        nameTextFieldHeightAnchor?.isActive = true
    }
    func setupNameSeperatorView(){
        // Need x, y, width, height constraint
        nameSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeperatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupEmailTextField() {
        // Need x, y, width, height constraint
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 20).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeperatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5)
        emailTextFieldHeightAnchor?.isActive = true
    }
    func setupEmailSeperatorView(){
        // Need x, y, width, height constraint
        emailSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeperatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupPasswordTextField() {
        // Need x, y, width, height constraint
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 20).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeperatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    func setupPasswordSeperatorView(){
        // Need x, y, width, height constraint
        passwordSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeperatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupConfirmPasswordTextField() {
        // Need x, y, width, height constraint
        confirmPasswordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 20).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordSeperatorView.bottomAnchor).isActive = true
        confirmPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        confirmPasswordTextFieldHeightAnchor = confirmPasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5)
        confirmPasswordTextFieldHeightAnchor?.isActive = true
    }
    func setupConfirmPasswordSeperatorView(){
        // Need x, y, width, height constraint
        confirmPasswordSeperatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        confirmPasswordSeperatorView.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor).isActive = true
        confirmPasswordSeperatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        confirmPasswordSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupDateOfBirthTextField() {
        // Need x, y, width, height constraint
        dateOfBirthTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 20).isActive = true
        dateOfBirthTextField.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor).isActive = true
        dateOfBirthTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        dateOfBirthTextFieldHeightAnchor = dateOfBirthTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5)
        dateOfBirthTextFieldHeightAnchor?.isActive = true
    }
    // ----------------------------------------------------- //
    // ---------------------- Handlers --------------------- //
    // ----------------------------------------------------- //
    func createDatePickerToolBar() {
        //toolbar
        let tb = UIToolbar()
        tb.sizeToFit()
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        doneButton.tintColor = UIColor.black
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelPressed))
        cancelButton.tintColor = UIColor.black
        
        tb.setItems([doneButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),cancelButton], animated: true)
        tb.translatesAutoresizingMaskIntoConstraints = false
        
        dateOfBirthTextField.inputAccessoryView = tb
        dateOfBirthTextField.inputView = dateOfBirthPciker
    }
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        dateOfBirthTextField.text = dateFormatter.string(from: dateOfBirthPciker.date)
        self.view.endEditing(true)
    }
    @objc func cancelPressed(){
        self.view.endEditing(true)
    }
 
    @objc func handleLoginRegisterControlToggle() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        
        loginRegisterButton.setTitle(title, for: .normal)
        
        // Change height of the input container view
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 150 : 375
        // Height of nameTextField and confirmPasswordTextField
        let zeroHeightMultiplier:CGFloat = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/5
        let halfHeightMultiplier:CGFloat = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/5
        //Heights of email and password fields become 1/2 when login is selected
        // Change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: halfHeightMultiplier)
        emailTextFieldHeightAnchor?.isActive = true
        // Change height of passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: halfHeightMultiplier)
        passwordTextFieldHeightAnchor?.isActive = true
        // Heights of name field and confirm password and date of birth field become zero when login is selected
        // Change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: zeroHeightMultiplier)
        nameTextFieldHeightAnchor?.isActive = true
        // Change height of confirmPasswordTextField
        confirmPasswordTextFieldHeightAnchor?.isActive = false
        confirmPasswordTextFieldHeightAnchor = confirmPasswordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: zeroHeightMultiplier)
        confirmPasswordTextFieldHeightAnchor?.isActive = true
        // Change height of dateOfBirthTextField
        dateOfBirthTextFieldHeightAnchor?.isActive = false
        dateOfBirthTextFieldHeightAnchor = dateOfBirthTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: zeroHeightMultiplier)
        dateOfBirthTextFieldHeightAnchor?.isActive = true
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            forgotPasswordButton.isHidden = false
        }
        else{
            forgotPasswordButton.isHidden = true
        }
        
    }
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }
        else {
            handleRegister()
        }
    }
    @objc func handleLogin() {
        guard let email = emailTextField.text else {
            print("Form is not valid")
            return
        }
        guard let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            print("Login successful")
            // Successfully logged in user
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func handleForgotPassword(){
        let resetPasswordController = ResetPasswordController()
        present(resetPasswordController, animated: true, completion: nil)
    }
    @objc func handleRegister() {
        guard let email = emailTextField.text else {
            print("Form is not valid")
            return
        }
        guard let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        guard let confirmPassword = confirmPasswordTextField.text else {
            print("Form is not valid")
            return
        }
        guard let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        guard let dateOfBirth = dateOfBirthTextField.text else {
            print("Form is not valid")
            return
        }
        if password != confirmPassword {
            print("Password and confirm password dont match")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
            //Successfully created user
            print("Created user!")
            guard let uid = user?.uid else{
                return
            }
            // Reference to database
            var ref: DatabaseReference!
            ref = Database.database().reference(fromURL: "https://memento-da996.firebaseio.com/")
            // Reference to users in database seperated by their uid
            let usersRef = ref.child("users").child(uid)
            // Values to save for this user
            let values = ["name": name, "email": email, "dateOfBirth": dateOfBirth]
            // Update users in database
            usersRef.updateChildValues(values) { (database_update_error, ref) in
                if database_update_error != nil {
                    print(database_update_error!)
                    return
                }
                print("Saved user in database")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIColor {
    convenience init (r: CGFloat, g: CGFloat, b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
