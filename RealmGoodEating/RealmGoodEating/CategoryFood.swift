//
//  CategoryFood.swift
//  RealmGoodEating
//
//  Created by Huy Vo on 11/20/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers class CategoryFood : Object {
    dynamic var title : String?
    dynamic var image: String?
    
    convenience init(title: String?, image: String?){
        self.init()
        self.title = title
        self.image = image
    }
}
