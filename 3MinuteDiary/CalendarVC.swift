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

//FSCalendar관련 딜리게이트를 포함시켜주지 않으면 에러가 난다 띠벌탱
class CalendarVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    //화면과 연결된 변수 및 아웃렛 정의
    fileprivate var calendar: FSCalendar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //캘린더 만드는 좌표를 화면 중앙으로 해야함...
        let calendar = FSCalendar(frame: CGRect(x: 10, y: 100, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar
    }


}
