//
//  ViewController.swift
//  GoodEatingFireBase
//
//  Created by Huy Vo on 11/12/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refFoodCategory: DatabaseReference!
    var foodCategoryList = [FoodCategory]()
    var category: FoodCategory!
    @IBOutlet weak var tblCategory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                self.tblCategory.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foodCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as! CategoryCell
        
        cell.categoryTitle.text = foodCategoryList[indexPath.row].title
        cell.categoryImg.image = UIImage(named: foodCategoryList[indexPath.row].imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category = foodCategoryList[indexPath.row]
    }
    
    func updateCategory(id: String, title:String, image: String){
        let category = [
            "id": id,
            "title": title,
            "imageName": image]
        refFoodCategory.child(id).setValue(category)
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Category", message: "Add", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Category Here"
        })
        
        alert.addTextField(configurationHandler: {(textField) in
            textField.placeholder = "Image Name"
        })
        
        let addAction = UIAlertAction(title: "OK", style: .default, handler: {(_) in
            let key = self.refFoodCategory.childByAutoId().key
            let category = ["id":key,
                            "title": alert.textFields?[0].text!,
                            "imageName" : alert.textFields?[1].text!]   
            self.refFoodCategory.child(key!).setValue(category)
        })
        
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        alert.addAction(cancleAction)
    
        alert.addAction(addAction)
        
        present(alert,animated: true,completion: nil)
    }
    
    @IBAction func btnEditCategory(_ sender: UIBarButtonItem) {
        if(category == nil){
            let alert = UIAlertController(title: "Information", message: "Please Choose Food Category", preferredStyle: .alert)
            
            let updateAction = UIAlertAction(title: "OK", style: .default, handler: {Void in
                
            })
            
            alert.addAction(updateAction)
            
            present(alert,animated: true,completion: nil)
            
        }
        else{
            let alert = UIAlertController(title: "Update", message: category.title, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: {(textField) in
                textField.text = self.category.title
            })
            
            alert.addTextField(configurationHandler: {(textField) in
                textField.text = self.category.imageName
            })
            
            let updateAction = UIAlertAction(title: "OK", style: .default, handler: {(_) in
                
                let id = self.category.id
                let title = alert.textFields?[0].text
                let imageName = alert.textFields?[1].text
                
                self.updateCategory(id: id, title: title!, image: imageName!)
                
            })
            
            let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
            
            alert.addAction(cancleAction)
            alert.addAction(updateAction)
            
            present(alert,animated: true,completion: nil)
        }
    }
    
    func delete(id: String){
        refFoodCategory.child(id).setValue(nil)
    }
    
    @IBAction func deleteCategory(_ sender: UIBarButtonItem) {
        if(category == nil){
            let alert = UIAlertController(title: "Information", message: "Please Choose Food Category", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "OK", style: .default, handler: {Void in
                
            })
            
            alert.addAction(deleteAction)
            
            present(alert,animated: true,completion: nil)
        }
        
        else{
            
            let alert = UIAlertController(title: "Delete", message: category.title, preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "OK", style: .destructive, handler: {Void in
                self.delete(id: self.category.id)
            })
            
            let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
            
            alert.addAction(cancleAction)
            alert.addAction(deleteAction)
            
            present(alert,animated: true,completion: nil)
        }
    }
    
    
}

