//
//  DescriptionView.swift
//  Memento
//
//  Created by Matthew Thomas on 11/16/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit

class DescriptionView: UIViewController, UITextFieldDelegate {

    var momentToEdit : Moment
    
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var location: UITextField!
    
   
    @IBAction func saveDescription(_ sender: Any) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.date.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var MomentsPage = segue.destination as! AddMemoryViewController
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterset = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterset)
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
