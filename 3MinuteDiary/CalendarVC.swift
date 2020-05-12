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
    
    //일기쓰기 화면으로 전환할때 푸터뷰를 나타낼지 말지 알려주는 역할을 할 변수
    var showFooter = true
    
    //circleList를 변환해서 저장한 딕셔너리...키는 날짜(String)  값은 튜플(Int,Int)
    var circleDictionary = [String : (Int, Int)]()
    
    //findMorningNight 함수의 결과값을 저장할 튜플(String, Int, Int)
    typealias circleRecord = (String, Int, Int)
    //일기쓴날 아래 점찍을때 쓸 자료들 모아노은녀석
    var circleList = [circleRecord]()
    
    //db사용하기 위한 작업
    let diaryDAO = DiaryDAO()
    
    //화면과 연결된 변수 및 아웃렛 정의
    fileprivate var calendar: FSCalendar!
    
    @IBOutlet var writeButton: UIButton!
    //오늘날짜 기본적으로 선택되어있게 하기 위해 선택된날짜 저장할 변수 설정
    var selectedDate: Date?
    //일기쓰기 버튼임
    @IBAction func writeButton(_ sender: UIButton) {
        
        //날짜를 선택하지 않았으면 기본적으로 오늘 날짜의 일기를 쓰는걸로 되고 만약에 날짜를 선택했으면 그날 날짜의 일기를 쓰는걸로 되도록 해야함.
        print("sending date is \(self.selectedDate ?? Date())")
        
        let WriteDiaryVC = storyboard?.instantiateViewController(identifier: "writeDiaryVC") as! WriteDiaryVC
        WriteDiaryVC.sendedDate = self.selectedDate
        WriteDiaryVC.showFooter = self.showFooter
        present(WriteDiaryVC, animated: true, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //점찍기용
            //우선 데이터를 읽어온다
        self.circleList = self.diaryDAO.findMorningNight()
            //딕셔너리를 만든다. 키는 날짜이고 값은 튜플(morning, night)
        for circle in self.circleList {
            print("circleDictionary생성중 : \(circle)")
            self.circleDictionary[circle.0] = (circle.1, circle.2)
        }
        self.calendar.reloadData()
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
        
        
        //기본적으로 오늘에 해당하는 날짜가 선택되어 있도록 한다.--------------------------------------------------------------------------------으악
        self.selectedDate = Date().toLocalTime()
        
        print("오늘날짜 : \(self.selectedDate!)")
        
        //토요일과 일요일은 달력에 빨간색으로 표시되도록 하자
        calendar.appearance.titleWeekendColor = UIColor.red
        
        //선택된 날짜의 모양을 다른걸로 바꾼다.
        calendar.appearance.borderRadius = 0.5
        
            //점찍기용
            //우선 데이터를 읽어온다
        self.circleList = self.diaryDAO.findMorningNight()
            //딕셔너리를 만든다. 키는 날짜이고 값은 튜플(morning, night)
        for circle in self.circleList {
            print("circleDictionary생성중 : \(circle)")
            self.circleDictionary[circle.0] = (circle.1, circle.2)
        }
    }
    
    
    
    
    //MARK: 날짜가 선택되었을 때 실행되는 함수
    //날짜가 선택되었을 때 뭔가 할수있다
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDate = date.toLocalTime()
    
        print("selected date : \(selectedDate)")
        print("unfixed date : \(date)")
        
        //선택한 시간을 selectedDate변수에 넣는다(로컬타임으로 고친걸로)
        self.selectedDate = selectedDate
        
        //여기서부터는 '일기쓰기'버튼의 텍스트를 바꾸기 위한 작업
            //우선 날짜형식을 바꿔주는것부터 하자
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectDay = dateFormatter.string(from: date)
        
        
            //전역변수인 circleDictionary에 selectDay를 키로 하여 조회한다.
        let isWritten = self.circleDictionary[selectDay]
        
        if isWritten == nil {//일기를 쓰지 않은 날인 경우..마찬가지로 텍스트를 바꿔줘야 한다. 왜냐면 전에 일기쓴날 누르고 일기 안쓴날 누른경우도 있을테니까
            self.writeButton.setTitle("일기쓰기", for: .normal)
            //일기안썻으니까 morning night 모두 0일거니깐 showFooter에 true 넣어주자
            self.showFooter = true
        }else{//일기를 쓴 날인 경우...텍스트를 바꿔줘야한다
            self.writeButton.setTitle("일기보기", for: .normal)
            //showFooter값을 넣어줄때 morning과 night값을 조회하여 둘다 1이면 false, 하나라도 0이면 true
            let morning = isWritten!.0
            let night = isWritten!.1
            var result: Bool!
            if morning*night == 1 {//두 값을 곱했을때 1이라는건 둘다 1이라는거니까 이건 일기를 다 쓴 날이다. footer안보이게 하자
                print("일기를 쓴 날이다")
                result = false
            }else{//두 값중 하나라도 0이면 여기로 분기된다. footer를 보여줘야 된다
                print("일기를 안쓴 날이다")
                result = true
            }
            self.showFooter = result
        }
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
    //날짜아래 자막을 넣어주는 함수
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        //우선 date로 들어온 인수를 조회가 가능한 형태로 바꿔줘야한다.(yyyy-MM-dd)
        //아래의 네줄은 시분초까지 나오는 날짜형식을 년월일만 나오도록 바꾸기 위한것.....언제사용할거냐면 디비 검색할때!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
            //nowDay안에 조회할 날짜가 들어있다.
        let nowDay = dateFormatter.string(from: date)
        
        if let nowCircle = self.circleDictionary[nowDay] {
            //if두번중첩하게 되서 지저분한데 결론은 morning, night 값이 00,10,01,11인 경우로 총 4가지로 분기하는것임
            if nowCircle.0 == 0{ //앞자리가 0
                if nowCircle.1 == 0{    //00
                    print("day: \(date), 00(morning:night = \(nowCircle.0):\(nowCircle.1)")
                    return nil
                }else{                  //01
                    print("day: \(date), 01(morning:night = \(nowCircle.0):\(nowCircle.1)")
                    return "◑"
                }
                
            }else{//앞자리가 1
                if nowCircle.1 == 0{    //10
                    print("day: \(date), 10(morning:night = \(nowCircle.0):\(nowCircle.1)")
                    return "◐"
                }else{                  //11
                    print("day: \(date), 11(morning:night = \(nowCircle.0):\(nowCircle.1)")
                    return "●"
                }
            }
            
        }else{//조회했는데 해당 값이 없기 때문에 일기 안쓴것이므로 아무것도 안해도 됨
            return nil
        }
    }
    
    
    
    
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
