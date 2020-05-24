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

class AlarmSettingVC: UITableViewController{
    
    //여기 빈공간에다가는 변수들을 초기화하셈
    
        //로컬알람설정위한 구문
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    
    
    
    //딜리게이트 함수들
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestNotificationAuthorization()
        self.sendNotification()
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
        // Code here
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
