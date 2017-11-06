//
//  StoriesViewControler.swift
//  Memento
//
//  Created by hkhakh on 10/27/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StoriesViewController:UIViewController {
class StoriesViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var memoriesTable: UITableView!
    //holds the table data
    var data:[String] = []
    var selectedRow:Int = -1
    var newRowText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var ref: DatabaseReference!
        //ref = Database.database().reference(fromURL: "https://memento-da996.firebaseio.com/")
        //ref.updateChildValues(["test" : 123])
        
        // Logout button:
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        checkIfUserIsLoggedIn()
     
    }
    @objc func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        else {
            let uid = Auth.auth().currentUser?.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                print(snapshot)
            }, withCancel: nil)
        }
    }
    @objc func handleLogout(){
        do{
            try Auth.auth().signOut()
        }catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    //allows the StoriesViewControler to save the MemsViewControllers data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //if nothing selected
        if selectedRow == -1 {
            return
        }
        //if somthing selected
        data[selectedRow] = newRowText
        //if data is empty
        if newRowText == "" {
            data.remove(at: selectedRow)
        }
        //save the data
        memoriesTable.reloadData()
        save()
    }
    
    //Handels editing list, activated when leftBarButtonItem is clicked
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        memoriesTable.setEditing(editing, animated: animated)
    }
    
    //Calls when delete button is hit
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)//remove data from data string
        memoriesTable.deleteRows(at: [indexPath], with: .fade)
        save()
    }
    
    //method for when the plush button is pressed
    @objc func addMem() {
        //If table is in delete mode dont left thing get added
        if (memoriesTable.isEditing) {
            return
        }
        let name:String = "Type your memory here..."
        data.insert(name, at: 0)
        let indexPath:IndexPath = IndexPath(row:0, section: 0)
        memoriesTable.insertRows(at: [indexPath], with: .automatic)
        //garthers information for the prepareSegua fuction
        memoriesTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    //to save data to memory
    func save() {
        UserDefaults.standard.set(data, forKey: "mems")
        UserDefaults.standard.synchronize()
    }
    
    //to load data from memory
    func load() {
        //if its there and can be casted to a string array
        if let loadedData = UserDefaults.standard.value(forKey: "mems") as? [String] {
            data = loadedData
            //calls needed methods again
            memoriesTable.reloadData()
        }
    }
    
    //fuctionality for table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    //fuctionality for table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    //This is a delagete, it handels interactivity (selecting a row in table view)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(data[indexPath.row])")
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    //Allows the StoriesViewControler to send data to the MemsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let memsView:MemsViewController = segue.destination as! MemsViewController
        selectedRow = memoriesTable.indexPathForSelectedRow!.row
        memsView.masterView = self
        memsView.setText(t: data[selectedRow])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
