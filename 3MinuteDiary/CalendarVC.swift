//
//  CalendarVC.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2019/12/22.
//  Copyright © 2019 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit
import FSCalendar

class CalendarVC: UIViewController {
    
    //화면과 연결된 변수 및 아웃렛 정의
    fileprivate var calendar: FSCalendar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar
    }


}
