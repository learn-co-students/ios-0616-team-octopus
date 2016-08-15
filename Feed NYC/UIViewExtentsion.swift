//
//  UIViewExtentsion.swift
//  Feed NYC
//
//  Created by Dennis Vera on 8/14/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

extension UIView {
    
    class func viewFromNibName(name: String) -> UIView? {
        
        let views = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        return views.first as? UIView
    }

}
