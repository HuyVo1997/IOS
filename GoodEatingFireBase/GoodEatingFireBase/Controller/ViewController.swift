//
//  ViewController.swift
//  GoodEatingFireBase
//
//  Created by Huy Vo on 11/12/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categoryVM = CategoryViewModel()
    var category: FoodCategory!
    var editText: String!
    
    @IBOutlet weak var tblCategory: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categoryVM.loadData(tableData: tblCategory)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryVM.countCategory()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath) as! CategoryCell
        
        cell.categoryTitle.text = categoryVM.getCategory(row: indexPath.row) .title
        
        if let categoryImageURL = categoryVM.getCategory(row: indexPath.row).image {
            let url = URL(string: categoryImageURL)
            let request = URLRequest(url: url!)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        cell.categoryImg.image = UIImage(data: data!)
                    }
                }
            }).resume()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        category = categoryVM.getCategory(row: indexPath.row)
        
    }
    
    @IBAction func deleteCategory(_ sender: UIBarButtonItem) {
        if(category == nil){
            let alert = UIAlertController(title: "Information", message: "Please Choose Category Food", preferredStyle: .alert)

            let deleteAction = UIAlertAction(title: "OK", style: .default, handler: {Void in

            })

            alert.addAction(deleteAction)

            present(alert,animated: true,completion: nil)
        }

        else{

            let alert = UIAlertController(title: "Delete", message: category.title, preferredStyle: .alert)

            let deleteAction = UIAlertAction(title: "OK", style: .destructive, handler: {Void in
                let imgRef = Storage.storage().reference(forURL: self.category.image!)
                imgRef.delete(completion: nil)
                self.categoryVM.delete(id: self.category.id)
                
            })

            let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)

            alert.addAction(cancleAction)
            alert.addAction(deleteAction)

            present(alert,animated: true,completion: nil)
        }
    }
    
    @IBAction func btnEditCategory(_ sender: UIBarButtonItem) {
        editText = "Edit"
        performSegue(withIdentifier: "editPresent", sender: self)
    }
    
    @IBAction func btnAddCategory(_ sender: UIBarButtonItem) {
        editText = "Add"
        performSegue(withIdentifier: "editPresent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? AddCategoryVC {
            editVC.edit = editText
            if(editText == "Edit"){
                editVC.category = category
            }
        }
    }
}

