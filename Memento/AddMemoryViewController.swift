//
//  MemoryViewController.swift
//  test
//
//  Created by Matthew Thomas on 11/5/17.
//  Copyright © 2017 Matthew Thomas. All rights reserved.
//

import UIKit

class AddMemoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    struct Memory{
        
        var memDate : String
        var memLoc : String
        var memImage : UIImage
    }
    
    var memArray: [Memory] = []
    //var MemList = Memory()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var numCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memArray.append(Memory(memDate: "Date", memLoc: "Location", memImage: UIImage(named: "plus")!))
        
        collectionView.dataSource = self
        collectionView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memArray.count
        //MemList.Moments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memCell", for: indexPath) as! MemoriesCollectionViewCell
        print(indexPath.description)
        cell.date.text = memArray[indexPath.item].memDate
        cell.location.text = memArray[indexPath.item].memLoc
        cell.image.image = memArray[indexPath.item].memImage
        
        /*cell.date.text = MemList.Moments[indexPath.item].memDate
         cell.location.text = MemList.Moments[indexPath.item].memLoc
         cell.image.image = MemList.Moments[indexPath.item].memImage
         */
        
        cell.button.tag = indexPath.item
        if (cell.button.tag + 1 == memArray.count){
            
            cell.button.setTitle("Add Image", for: .normal)
            cell.button.removeTarget(nil, action:nil, for: .allEvents)
            cell.button.addTarget(self, action: #selector(importImage), for: .touchUpInside)
        }
        else{
            cell.button.removeTarget(nil, action:nil, for: .allEvents)
            cell.button.setTitle("Delete memory", for: .normal)
            cell.button.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc func deleteImage(sender: UIButton){
        numCell = numCell - 1
        memArray.remove(at: sender.tag)
        // var indexPathRem = IndexPath(item: sender.tag, section: 0)
        // collectionView.deleteItems(at: [indexPathRem])
        collectionView.reloadData()
        
    }
    
    @objc func importImage(sender: UIButton){
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
        memArray.append(Memory(memDate: "Date", memLoc: "Location", memImage: UIImage(named: "plus")!))
        //var tempMom = Moment(initLoc: "Location", initDate: [0, 0, 0], initPic: UIImage(named: "plus")!, index: numCell)
        //MemList.Moments.append(tempMom)
        memArray[numCell].memImage = selectedImage
        //MemList.Moments[numCell].setImage(image: selectedImage)
        numCell = numCell + 1
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
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

