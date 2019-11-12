//
//  CategoryCell.swift
//  GoodEatingFireBase
//
//  Created by Huy Vo on 11/12/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImg.layer.cornerRadius = 10
        // Initialization code
    }
    
    func configureCell(category: FoodCategory) {
        categoryImg.image = UIImage(named: category.imageName)
        categoryTitle.text = category.title
    }
}
