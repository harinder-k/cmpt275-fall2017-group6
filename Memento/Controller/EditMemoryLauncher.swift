//
//  EditStoryLauncher.swift
//  Memento
//
//  Created by fatemeh darbehani on 2017-11-11.
//  Copyright © 2017 memTech. All rights reserved.
//

import UIKit

struct SettingEditMemorryPage {
    var labelName : String
    var iconName : String
}
class EditMemoryLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    let cellId = "cellId"
    let settingArray : [SettingEditMemorryPage] = [SettingEditMemorryPage(labelName: "Add info", iconName: "add_icon"), SettingEditMemorryPage(labelName: "Remove", iconName: "remove_icon")]
    var memoryViewController: MemoryViewController?
    // ------------------------------------------------------------ //
    // ----------------------- UI Objects ------------------------- //
    // ------------------------------------------------------------ //
    let blackView = UIView()
    
    let editMemoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    // ------------------------------------------------------- //
    // ---------------- Seting up UI Objects ----------------- //
    // ------------------------------------------------------- //
    func setupEditMemoryCollectionView() {
        editMemoryCollectionView.dataSource = self
        editMemoryCollectionView.delegate = self
        editMemoryCollectionView.register(EditMemoryCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func handleEditMemory() {
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            //Gesture recognizer to dismis the view
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditMemoryDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(editMemoryCollectionView)
            
            blackView.frame = window.frame
            let height: CGFloat = window.frame.height/4
            let width: CGFloat = window.frame.width
            let y: CGFloat = window.frame.height - height
            editMemoryCollectionView.frame = CGRect.init(x: 0, y: window.frame.height, width: width, height: height)
            //Animating the black view
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.editMemoryCollectionView.frame = CGRect.init(x: 0, y: y, width: width, height: height)
            }, completion: nil)
        }
    }
    // ----------------------------------------------------- //
    // ---------------------- Handlers --------------------- //
    // ----------------------------------------------------- //
    @objc func handleEditMemoryDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                let height: CGFloat = self.editMemoryCollectionView.frame.height
                let width: CGFloat = self.editMemoryCollectionView.frame.width
                let y: CGFloat = window.frame.height
                self.editMemoryCollectionView.frame = CGRect.init(x: 0, y: y, width: width, height: height)
            }
        }
    }
    // ------------------------------------------------------------------- //
    // ---------------- Collection View Delegate Functions --------------- //
    // ------------------------------------------------------------------- //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = editMemoryCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EditMemoryCell
        let setting = settingArray[indexPath.item]
        cell.setting = setting
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = editMemoryCollectionView.frame.width
        let itemHeight = editMemoryCollectionView.frame.height/2
        return CGSize.init(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            print("add info")
            handleEditMemoryDismiss()
            self.memoryViewController?.showControllerForAddInfo()
        }
        if indexPath.item == 1 {
            print("Remove")
        }
        //handleEditMemoryDismiss()
    }
    // ------------------------------------------------------------------- //
    override init(){
        super.init()
        setupEditMemoryCollectionView()
    }
}
