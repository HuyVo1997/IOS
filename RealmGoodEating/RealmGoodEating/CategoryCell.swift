//
//  CategoryCell.swift
//  RealmGoodEating
//
//  Created by Huy Vo on 11/20/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryTitle: UILabel!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(category: CategoryFood){
        categoryTitle.text = category.title!
        categoryImage.image = UIImage(named:category.image!)
    }
}
