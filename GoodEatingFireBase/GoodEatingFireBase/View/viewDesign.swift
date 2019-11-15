//
//  viewDesign.swift
//  GoodEatingFireBase
//
//  Created by Huy Vo on 11/13/19.
//  Copyright © 2019 Huy Vo. All rights reserved.
//

import UIKit

@IBDesignable class viewDesign: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
