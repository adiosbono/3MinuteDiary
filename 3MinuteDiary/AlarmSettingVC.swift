//
//  AlarmSettingVC.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/05/24.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//
//reference: https://programmingwithswift.com/how-to-send-local-notification-with-swift-5/

//시각 비교 참고: https://stackoverflow.com/questions/41646542/how-do-you-compare-just-the-time-of-a-date-in-swift/56006567

import Foundation
import UIKit
import UserNotifications

class AlarmSettingVC: UITableViewController, UNUserNotificationCenterDelegate{
    
    //여기 빈공간에다가는 변수들을 초기화하셈
    
        //로컬알람설정위한 구문
    let userNotificationCenter = UNUserNotificationCenter.current()
        //db사용하기 위한 작업
    let diaryDAO = DiaryDAO()
        //오늘날짜를 저장할 함수
    //var today: String?
        //하고싶은일의 목록을 저장할 배열
    var wantToDoList: [String]?
        //json디코딩을 위한 선언
    let decoder = JSONDecoder()
        //json인코딩을 위한 선언
    let incoder = JSONEncoder()
        //일기데이터를 파싱해서 저장할 구조체 선언(파싱할때 편하도록 특별히 프로토콜 선언함)
    struct Body: Codable {
        //일기의 data행에서 각 목록에 해당하는 정보를 저장할 변수
        var date : String?
        var myObjective : [String]?
        var wantToDo : [String]?
        var whatHappened : [String]?
        var gratitude : [String]?
        var success : [String]?
    }
        //날짜조회시 사용할 기준 시각을 저장하기 위한 변수
    var referenceTime : String?
        //UserDefault사용하기 위한 작업
    let plist = UserDefaults.standard
        //조회시 사용할 날짜를 저장하기 위한 변수
    var searchDate : String?
        //findAlarm 함수의 결과값을 저장할 튜플(date, wantToDo, time)
    typealias alarmRecord = (String, String, String)
        //findAlarm 결과값 저장할 변수
    var alarmRecordForNow = [alarmRecord]()
        //시스템상 등록된 알람의 identifier 목록을 저장할 변수
    var alarmIdentifiers = [String]()
    
    //MARK: 딜리게이트 함수들
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //오늘날짜를 저장하자
        /*
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.today = dateFormatter.string(from: Date())
        print("AlarmSettingVC Today: \(self.today ?? "fuck this is nil")")
    */
         //알람눌럿을때 특정기능수행하기 위한 커스텀 액션 정의
        let cancelAction = UNNotificationAction(identifier: "CANCEL_ACTION", title: "Cancel", options: UNNotificationActionOptions(rawValue: 0))
        let delayAction = UNNotificationAction(identifier: "DELAY_ACTION", title: "Remind Later", options: UNNotificationActionOptions(rawValue: 0))
            //알람 카테고리을 정의
        let reminderCategory = UNNotificationCategory(identifier: "REMINDER", actions: [cancelAction, delayAction], intentIdentifiers: [], options: .customDismissAction)
            //알람 카테고리을 등록한다
        self.userNotificationCenter.setNotificationCategories([reminderCategory])
        
        self.requestNotificationAuthorization()
            //알람을 등록하는 메소드
        //self.sendNotification()
        self.userNotificationCenter.delegate = self
        
        //UserDefault로부터 데이터를 읽어와 전역변수에 대입한다.
        if let temp = plist.string(forKey: "userSetTime"){
            self.referenceTime = temp
            print("plist성공 userSetTime")
        }else{
            print("plist에서 userSetTime를 읽어오는데 실패했습니다. 기본값인 03:00을 집어넣습니다")
            plist.set("03:00", forKey: "userSetTime")
            plist.synchronize()
            //UserDefault에 값을 넣었으니 그녀석을 읽어와서 전역변수에 대입한다.
            self.referenceTime = plist.string(forKey: "userSetTime")
               }
        
