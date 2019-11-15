//
//  AddCategoryVC.swift
//  GoodEatingFireBase
//
//  Created by Huy Vo on 11/13/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
class AddCategoryVC: UIViewController {

    @IBOutlet weak var categoryTitle: UITextField!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    var categoryVM : CategoryViewModel!
    
    var imagePicker = UIImagePickerController()
    
    var edit : String!
    
    var category: FoodCategory!
    
    @IBOutlet weak var btnAddUpdate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryVM = CategoryViewModel()
        categoryVM.refFoodCategory = Database.database().reference().child("category")
        
        if(edit == "Edit"){
            btnAddUpdate.setTitle("Update Category", for: .normal)
            categoryTitle.text = category.title
            if let categoryImageURL = category.image {
                let url = URL(string: categoryImageURL)
                let request = URLRequest(url: url!)
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                            self.categoryImage.image = UIImage(data: data!)
                        }
                    }
                }).resume()
            }
        }
        else{
            btnAddUpdate.setTitle("Add Category", for: .normal)
        }
    }

    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddCategory(_ sender: UIButton) {
        if(edit == "Add"){
            if(categoryTitle.text == ""){
                let alert = UIAlertController(title: "Warning", message: "Please Enter the Category Food", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: {Void in
                    
                })
                alert.addAction(okAction)
                present(alert,animated: true,completion: nil)
            }
            else{
                categoryVM.addCategory(image: categoryImage.image!,title: categoryTitle.text!)
            }
        }
        else{
            let imgRef = Storage.storage().reference(forURL: self.category.image!)
            imgRef.delete(completion: nil)
            categoryVM.updateCategory(id: category.id, title: categoryTitle.text!, image: categoryImage.image!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickPickImage(_ sender: UIButton) {
        handleSelectImage()
    }
}

extension AddCategoryVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func handleSelectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            categoryImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



