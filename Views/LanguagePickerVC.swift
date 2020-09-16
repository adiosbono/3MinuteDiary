//
//  innerPickerVC.swift
//  3MinuteDiary
//
//  Created by Boram Cho on 2020/09/16.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class LanguagePickerVC: UIViewController{
    let PV = UIPickerView()
    //UserDefault사용하기 위한 작업
    //let plist = UserDefaults.standard
    
    override func viewDidLoad() {
        //피커뷰의 크기를 정해준다
        self.PV.frame = CGRect(x: 0, y: 0, width: 250, height: 160)
        //뷰컨트롤러 자체의 사이즈를 지정한다.(피커뷰의 넓이와 같고, 높이는 피커뷰보다 10더 높게)
        self.preferredContentSize = CGSize(width: self.PV.frame.width, height: self.PV.frame.height+10)
        //딜리게이트와 데이터소스 출처를 이 클래스로 한다
        //self.PV.delegate = self
        //self.PV.dataSource = self
        
        //PV를 루트뷰에 추가한다
        self.view.addSubview(self.PV)
    }
    /*
    //MARK: 피커뷰관련 딜리게이트 함수
    
    //피커뷰에 고를녀석 뭔지 써주기
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "한국어"
        case 1:
            return "English"
        default :
            return "Eat my shorts"
        }
    }
        //피커뷰로 선택했을때 실행될 함수
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("선택한넘 순서 : \(row)")
        switch row {
        case 0: //한국어인경우
            print("한국어를 선택하셨습니다")
            self.plist.set("한국어", forKey: "language")
            self.plist.synchronize()
            //self.settingTableView.reloadData()
        case 1: //영어인 경우
            print("User choose English")
            self.plist.set("English", forKey: "language")
            self.plist.synchronize()
            //self.settingTableView.reloadData()
        default : //기본값
            print("STFU")
        }
    }
    //피커뷰 컴포넌트 수(고를것이 몇개인지)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //각 컴포넌트당 몇개의 항목을 둘것인지
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
 */
}
