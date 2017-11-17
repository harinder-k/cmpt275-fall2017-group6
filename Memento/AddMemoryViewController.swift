//
//  MemoryViewController.swift
//  test
//
//  Created by Matthew Thomas on 11/5/17.
//  Copyright © 2017 Matthew Thomas. All rights reserved.
//

import UIKit

class AddMemoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var MemList = Memory()
    var tempMom = Moment()
    var selectedCell = -1
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var delete: UIBarButtonItem!
    var lastpress = false
    
    var numCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*memArray.append(Memory(memDate: "Date", memLoc: "Location", memImage: UIImage(named: "plus")!))
        */
        
     
        self.delete?.isEnabled = false
        self.tempMom.setPic(pic: UIImage(named: "plus")!)
        self.MemList.addMoment(newMom: tempMom)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/3, height: (self.collectionView.frame.size.height/3))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return memArray.count
       return self.MemList.getSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memCell", for: indexPath) as! MemoriesCollectionViewCell
        print(indexPath.description)
        
        cell.image.image = self.MemList.Moments[indexPath.item].getPic()
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if(indexPath.item + 1 == self.MemList.getSize()){
            self.importImage()
        }
        else{
            self.delete?.isEnabled = true
            selectedCell = indexPath.item
            cell?.layer.borderColor = UIColor.black.cgColor
            cell?.layer.borderWidth = 5
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 2
    }
    
    
    
    @IBAction func deleteImages(_ sender: Any) {
       performSegue(withIdentifier: "next", sender: self)
    }
    
    func importImage(){
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Expected a dictionary containing an image but was provided the following: \(info)")
        }
        self.MemList.setLatestMoment(pic: selectedImage)
        var newMoment = Moment()
        newMoment.setPic(pic: UIImage(named: "plus")!)
        self.MemList.addMoment(newMom: newMoment)
        
        //memArray.append(Memory(memDate: "Date", memLoc: "Location", memImage: UIImage(named: "plus")!))
        //memArray[numCell].memImage = selectedImage
        //numCell = numCell + 1
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var editPage = segue.destination as! DescriptionView
        editPage.momentToEdit = self.MemList.Moments[selectedCell]
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

