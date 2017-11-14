//
//  MemoryViewController.swift
//  test
//
//  Created by Matthew Thomas on 11/5/17.
//  Copyright © 2017 Matthew Thomas. All rights reserved.
//

import UIKit
import Photos
import NohanaImagePicker


class MemoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, NohanaImagePickerControllerDelegate{
    
    // ------------------------------------------------------------------- //
    // ------------------------ Class Variables -------------------------- //
    // ------------------------------------------------------------------- //
    var memory = Memory(name: "Default")
    var memoryImages: [MemoryImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(addImageButton)
        view.addSubview(memoryCollectionView)
        setupAddImageButton()
        setupMemoryCollectionView()
        
        //memoryImages.append(Memory(memDate: "Date", memLoc: "Location", memImage: UIImage(named: "plus")!))
        
        // Do any additional setup after loading the view.
    }
    // ------------------------------------------------------------------- //
    // ----------------- Image Picker Delegate Functions ----------------- //
    // ------------------------------------------------------------------- //
    
    
    func nohanaImagePickerDidCancel(_ picker: NohanaImagePickerController) {
        print("Canceled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func nohanaImagePicker(_ picker: NohanaImagePickerController, didFinishPickingPhotoKitAssets pickedAssts: [PHAsset]) {
        print("Completed\n\tpickedAssets = \(pickedAssts)")
        picker.dismiss(animated: true, completion: nil)
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestOptions.isSynchronous = true
    
        var selectedImage = UIImage()
        for asset in pickedAssts
        {
            if (asset.mediaType == PHAssetMediaType.image)
            {
                
                PHImageManager.default().requestImage(for: asset , targetSize: PHImageManagerMaximumSize, contentMode: .default, options: requestOptions, resultHandler: { (pickedImage, info) in
                    
                    selectedImage = pickedImage!
                    self.memoryImages.append(MemoryImage(image: selectedImage))
                })
            }
        }
        print("Number of selected images:\(self.memoryImages.count)")
        memoryCollectionView.reloadData()
    }
    
    // ------------------------------------------------------------------- //
    // ---------------- Collection View Delegate Functions --------------- //
    // ------------------------------------------------------------------- //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = memoryCollectionView.frame.width/3.1
        let itemHeight = memoryCollectionView.frame.height/3.1
        return CGSize.init(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memoryImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MemoryCell
        //print("Index Path: \(indexPath.item)")
        //cell.date.text = memArray[indexPath.item].memDate
        //cell.location.text = memArray[indexPath.item].memLoc
        //cell.image.image = memArray[indexPath.item].memImage
        
        /*cell.date.text = MemList.Moments[indexPath.item].memDate
         cell.location.text = MemList.Moments[indexPath.item].memLoc
         cell.image.image = MemList.Moments[indexPath.item].memImage
         */
        //cell.backgroundColor = UIColor.black
        //cell.button.tag = indexPath.item
        /*if (cell.button.tag + 1 == memArray.count){
            
            cell.button.setTitle("Add Image", for: .normal)
            cell.button.removeTarget(nil, action:nil, for: .allEvents)
            cell.button.addTarget(self, action: #selector(importImage), for: .touchUpInside)
        }
        else{
            cell.button.removeTarget(nil, action:nil, for: .allEvents)
            cell.button.setTitle("Delete memory", for: .normal)
            cell.button.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        }*/
        if memoryImages.count > indexPath.item  {
            cell.thumbnailImageView.image = memoryImages[indexPath.item].image
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // If newPhoto is clicked
        if memoryImages.count == indexPath.item {
            handleNewImage()
        }
        // If User's photo is clicked
        else{
            handleEditMemoryImage()
        }
    }
    // ------------------------------------------------------------ //
    // ----------------------- UI Objects ------------------------- //
    // ------------------------------------------------------------ //
    let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161) //5065A1
        button.setTitle("Photo", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleAddImageButton), for: .touchUpInside)
        return button
    }()
    
    let memoryCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100) , collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(MemoryCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.backgroundColor = UIColor(r: 230, g: 235, b: 240) //E6EBF0
        collectionView.layer.cornerRadius = 10
        collectionView.layer.masksToBounds = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    // ------------------------------------------------------- //
    // ---------------- Seting up UI Objects ----------------- //
    // ------------------------------------------------------- //
    func setupImageView() {
        // Need x, y, width, height constraint
        myImageView.bottomAnchor.constraint(equalTo: addImageButton.topAnchor).isActive = true
        myImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    func setupAddImageButton() {
        // Need x, y, width, height constraint
        addImageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        addImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addImageButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        addImageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupMemoryCollectionView() {
        memoryCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoryCollectionView.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 20).isActive = true
        memoryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        memoryCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        memoryCollectionView.dataSource = self
        memoryCollectionView.delegate = self
    }
    
    // ----------------------------------------------------- //
    // ---------------------- Handlers --------------------- //
    // ----------------------------------------------------- //
    @objc func handleAddImageButton() {
        let picker = NohanaImagePickerController()
        picker.delegate = self
        // Hide toolbar
        picker.toolbarHidden = true
        // Set the cell size
        picker.numberOfColumnsInPortrait = 3
        picker.numberOfColumnsInLandscape = 4
        
        present(picker, animated: true, completion: nil)
    }
    func handleNewImage() {
        let picker = NohanaImagePickerController()
        picker.delegate = self
        // Hide toolbar
        picker.toolbarHidden = true
        // Set the cell size
        picker.numberOfColumnsInPortrait = 3
        picker.numberOfColumnsInLandscape = 4
        
        present(picker, animated: true, completion: nil)
    }
    lazy var editMemoryLauncher: EditMemoryLauncher = {
        let editMemoryLauncher = EditMemoryLauncher()
        editMemoryLauncher.memoryViewController = self
        return editMemoryLauncher
    }()
    func handleEditMemoryImage() {
        
        editMemoryLauncher.handleEditMemory()
    }
    private lazy var addInfo: AddInfoViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // Instantiate View Controller
        var vc = storyboard.instantiateViewController(withIdentifier: "addInfoView") as! AddInfoViewController
        // Add View Controller as Child View Controller
        return vc
    }()

    func showControllerForAddInfo() {
        navigationController?.pushViewController(addInfo, animated: true)
        }
    // ----------------------------------------------------- //
    /*struct Memory{
     
     var memDate : String
     var memLoc : String
     var memImage : UIImage
     }*/
    
    
    //var MemList = Memory()
    
    
   // @IBOutlet weak var collectionView: UICollectionView!
    
    //var numCell = 0
    

    /*
    @objc func deleteImage(sender: UIButton){
        numCell = numCell - 1
        //memArray.remove(at: sender.tag)
        // var indexPathRem = IndexPath(item: sender.tag, section: 0)
        // collectionView.deleteItems(at: [indexPathRem])
        collectionView.reloadData()
        
    }
    
    @objc func importImage(sender: UIButton){
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    */
}




