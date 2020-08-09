//
//  AlarmTimeSetVC.swift
//  3MinuteDiary
//
//  Created by Boram Cho on 2020/07/15.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class AlarmTimeSetVC: UIViewController {
    
    var originVC: AlarmSettingVC?
    var setTime = "00:00"
    var searchDate: String?
    var wantToDo: String?
    var tempTableViewCell: AlarmCell?
    var hours: String?
    var minutes: String?
    //db사용하기 위한 구문
    let diaryDAO = DiaryDAO()
    
    override func viewDidLoad() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        //setTime에 현재시간을 초기값으로 넣어준다.
        self.setTime = formatter.string(from: Date())
        print("setTime 현재시간값 : \(self.setTime)")
        //전역변수 searchDate에 AlarmSettingVC에 있는 searchDate녀석을 넣어준다.
        if(self.originVC == nil){
            print("originVC가 nil입니다. at AlarmTimeSetVC")
        }else{
            self.searchDate = originVC?.searchDate
            print("AlarmSettingVC에서 받아온 serachDate: \(self.searchDate)")
        }
        if(wantToDo == nil){
            print("wantToDo is nil")
        }else{
            print("Received wantToDo: \(self.wantToDo)")
        }
        if(tempTableViewCell == nil){
            print("tempTableViewCell is nil")
        }else{
            print("tempTableViewCell is not nil")
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        //변경사항 저장 없이 화면 빽 하는 코드 넣기
        //프레젠트 방식으로 넘긴 화면에서 원래대로 돌아간드아
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        //db에 입력하자.
        self.diaryDAO.insertAlarm(writeDate: self.searchDate!, wantToDo: self.wantToDo!, time: self.setTime)
        //self.setTime을 호출한 viewController에 사용자가 선택한 시간값을 전달(셀에 시간이 바뀌도록 하는것)
        self.tempTableViewCell?.TimeText.text = self.setTime
        //셀에 있는 스위치를 on으로 한다
        self.tempTableViewCell?.toggleSW.isEnabled = true
        self.tempTableViewCell?.toggleSW.isOn = true
        //시스템 알람 큐에 알람을 등록한다-------------------------------------------------
            //우선 DateComponents자료형을 하나 만든다
        let date = Date() //현재지금시각
        var triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
            //시간과 분을 사용자가 설정한 시각으로 바꿔주자
        triggerDate.hour = Int(self.hours!)
        triggerDate.minute = Int(self.minutes!)
        
            //알람설정하는 함수 호출!
        self.originVC?.sendNotification(identifier: self.wantToDo!, alarmTime: triggerDate)
        
        //프레젠트 방식으로 넘긴 화면에서 원래대로 돌아간드아
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func datePickerView(_ sender: UIDatePicker) {
        //datePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
        
        //전달된 인수 저장
        let sentDatePicker = sender
        sentDatePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.setTime = formatter.string(from: sentDatePicker.date)
        print("self.setTime = \(self.setTime)")
        
        formatter.dateFormat = "HH"
        self.hours = formatter.string(from: sentDatePicker.date)
        print("self.hours = \(self.hours)")
        
        formatter.dateFormat = "mm"
        self.minutes = formatter.string(from: sentDatePicker.date)
        print("self.minutes = \(self.minutes)")
    }
    
    @objc func changed(){
        print("changed함수 실행됨")
        //어디에 쓸지 몰라서 일단 만들어 놈
    }
    
}
