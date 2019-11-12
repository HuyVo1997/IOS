//
//  CategoryModel.swift
//  GoodEatingFireBase
//
//  Created by Huy Vo on 11/12/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit
import FirebaseDatabase

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
                    let categoryId = foodCategoryObject?["id"]
                    let categoryTitle = foodCategoryObject?["title"]
                    let categoryImg = foodCategoryObject?["imageName"]
                    
                    let foodCategory = FoodCategory(id: (categoryId as! String?)!,title: ((categoryTitle as! String?)!), imageName: ((categoryImg as! String?)!))
                    
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
    
    func updateCategory(id: String, title:String, image: String){
        let category = [
            "id": id,
            "title": title,
            "imageName": image]
        refFoodCategory.child(id).setValue(category)
    }
    
    func delete(id: String){
        refFoodCategory.child(id).setValue(nil)
    }
    
    func addCategory(title: String!, imageName: String!){
        let key = self.refFoodCategory.childByAutoId().key
        let category = ["id":key,
                        "title": title,
                        "imageName" : imageName]
        self.refFoodCategory.child(key!).setValue(category)
    }
}