        //오늘날짜중 시간만 따로 떼서 비교
        let dateFormatHM = DateFormatter()
        dateFormatHM.dateFormat = "HH:mm"
            //현재시스템시간을 받아 시:분 으로 만든다.
        let nowTime = dateFormatHM.string(from: Date())
        print("nowTime = \(nowTime)")
            //혹시라도 self.referenceTime에 값이 안들어가는 경우를대비해 nil검사해서 nil이면 초기값 03:00을 넣어준다
        if self.referenceTime == nil {
            print("self.referenceTime is nil....abort time comparison....putting 03:00 to self.referenceTime")
            self.referenceTime = "03:00"
        }
        //조건절 값이 참이면 nowTime의 시간이 self.referenceTime보다 더 미래에 있다는 것임(초가 더 많다고 생각하면 편함)
        if(dateFormatHM.date(from: self.referenceTime!)! < dateFormatHM.date(from: nowTime)!) {
                //지금시간이 기준시간을 넘긴경우(기본값 03:00보다 더 시간이 지난경우 예시: 08:00)
            print("load today date")
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.dateFormat = "yyyy-MM-dd"
                //왠진모르겠지만 toGlobalTime안해주면...그냥 아무날짜 선택하지 않고 기본세팅 오늘날짜로 했을때 다음날짜가 일기쓰기 화면에 나옴...
            self.searchDate = dateFormatter.string(from: Date())
            print("self.searchDate = \(self.searchDate!)")
        }else{
                //지금시간이 기준시간에 미치지 못한 경우(기본값 03:00보다 더 시간이 안지났다 예시: 02:00)
            print("load yesterday date")
            let dateFormatter = DateFormatter()
            //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.dateFormat = "yyyy-MM-dd"
                //왠진모르겠지만 toGlobalTime안해주면...그냥 아무날짜 선택하지 않고 기본세팅 오늘날짜로 했을때 다음날짜가 일기쓰기 화면에 나옴...
            let today = Date()
            let yesterday = today-(86400) //60*60*24 = 86400초(하루)
            self.searchDate = dateFormatter.string(from: yesterday)
            print("self.searchDate = \(self.searchDate!)")
        }
        
        //db를 조회하여 해당하는 일자의 data컬럼을 가져온다.
        let diaryData = diaryDAO.findData(writeDate: self.searchDate!)
        //가져온 data컬럼을 파싱한다
        self.wantToDoList = parseDiaryDataForWantToDo(stringData: diaryData)
        //alarmTime테이블을 기준날짜로 조회한다.
        self.alarmRecordForNow = diaryDAO.findAlarm(writeDate: self.searchDate!)
        print("alarmRecordForNow Count: \(self.alarmRecordForNow.count)")
        if self.alarmRecordForNow.count == 0 {
            print("alamrTime테이블에 오늘날짜로된 자료가 없어서 더미데이터를 집어넣습니다")
            self.alarmRecordForNow = [("dummyDate","햄벅먹기", "12:34")]
        }else{
            print("alamrTime테이블에 들어있는 자료갯수: \(self.alarmRecordForNow.count)")
        }
        
