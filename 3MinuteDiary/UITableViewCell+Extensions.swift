//
//  UITableViewCell+Extensions.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/05/14.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit
extension UITableViewCell{
    
    var tableView:UITableView?{
        return superview as? UITableView
    }

    var indexPath:IndexPath?{
        return tableView?.indexPath(for: self)
    }
}
