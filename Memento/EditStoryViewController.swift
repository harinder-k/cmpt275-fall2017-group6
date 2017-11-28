//
//  EditStoryViewController.swift
//  Memento
//
//  Created by hkhakh on 10/30/17.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit
import os.log

class EditStoryViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var timeLineView: UICollectionView!
    let reuseIdentifier = "cell"
    @IBOutlet weak var StoryTitleTextField: UITextField!
    var memoriesArray : [Memory] = []
    
    //for saving stories
    var stories = [Story]()
    
    var completionHandler:((Story) -> Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLineView.register(StoryCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        timeLineView.backgroundColor = UIColor(r: 230, g: 235, b: 240) //E6EBF0
        timeLineView.layer.cornerRadius = 10
        timeLineView.layer.masksToBounds = true
        //timeLineView.translatesAutoresizingMaskIntoConstraints = false
    }
    //Update collectionView + Memory array inside this function
    @IBAction func addMemoryButtonPressed(_ sender: Any) {
        // Need this to get memory back from MemoryViewController
        let memoryViewController = storyboard?.instantiateViewController(withIdentifier: "MemoryViewController") as! MemoryViewController
        
        memoryViewController.completionHandler = { newMemory in
            
            print("name = \(newMemory.name)")
            print("photos = \(newMemory.photos.count)")
            if newMemory.photos.count > 0 {
                self.memoriesArray.append(newMemory)
                self.timeLineView.reloadData()
            }
            return self.memoriesArray.count
        }
        navigationController?.pushViewController(memoryViewController, animated: true)
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard var storyTitle = StoryTitleTextField.text else {
            print("Title is not valid")
            return
        }
        if storyTitle == "" {
            storyTitle = "Story"
        }
        if let newStory = Story(title: storyTitle, memories: memoriesArray){
            let result = completionHandler?(newStory)
            print("completionHandler returns... \(result ?? 0)")
        }
        // 3: Go back to previous view
        _ = navigationController?.popViewController(animated: true)
    }
    
    // ------------------------------------------------------------------- //
    // ---------------- Collection View Delegate Functions --------------- //
    // ------------------------------------------------------------------- //
    //Requried fuction for a UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = timeLineView.frame.width - 32
        let itemHeight = timeLineView.frame.height/4 - 10
        return CGSize.init(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let storyCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! StoryCell
        print("CellView")
        if memoriesArray.count > indexPath.item  {
            storyCell.image = memoriesArray[indexPath.item].photos[0].image
            storyCell.text = memoriesArray[indexPath.item].name
        }
        
        return storyCell
    }
    
    //Requried fuction for a UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //nothing has been done yet
        return memoriesArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    //For debugging
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    //Method for edditing the story object
    
    
    //MARK: Private Methods
    private func saveStories() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(stories, toFile: Story.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Stories successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Stories...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadStories() -> [Story]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Story.ArchiveURL.path) as? [Story]
    }    
}

//Story Cell Class
class StoryCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var image: UIImage? {
        didSet {
            if let newImage = image {
                thumbnailImageView.image = newImage
            }
        }
    }
    var text: String? {
        didSet {
            if let newText = text {
                memoryTitle.text = newText
            }
        }
    }
    
    let thumbnailImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "add_icon")
        /*
         images source : https://www.iconfinder.com/icons/213524/add_image_new_photo_photograph_photography_picture_icon
         */
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let memoryTitle : UITextView = {
        let text = UITextView()
        text.text = "None"
        text.font =  .boldSystemFont(ofSize: 20)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    func setupViews() {
        self.addSubview(thumbnailImageView)
        self.addSubview(memoryTitle)
        self.backgroundColor = UIColor.white
        let hConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[v0(150)]-50-[v1]-32-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": thumbnailImageView, "v1": memoryTitle])
        let v0Constraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[v0(100)]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": thumbnailImageView])
        let v1Constraint = NSLayoutConstraint.constraints(withVisualFormat: "V:|-32-[v0]-32-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": memoryTitle])
        
        NSLayoutConstraint.activate(hConstraint)
        NSLayoutConstraint.activate(v0Constraint)
        NSLayoutConstraint.activate(v1Constraint)
        
        addConstraint(NSLayoutConstraint(item: thumbnailImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: memoryTitle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

    }
}
