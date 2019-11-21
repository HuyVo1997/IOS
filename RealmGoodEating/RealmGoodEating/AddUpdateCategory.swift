//
//  AddUpdateCategory.swift
//  RealmGoodEating
//
//  Created by Huy Vo on 11/21/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit
import RealmSwift

class AddUpdateCategory: UIViewController {

    @IBOutlet weak var categoryTitle: UITextField!
    
    @IBOutlet weak var categoryName: UITextField!
    
    let realm = try! Realm()
    
    var edit : String!
    
    var category : CategoryFood!
    
    @IBOutlet weak var btnAddUpdate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(edit == "Update"){
            btnAddUpdate.setTitle("Update Category", for: .normal)
            categoryTitle.text = category.title
            categoryName.text = category.image
        }
        else{
            btnAddUpdate.setTitle("Add Category", for: .normal)
        }
    }
    
    func create<T:Object>(_ object : T){
        do {
            try realm.write{
                realm.add(object)
            }
            
        }
        catch {
            print (error)
        }
    }
    
    func update<T: Object> (_ object : T,with dictionary: [String: Any?]){
        do{
            try realm.write {
                for (key,value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        }
        catch {
            print (error)
        }
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddUpdate(_ sender: UIButton) {
        if(edit == "Update"){
            let dict : [String: Any?] = ["title": categoryTitle.text,
                                         "image" : categoryName.text]
            update(category,with: dict)
            dismiss(animated: true, completion: nil)
        }
        else {
            let newCategory = CategoryFood(title: categoryTitle.text, image: categoryName.text)
            create(newCategory)
            dismiss(animated: true, completion: nil)
        }
    }
    
}

//extension AddUpdateCategory : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
//
//    func handleSelectImage(){
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        present(picker,animated: true,completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        var selectedImageFromPicker: UIImage?
//        if let editedImage = info[.editedImage] as? UIImage{
//            selectedImageFromPicker = editedImage
//        }else if let originalImage = info[.originalImage] as? UIImage{
//            selectedImageFromPicker = originalImage
//        }
//        if let selectedImage = selectedImageFromPicker {
//            categoryImage.image = selectedImage
//        }
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//}
