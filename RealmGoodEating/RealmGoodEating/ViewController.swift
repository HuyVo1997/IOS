//
//  ViewController.swift
//  RealmGoodEating
//
//  Created by Huy Vo on 11/20/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit
import RealmSwift
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tbvCategoryFood: UITableView!
    var editText: String!
    var categoryFoodList : Results<CategoryFood>!
    var notificationToken: NotificationToken?
    var categorySelected: CategoryFood?
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        categoryFoodList = realm.objects(CategoryFood.self)
        notificationToken = realm.observe{(notification,realm) in self.tbvCategoryFood.reloadData()}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tbvCategoryFood.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryFoodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        cell.configureCell(category: categoryFoodList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categorySelected = categoryFoodList[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    @IBAction func deleteCategory(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: categorySelected?.title, message: "Delete Category", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {Void in
            self.delete(self.categorySelected!)
            self.tbvCategoryFood.reloadData()
        })
        
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancleAction)
        
        present(alert,animated: true,completion: nil)
    }
    
    @IBAction func updateCategory(_ sender: UIBarButtonItem) {
        editText = "Update"
        performSegue(withIdentifier: "editPresent", sender: self)
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        editText = "Add"
        performSegue(withIdentifier: "editPresent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editVC = segue.destination as? AddUpdateCategory{
            editVC.edit = editText
            if(editText == "Update"){
                editVC.category = categorySelected
            }
        }
    }
    
    func create<T: Object>(_ object: T){
        do {
            try realm.write {
                realm.add(object)
            }
        }catch {
            print (error)
        }
    }
    
    func delete<T: Object>(_ object: T){
        do{
            try realm.write {
                realm.delete(object)
            }
        }
        catch {
            print (error)
        }
    }
    
    
}

