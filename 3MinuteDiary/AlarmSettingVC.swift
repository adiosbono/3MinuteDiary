//
//  AlarmSettingVC.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/05/24.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//
//reference: https://programmingwithswift.com/how-to-send-local-notification-with-swift-5/

import Foundation
import UIKit
import UserNotifications

class AlarmSettingVC: UITableViewController, UNUserNotificationCenterDelegate{
    
    //여기 빈공간에다가는 변수들을 초기화하셈
    
        //로컬알람설정위한 구문
    let userNotificationCenter = UNUserNotificationCenter.current()
        
    
    
    
    //딜리게이트 함수들
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.requestNotificationAuthorization()
            //알람을 등록하는 메소드
        self.sendNotification()
        self.userNotificationCenter.delegate = self
    }
    
    //MARK: 내가만든 함수들
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
    func sendNotification() {
        //새로운 알람내용 인스턴스를 만든다(알람에 포함될 내용을 저장하는 용도)
        let notificationContent = UNMutableNotificationContent()
        //알람내용에 값을 집어넣는다.
        notificationContent.title = "Test"
        notificationContent.body = "Test body"
        //뱃지는 앱아이콘 상단에 붉은점안에 숫자로 뜨는 녀석임
        //MARK: 뱃지를 통해서 하고싶은일 알람으로 해논게 몇갠지 알수있게 하자!
        notificationContent.badge = NSNumber(value: 3)

        // Add an attachment to the notification content
        //알람내용에 첨부파일을 붙일수 있다(사진,소리,영상 등)
        if let url = Bundle.main.url(forResource: "dune",
                                        withExtension: "png") {
            if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                                url: url,
                                                                options: nil) {
                notificationContent.attachments = [attachment]
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
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
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
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
