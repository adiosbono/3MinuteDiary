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

//FSCalendar에 내장된 기능 중 쓸만한 것 모음
/*
 //선택된 날짜 모양이 원이 아닌 다른 모양으로 하려면 아래줄에 원하는 값 대입하면 된다
 calendar.appearance.borderRadius = 0
 
 //FSCalendar` can show subtitle for each day
 // FSCalendarDataSource
 func calendar(_ calendar: FSCalendar!, subtitleFor date: NSDate!) -> String! {
     return yourSubtitle
 }
 
 //특정한 날에 이벤트 도트를 집어넣을 수 있다
 // FSCalendarDataSource
 func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
     return 숫자(넣을도트수)
 }
 
 //달력의 위 아래 경계를 숨길 수 있다.
 calendar.clipsToBounds = true
 
 //날짜를 선택했을때 아래의 함수를 통해서 무언가 할 수 있다.
 // FSCalendarDelegate
 func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
 }
 
 //선택되는걸 막을 수 있다.
 func calendar(calendar: FSCalendar!, shouldSelectDate date: NSDate!) -> Bool {
     if dateShouldNotBeSelected {
         return false
     }
     return true
 }
 
 
 
 
 */




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
        
        //선택된 날짜의 모양을 다른걸로 바꾼다.
        calendar.appearance.borderRadius = 0.5
    }
    
    //날짜가 선택되었을 때 뭔가 할수있다
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("\(date)")
    }

    //각 날짜마다 부제목을 달 수 있다.이거를 활용해서 일기 쓴날과 안쓴날을 구분할 수 있을거 같다. O/X 처럼 사용해서
    /*
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return "SHIT"
    }
*/
    
    //이벤트 도트를 집어넣을 수 있다. 이거를 활용해서 일기 오전 오후 쓴거를 구분할수도 있다. 도트한개면 오전이나 오후중 하나만 썼다는거고 두개면 오전오후 다썻다는거임
    /*
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 2
    }
 */
    
    
    
    
}
