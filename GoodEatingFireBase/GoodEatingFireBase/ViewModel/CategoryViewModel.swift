//
//  CategoryModel.swift
//  GoodEatingFireBase
//
//  Created by Huy Vo on 11/12/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
class CategoryViewModel: NSObject {
    var refFoodCategory: DatabaseReference!
    var foodCategoryList = [FoodCategory]()
    
    func loadData(tableData: UITableView){
        refFoodCategory = Database.database().reference().child("category")
        refFoodCategory.observe(DataEventType.value, with: {(snapshot) in
            if snapshot.childrenCount > 0 {
                self.foodCategoryList.removeAll()
                for foodCategories in snapshot.children.allObjects as![DataSnapshot]{
                    let foodCategoryObject = foodCategories.value as? [String: AnyObject]
                    
                    let categoryID = foodCategoryObject?["id"]
                    let categoryTitle = foodCategoryObject?["title"]
                    let categoryImg = foodCategoryObject?["image"]
                    
                    let foodCategory = FoodCategory(id: categoryID as! String,title: categoryTitle as! String?, image: categoryImg as! String?)
                    
                    self.foodCategoryList.append(foodCategory)
                }
            }
            tableData.reloadData()
        })
    }
    
    func countCategory() -> Int {
        return foodCategoryList.count
    }
    
    func getCategory(row: Int) -> FoodCategory {
        return foodCategoryList[row]
    }
    
    func addCategory(image: UIImage,title: String){
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageName).jpeg")
        if let uploadData = image.jpegData(compressionQuality: 0.75){
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                else {
                    let key = self.refFoodCategory.childByAutoId().key
                        storageRef.downloadURL(completion: {(url,error) in
                            let values = ["id":key,
                                "title": title,
                                "image": url?.absoluteString]
                            self.refFoodCategory.child(key!).setValue(values)
                    })
                }
            })
        }
    }
    
    func updateCategory(id: String, title:String, image: UIImage){
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("\(imageName).jpeg")
        if let uploadData = image.jpegData(compressionQuality: 0.75){
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                else {
                        storageRef.downloadURL(completion: {(url,error) in
                            let categories = ["id":id,
                                "title": title,
                                "image": url?.absoluteString]
                            self.refFoodCategory.child(id).setValue(categories)
                    })
                }
            })
        }
    }
    
    func delete(id: String){
        refFoodCategory.child(id).setValue(nil)
    }
}

