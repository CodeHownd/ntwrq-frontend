//
//  testLoginStackView.swift
//  NTWRK
//
//  Created by Yashgur, David on 10/1/19.
//  Copyright © 2019 David Yashgur. All rights reserved.
//

import UIKit

class testLoginStackView: UIView {
        override open class var layerClass: AnyClass {
           return CAGradientLayer.classForCoder()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            let gradientLayer = layer as! CAGradientLayer
            gradientLayer.colors = [UIColor(red:0.82, green:0.60, blue:0.96, alpha:1.0).cgColor, UIColor(red:0.69, green:0.72, blue:0.98, alpha:1.0).cgColor]
        }
}
