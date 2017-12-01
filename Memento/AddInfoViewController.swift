//
//  AddInfoViewController.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-13.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit

class AddInfoViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var peopleNames : [String] = []
    var place : String = ""
    // Closure property to pass data to MemoryViewController
    var completionHandler:((_ peopleNames : [String], _ place: String) -> Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backToMemoryButton)
        view.addSubview(peopleTextField)
        view.addSubview(placeTextField)
        view.addSubview(peopleTopSeperatorView)
        view.addSubview(peopleBottomSeperatorView)
        view.addSubview(placeTopSeperatorView)
        view.addSubview(placeBottomSeperatorView)
        view.addSubview(namesTableView)
        view.addSubview(addNameButton)
        setupBackToMemoryButton()
        setupNamesTableView()
        setupPlaceTextField()
        setupPeopleTextField()
        setupPlaceTopSeperatorView()
        setupPlaceBottomSeperatorView()
        setupPeopleTopSeperatorView()
        setupPeopleBottomSeperatorView()
        setupAddNameButton()
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        peopleNames = []
        place = ""
    }
    // ------------------------------------------------------------------- //
    // ----------------- Table view Delegate Functions ------------------- //
    // ------------------------------------------------------------------- //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameID", for: indexPath) as! nameCell
        print("go in this!!!!")
        if peopleNames.count > indexPath.item {
            print("adding...\(peopleNames[indexPath.item])")
            cell.name = peopleNames[indexPath.item]
        }
        return cell
    }
    
    
    // ------------------------------------------------------------ //
    // ----------------------- UI Objects ------------------------- //
    // ------------------------------------------------------------ //
    //Add name button
    let addNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161) //5065A1
        button.setTitle("Add Name", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleAddNameButton), for: .touchUpInside)
        
        return button
    }()
    //Back to MemoryViewController
    let backToMemoryButton: UIButton = {
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
    //Names table view
    let namesTableView: UITableView = {
        let view = UITableView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100), style: UITableViewStyle(rawValue: 0)!)
        view.register(nameCell.self, forCellReuseIdentifier: "nameID")
        view.backgroundColor = UIColor(r: 230, g: 235, b: 240) //E6EBF0
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    //Place indecator lines
    let placeTopSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //Place indecator lines
    let placeBottomSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //people indecator lines
    let peopleTopSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    //people indecator lines
    let peopleBottomSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // ------------------------------------------------------- //
    // ---------------- Seting up UI Objects ----------------- //
    // ------------------------------------------------------- //
    func setupAddNameButton() {
        // Need x, y, width, height constraint
        addNameButton.topAnchor.constraint(equalTo: backToMemoryButton.bottomAnchor, constant: 20).isActive = true
        addNameButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        addNameButton.leftAnchor.constraint(equalTo: backToMemoryButton.leftAnchor, constant: 0).isActive = true
        //addNameButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        addNameButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupBackToMemoryButton() {
        // Need x, y, width, height constraint
        backToMemoryButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        backToMemoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        //backToMemoryButton.leftAnchor.constraint(equalTo: placeTextField.rightAnchor, constant: 20).isActive = true
        backToMemoryButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        backToMemoryButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupNamesTableView() {
        //namesTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        namesTableView.topAnchor.constraint(equalTo: peopleTextField.bottomAnchor, constant: 20).isActive = true
        namesTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        namesTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        namesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        
        namesTableView.dataSource = self
        namesTableView.delegate = self
    }
    func setupPlaceTextField() {
        placeTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        placeTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        //placeTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        placeTextField.rightAnchor.constraint(equalTo: backToMemoryButton.leftAnchor, constant: -20)
        placeTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupPeopleTextField() {
        peopleTextField.topAnchor.constraint(equalTo: placeTextField.bottomAnchor, constant: 20).isActive = true
        peopleTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        peopleTextField.rightAnchor.constraint(equalTo: backToMemoryButton.leftAnchor, constant: -20)
        //peopleTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        peopleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupPlaceTopSeperatorView(){
        placeTopSeperatorView.leftAnchor.constraint(equalTo: placeTextField.leftAnchor).isActive = true
        placeTopSeperatorView.topAnchor.constraint(equalTo: placeTextField.topAnchor).isActive = true
        placeTopSeperatorView.rightAnchor.constraint(equalTo: backToMemoryButton.leftAnchor, constant: -20).isActive = true
        placeTopSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupPlaceBottomSeperatorView(){
        placeBottomSeperatorView.leftAnchor.constraint(equalTo: placeTextField.leftAnchor).isActive = true
        placeBottomSeperatorView.bottomAnchor.constraint(equalTo: placeTextField.bottomAnchor).isActive = true
        placeBottomSeperatorView.rightAnchor.constraint(equalTo: backToMemoryButton.leftAnchor, constant: -20).isActive = true
        placeBottomSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupPeopleTopSeperatorView(){
        peopleTopSeperatorView.leftAnchor.constraint(equalTo: peopleTextField.leftAnchor).isActive = true
        peopleTopSeperatorView.topAnchor.constraint(equalTo: peopleTextField.topAnchor).isActive = true
        peopleTopSeperatorView.rightAnchor.constraint(equalTo: backToMemoryButton.leftAnchor, constant: -20).isActive = true
        peopleTopSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupPeopleBottomSeperatorView(){
        peopleBottomSeperatorView.leftAnchor.constraint(equalTo: peopleTextField.leftAnchor).isActive = true
        peopleBottomSeperatorView.bottomAnchor.constraint(equalTo: peopleTextField.bottomAnchor).isActive = true
        peopleBottomSeperatorView.rightAnchor.constraint(equalTo: backToMemoryButton.leftAnchor, constant: -20).isActive = true
        peopleBottomSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    // ----------------------------------------------------- //
    // ---------------------- Handlers --------------------- //
    // ----------------------------------------------------- //
    @objc func handleBackToMemoryButton() {
        // 1: Call the closure variable on memory variable
        let result = completionHandler?(self.peopleNames, self.place)
        print("completionHandler returns... \(result ?? 0)")
        // 3: Go back to previous view
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleAddNameButton() {
        let inputName = peopleTextField.text
        peopleTextField.text = ""
        print("Add Name")
        if !(inputName!.isEmpty) {
            peopleNames.append(inputName!)
            print(peopleNames)
            namesTableView.reloadData()
        }
            
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

//Name cell for name tabe view
class nameCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "nameID")
        setupViews()
    }

    //required fuction... dont know what it does eather
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Hold a string and set the text vew to that value
    var name: String? {
        didSet {
            if let newText = name {
                tableViewText.text = newText
            }
        }
    }
    //add the Text view to the table
    let tableViewText: UILabel = {
        let text = UILabel()
        text.font =  .boldSystemFont(ofSize: 20)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    //chose what the veiw looks like
    func setupViews() {
        self.addSubview(tableViewText)
        self.backgroundColor = UIColor.white
        let hConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tableViewText])
        let vConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tableViewText])
        
        NSLayoutConstraint.activate(hConstraint)
        NSLayoutConstraint.activate(vConstraint)
        
    }
    

}

