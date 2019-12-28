//
//  ToolBarCell.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2019/12/27.
//  Copyright © 2019 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class ToolBarCell : UITableViewCell {
    
    //셀 내의 취소 버튼 눌렀을때 실행됨
    @IBAction func cancelButton(_ sender: UIButton) {
        print("장비를 정지합니다")
    }
    
    //셀 내의 저장 버튼 눌렀을때 실행됨
    @IBAction func saveButton(_ sender: UIButton) {
        print("저장을 합니다")
    }
    
}
