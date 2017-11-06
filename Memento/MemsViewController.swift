//
//  MemsViewController.swift
//  Memento
//
//  Created by twoinosk on 11/5/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit

class MemsViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    var text:String = ""
    
    //rereance for StoriesViewControler
    var masterView:StoriesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textView.text = text
        //causes the keyboard to pop up in the view
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //kills the text in the text field when the back button is pressed
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        masterView.newRowText = textView.text
    }
    
    //Sets the input text from the master
    func setText(t:String){
        text = t
        if isViewLoaded {
            textView.text = t
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
