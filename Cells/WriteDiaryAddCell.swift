//
//  WriteDiaryAddCell.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/04/12.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class WriteDiaryAddCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet var addTextView: UITextView!
    //indexPath가져오는 메서드 오예
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        let indexPath = superView.indexPath(for: self)
        return indexPath
    }
}
