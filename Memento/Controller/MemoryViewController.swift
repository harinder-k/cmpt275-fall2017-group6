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
    var memoryImages: [MemoryData] = []
    // Closure property to pass data to EditStoryViewController
    // This means the closure has one parameter of type Memory and returns one value of type Int
    var completionHandler:((Memory) -> Int)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(doneButton)
        view.addSubview(memoryCollectionView)
        view.addSubview(memoryTitleTextField)
        view.addSubview(memoryDateTextField)
        view.addSubview(titleTopSeperatorView)
        view.addSubview(titleBottomSeperatorView)
        view.addSubview(dateTopSeperatorView)
        view.addSubview(dateBottomSeperatorView)
        view.addSubview(infoLabel)
        setupDoneButton()
        setupMemoryCollectionView()
        setupMemoryTitleTextField()
        setupMemoryDateTextField()
        setupTitleTopSeperatorView()
        setupTitleBottomSeperatorView()
        setupDateTopSeperatorView()
        setupDateBottomSeperatorView()
        createDatePickerToolBar()
        setupInfoLabel()
        
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
                    self.memoryImages.append(MemoryData(image: selectedImage, place: "", people: [], date: "")!)
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
            showActionSheet(index: indexPath)
        }
    }
    // ------------------------------------------------------------ //
    // ----------------------- UI Objects ------------------------- //
    // ------------------------------------------------------------ //
    let infoLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Click on each image to add Info to it."
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161) //5065A1
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
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
    let memoryTitleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Memory title"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let memoryDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Memory date"
        tf.font = UIFont.boldSystemFont(ofSize: 20)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePickerMode.date
        dp.backgroundColor = UIColor.white
        dp.sizeToFit()
        dp.layer.cornerRadius = 5
        dp.layer.masksToBounds = true
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.subviews[0].subviews[0].subviews[1].isHidden = true
        return dp
    }()
    let titleTopSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let titleBottomSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let dateTopSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let dateBottomSeperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var addInfo: AddInfoViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // Instantiate View Controller
        var vc = storyboard.instantiateViewController(withIdentifier: "addInfoView") as! AddInfoViewController
        // Add View Controller as Child View Controller
        return vc
    }()
    // ------------------------------------------------------- //
    // ---------------- Seting up UI Objects ----------------- //
    // ------------------------------------------------------- //
    
    func setupDoneButton() {
        // Need x, y, width, height constraint
        doneButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100).isActive = true
        doneButton.leftAnchor.constraint(equalTo: doneButton.rightAnchor, constant: -100).isActive = true
        //doneButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupMemoryTitleTextField() {
        memoryTitleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        memoryTitleTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 100).isActive = true
        memoryTitleTextField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        memoryTitleTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupMemoryDateTextField() {
        memoryDateTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        memoryDateTextField.leftAnchor.constraint(equalTo: memoryTitleTextField.rightAnchor, constant: 20).isActive = true
        memoryDateTextField.rightAnchor.constraint(equalTo: doneButton.leftAnchor, constant: -20).isActive = true
        memoryDateTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    func setupTitleTopSeperatorView(){
        titleTopSeperatorView.leftAnchor.constraint(equalTo: memoryTitleTextField.leftAnchor).isActive = true
        titleTopSeperatorView.topAnchor.constraint(equalTo: memoryTitleTextField.topAnchor).isActive = true
        titleTopSeperatorView.rightAnchor.constraint(equalTo: memoryDateTextField.leftAnchor, constant: -20).isActive = true
        titleTopSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupTitleBottomSeperatorView(){
        titleBottomSeperatorView.leftAnchor.constraint(equalTo: memoryTitleTextField.leftAnchor).isActive = true
        titleBottomSeperatorView.bottomAnchor.constraint(equalTo: memoryTitleTextField.bottomAnchor).isActive = true
        titleBottomSeperatorView.rightAnchor.constraint(equalTo: memoryDateTextField.leftAnchor, constant: -20).isActive = true
        titleBottomSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupDateTopSeperatorView(){
        dateTopSeperatorView.leftAnchor.constraint(equalTo: memoryDateTextField.leftAnchor).isActive = true
        dateTopSeperatorView.topAnchor.constraint(equalTo: memoryDateTextField.topAnchor).isActive = true
        dateTopSeperatorView.rightAnchor.constraint(equalTo: memoryDateTextField.rightAnchor).isActive = true
        dateTopSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupDateBottomSeperatorView(){
        dateBottomSeperatorView.leftAnchor.constraint(equalTo: memoryDateTextField.leftAnchor).isActive = true
        dateBottomSeperatorView.bottomAnchor.constraint(equalTo: memoryDateTextField.bottomAnchor).isActive = true
        dateBottomSeperatorView.rightAnchor.constraint(equalTo: memoryDateTextField.rightAnchor).isActive = true
        dateBottomSeperatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    func setupMemoryCollectionView() {
        memoryCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        memoryCollectionView.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 50).isActive = true
        memoryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        memoryCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        memoryCollectionView.dataSource = self
        memoryCollectionView.delegate = self
    }
    func setupInfoLabel() {
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 10).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: memoryCollectionView.topAnchor, constant: -10).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
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
        
        memoryDateTextField.inputAccessoryView = tb
        memoryDateTextField.inputView = datePicker
    }
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        memoryDateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelPressed(){
        self.view.endEditing(true)
    }
    @objc func handleDoneButton() {
        guard var title = memoryTitleTextField.text else {
            print("Title is not valid")
            return
        }
        guard var date = memoryDateTextField.text else {
            print("Date is not valid")
            return
        }
        if title == "" {
            displayMessage(userMessage: "Memory Title not Valid")
            return
        }
        if date == "" {
            displayMessage(userMessage: "Memory Date not Valid")
            return
        }
        print(title)
        // Passing memory to EditStoryViewController
        // 1: Create a memory object from title and memoryImages array
        let newMemory = Memory(name: title, date: date, photos: memoryImages)
        // 2: Call the closure variable on memory variable
        let result = completionHandler?(newMemory!)
        print("completionHandler returns... \(result ?? 0)")
        // 3: Go back to previous view
        _ = navigationController?.popViewController(animated: true)
        
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
    func showControllerForAddInfo(index: IndexPath) {
        addInfo.completionHandler = { peopleArray, place in
            self.memoryImages[index.item].people = peopleArray
            self.memoryImages[index.item].place = place
                return peopleArray.count
        }
        navigationController?.pushViewController(addInfo, animated: true)
    }
    func removeImage(index: IndexPath) {
        memoryImages.remove(at: index.item)
        self.memoryCollectionView.deleteItems(at: [index])
    }
    func showActionSheet(index: IndexPath) {
        // 1 Create an option menu
        let optionMenu = UIAlertController(title: nil, message: "Choose option:", preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        let y_start: CGFloat = self.view.frame.height - 120
        let height: CGFloat = 120
        let width: CGFloat = self.view.frame.width
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 0, y: y_start, width: width, height: height)
        // 2 Create add info action
        let addInfoAction = UIAlertAction(title: "Add info", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.showControllerForAddInfo(index: index)
            print("Go to add info")
        })
        // 3 Create remove photo action
        let removeAction = UIAlertAction(title: "Remove photo", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.removeImage(index: index)
            print("Remove photo")
        })
        
        // 4 Create cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        // 4
        optionMenu.addAction(addInfoAction)
        optionMenu.addAction(removeAction)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    // ----------------------------------------------------- //
    func displayMessage(userMessage: String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Unvalid form", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
                print("Ok button tapped")
                DispatchQueue.main.async {
                    //self.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}




