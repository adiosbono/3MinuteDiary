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
    
    @IBOutlet var writeButton: UIButton!
    //오늘날짜 기본적으로 선택되어있게 하기 위해 선택된날짜 저장할 변수 설정
    var selectedDate: Date?
    //일기쓰기 버튼임
    @IBAction func writeButton(_ sender: UIButton) {
        
        //날짜를 선택하지 않았으면 기본적으로 오늘 날짜의 일기를 쓰는걸로 되고 만약에 날짜를 선택했으면 그날 날짜의 일기를 쓰는걸로 되도록 해야함.
        print("sending date is \(self.selectedDate?.toLocalTime() ?? Date())")
        
        let WriteDiaryVC = storyboard?.instantiateViewController(identifier: "writeDiaryVC") as! WriteDiaryVC
        WriteDiaryVC.sendedDate = selectedDate?.toLocalTime()
        
        present(WriteDiaryVC, animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //캘린더 만드는 좌표를 화면 중앙으로 해야함...
        let calendar = FSCalendar(frame: CGRect(x: 10, y: 100, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar
        
        //오늘에 해당하는 날짜는 기본으로 항상선택되어있는데(다른날짜를 누르더라도) 이것을 해제한다.
        //self.calendar.today = nil
        //-----------------------------------------------------------------------------------------
        
            //아래의 네줄은 시분초까지 나오는 날짜형식을 년월일만 나오도록 바꾸기 위한것.....언제사용할거냐면 디비 검색할때!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.string(from: Date())
        print("today : \(today)")
        
        
        //기본적으로 오늘에 해당하는 날짜가 선택되어 있도록 한다.
        self.selectedDate = Date()
        
        print("오늘날짜 : \(self.selectedDate!)")
        
        //토요일과 일요일은 달력에 빨간색으로 표시되도록 하자
        calendar.appearance.titleWeekendColor = UIColor.red
        
        //선택된 날짜의 모양을 다른걸로 바꾼다.
        calendar.appearance.borderRadius = 0.5
    }
    
    
    
    
    
    //날짜가 선택되었을 때 뭔가 할수있다
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDate = date.toLocalTime()
    
        print("selected date : \(selectedDate)")
        print("unfixed date : \(date)")
        
        //선택한 시간을 selectedDate변수에 넣는다(로컬타임으로 고친걸로)
        self.selectedDate = date
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



//선택한날짜를 출력하면 항상 하루 전날로 표시되는걸 해결하기 위해 작성한 코드
extension Date {
    // Convert UTC (or GMT) to local time

    func toLocalTime() -> Date {

        let timezone = TimeZone.current

        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))

        return Date(timeInterval: seconds, since: self)

    }

    // Convert local time to UTC (or GMT)

    func toGlobalTime() -> Date {

        let timezone = TimeZone.current

        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))

        return Date(timeInterval: seconds, since: self)

    }

}
