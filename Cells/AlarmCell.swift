//
//  AlarmCell.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/06/14.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class AlarmCell: UITableViewCell {
    //맨위 하고싶은일 내용들어갈 레이블
    @IBOutlet var wantToDo: UILabel!
    //시각을 크게 보여주는 레이블
    @IBOutlet var TimeText: UILabel!
    //시각수정하기 버튼 눌렸을때 실행될 함수
    @IBAction func changeTime(_ sender: UIButton) {
    }
    //맨오른쪽 토글온오프스위치 눌렸을때 실행될 함수
    @IBAction func toggleSwitch(_ sender: UISwitch) {
    }
    
}