        //시스템에 알람이 등록되었는지 확인
            //개헷갈렸는데... 바로아랫줄의 in 구문은 closure의 In 이고... 두번째줄의 for in 은 그냥 for in 구문이다. 즉 completionHandler 에 들어오는 함수형이 (completionHandler: @escaping ([UNNotificationRequest]) -> Void) 이므로... 인자로 [UNNotificationRequest] 가 들어오는거를 여기서는 requests 라는 녀석으로 받아서... for in 구문에서 하나씩 까고 있는 모습이다. 맨 처음에 in for in 구문이 뭔지 처음봐서 엄청 헷갈렸었음...이런 빡대가리
        self.userNotificationCenter.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
                self.alarmIdentifiers.append(request.identifier)
                print("self.alarmIdentifiers: \(self.alarmIdentifiers)")
            }
        })
        //바로아래줄은 알람 없애는 구문임
        //self.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: <#T##[String]#>)
    }
    
    //테이블 행의 개수를 결정하는 메소드
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("tableCell count = \(self.wantToDoList?.count)")
        return self.wantToDoList?.count ?? 1
    }
    
    //테이블 행을 구성하는 메소드....보완할거 천국이구만
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("section: \(indexPath.section) / row: \(indexPath.row) 생성중")
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell") as! AlarmCell
        cell.wantToDo.text = self.wantToDoList?[indexPath.row]
        //화면전환을 위해 화면전환을 요청한 vc의 정보가 필요하므로 넘겨준다.
        cell.originVC = self
        //alarmTable에서 가져온 자료와 wantToDoList의 자료를 비교
        for alarmWantToDo in self.alarmRecordForNow{
            if alarmWantToDo.1.isEqual(self.wantToDoList?[indexPath.row]){
                print("하고싶은일 일치하는것 찾음")
                cell.TimeText.text = alarmWantToDo.2
                print("하고싶은일 : \(alarmWantToDo.1) / 알람시각 : \(alarmWantToDo.2)")
                //여기서는 미리 알람큐에서 뽑아온 identifier 목록을 참고해서 일치하는 녀석이 있으면... 토글스위치를 on상태로 만들면 된다.
            }else{
                print("하고싶은일 일치하는게 없음...TimeText에 대입하지 않을 것임...switch disable시킴")
                //togleSW disable시킴
                cell.toggleSW.isEnabled = false
            }
        }
        return cell
    }
    
    //셀의 높이를 지정하는 함수
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92.0
    }
    
    //MARK: 내가만든 함수들
         //db에서 불러온 data를 파싱하여 '하고싶은일'만 반환하는 함수
    func parseDiaryDataForWantToDo(stringData: String) -> [String]? {
        var result : [String]? = nil
        print("check incoming data: \(stringData)")
        //우선 utf8형식으로 인코딩
        let jsonData = stringData.data(using: .utf8)
        //디버깅 위한 조건절
        if jsonData == nil {
            print("jsonData is nil....abort!!  parseDiaryDataForWantToDo")
        }else{
            print("jsonData is not nil...commence jsonParsing")
            do{
                let tempBody = try decoder.decode(Body.self, from: jsonData!)
                print("파싱 컴플릿")
                result = tempBody.wantToDo
            }catch{
                print("파싱 error")
                result = nil
            }
        }
        return result
    }
    
        //사용자에게 허락맡는 함수
    func requestNotificationAuthorization() {
        //사용자에게 어떤내용을 허락맡을지 정한다
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        //허락을 발생시킨다
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
        //알람보낼때 쓸 함수
    func sendNotification(identifier: String, alarmTime: DateComponents) {
        print("sendNotification 실행됨")
        //새로운 알람내용 인스턴스를 만든다(알람에 포함될 내용을 저장하는 용도)
        let notificationContent = UNMutableNotificationContent()
        //알람내용에 값을 집어넣는다.
        notificationContent.title = "3minuteDiary Alarm"
        notificationContent.body = identifier
        notificationContent.sound = .default //무슨소리가 날지 궁금함...
        //뱃지는 앱아이콘 상단에 붉은점안에 숫자로 뜨는 녀석임
        //MARK: 뱃지를 통해서 하고싶은일 알람으로 해논게 몇갠지 알수있게 하자!
        notificationContent.badge = NSNumber(value: self.wantToDoList?.count ?? 1)
        //알람카테고리를 설정한다
        notificationContent.categoryIdentifier = "3minuteDiary"
        // Add an attachment to the notification content
        //알람내용에 첨부파일을 붙일수 있다(사진,소리,영상 등) 하지만 내 앱에선 쓸 일이 없다
        /*
        if let url = Bundle.main.url(forResource: "dune",
                                        withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                                url: url,
                                                                options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        */
        //바로아래것은 현재시간기준으로 얼마동안의 시간 후에 알람을 발생시킬 것인지 정하는것
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,repeats: false)
        //calendar를 기준으로 알람을 발생시킬지 정하는 것
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarmTime, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
        //MARK: 기본적으로 앱이 foreground에 있으면 설정해논 알람이 안뜬다...알람을 foreground에서도 보고싶으면 추가적인 작업이 필요함
    }
    
        //앱이 foreground에서 실행중일때도 알림이 나타나게 하기위한 함수 두개
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier{
        case "CANCEL_ACTION":
            print("cancelAction pushed")
            break
        case "DELAY_ACTION":
            print("delayAction Pushed")
            break
        default:
            print("제3의버튼이 눌린듯....뭐지")
            break
        }
        //하고싶은일을 다 했으면 반드시 이녀석을 실행시켜줘야 한다.
        completionHandler()
    }

     //이거는 알람선택하면 무조건 실행된다. 뭐를 선택하든, 선택하지 않든간에...참고로 이 함수를 써야 앱이 포어그라운드상태일때도 알람이 온다.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent 실행됨")
        completionHandler([.alert, .badge, .sound])
    }
 
    /*
    
//화면이 나타날때마다 호출되는 메소드
override func viewWillAppear(_ animated: Bool) {
    self.tableView.reloadData()
}
//테이블 행의 개수를 결정하는 메소드
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
}

//테이블 행을 구성하는 메소드
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
}
//테이블의 특정 행이 선택되었을때 호출되는 메소드
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
}
//테이블 뷰의 섹션의 수 결정하는 메소드 따로 오버라이드 하지 않으면 기본값은 1임
override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
//각 섹션 헤더에 들어갈 뷰를 정의하는 메소드. 섹션별 타이틀을 뷰 형태로 구성하는 메소드 1080
override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
}
//각 섹션 헤더의 높이를 결정하는 메소드
override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     
}
    */
}
