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
    
    var setTime = "00:00"
    
    override func viewDidLoad() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        //setTime에 현재시간을 초기값으로 넣어준다.
        self.setTime = formatter.string(from: Date())
        print("setTime 현재시간값 : \(self.setTime)")
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        //변경사항 저장 없이 화면 빽 하는 코드 넣기
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        //self.setTime을 호출한 viewController에 반환하며 빽 하는 코드 넣기
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
        
    }
    
    @objc func changed(){
        print("changed함수 실행됨")
        //어디에 쓸지 몰라서 일단 만들어 놈
    }
    
}
