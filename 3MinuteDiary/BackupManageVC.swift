//
//  BackupManageVC.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/02/29.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit
class BackupManageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    //전역변수 설정하기
    @IBOutlet var settingTableView: UITableView!
    
    //UserDefault사용하기 위한 작업
       let plist = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
        
        //userDefault에 언어설정 값이 없다면 초기값으로 한국어를 넣어준다.
        if let langSetValue = plist.string(forKey: "language") {
            print("이미 설정된 언어설정값이 있습니다 : \(langSetValue)")
        }else{
            print("설정된 언어설정값이 없으므로 기본값으로 한국어를 입력합니다")
            self.plist.set("한국어", forKey: "language")
            self.plist.synchronize()
        }
    }
    
    //테이블 행의 개수를 결정하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("7이랑게")
        return 7
    }
    
    //테이블 행의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //테이블 행 구성
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
        //겹치는 문제 해결을 위하여 프로토타입셀을 하나 더 만들어서 해결함
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageSelectCell") as! LanguageSelectCell
        cell.title.text = "언어설정"
        cell.selectedLanguage.text = plist.string(forKey: "language")
        return cell
    case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        cell.title.text = "일기데이터 내보내기"
        return cell
    case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellWithSwitch") as! SettingCellWithSwith
        cell.title.text = "아이클라우드 백업 활성화"
        cell.row = indexPath.row
        cell.backupManageViewController = self
        return cell
    case 3:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellWithSwitch") as! SettingCellWithSwith
        cell.title.text = "아이클라우드 백업시 사진도 백업"
        cell.row = indexPath.row
        cell.backupManageViewController = self
        return cell
    case 4:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        cell.title.text = "광고제거하기"
        return cell
    case 5:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellWithSwitch") as! SettingCellWithSwith
        cell.title.text = "앱 잠금설정"
        cell.row = indexPath.row
        cell.backupManageViewController = self
        return cell
    case 6:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        cell.title.text = "앱 잠금 비밀번호 설정/변경"
        return cell
    default:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        cell.title.text = "디폴트디폴트"
        return cell
    }
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            print("언어설정 터치되었습니다")
            //기본적인 알라트팝업세팅
            let alert = UIAlertController(title: "Select Language", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler(alert:))
                //오케이액션에 핸들러가 있는데 그녀석을 쓰기 위해서는 함수를 따로 만들어야함
            let okAction = UIAlertAction(title: "OK", style: .default, handler: okHandler(alert:))
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
                //알라트팝업 가운데에 끼워넣을 뷰
            let v = LanguagePickerVC()
                //LanguagePickerVC안의 피커뷰에 대한 딜리게이트를 현재 클래스로 지정한다.
            v.PV.dataSource = self
            v.PV.delegate = self
            
               
                //알림창에 뷰 컨트롤러를 등록한다
            alert.setValue(v, forKey: "contentViewController")
            
            self.present(alert, animated: false, completion: nil)
        default:
                print("스위치문에서 디폴드값 실행됨")
            
            //var height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.40)
            //var width:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.width * 0.40)
                //alert.view.addConstraint(height)
                //alert.view.addConstraint(width)
                //알라트팝업을 표시한다
            /*
            // Filtering width constraints of alert base view width
            let widthConstraints = alert.view.constraints.filter({ return $0.firstAttribute == .width })
            alert.view.removeConstraints(widthConstraints)
            // Here you can enter any width that you want
            let newWidth = UIScreen.main.bounds.width * 0.90
            // Adding constraint for alert base view
            let widthConstraint = NSLayoutConstraint(item: alert.view,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1,
                                                     constant: newWidth)
            alert.view.addConstraint(widthConstraint)
            let firstContainer = alert.view.subviews[0]
            // Finding first child width constraint
            let constraint = firstContainer.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
            firstContainer.removeConstraints(constraint)
            // And replacing with new constraint equal to alert.view width constraint that we setup earlier
            alert.view.addConstraint(NSLayoutConstraint(item: firstContainer,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: alert.view,
                                                        attribute: .width,
                                                        multiplier: 1.0,
                                                        constant: 0))
            // Same for the second child with width constraint with 998 priority
            let innerBackground = firstContainer.subviews[0]
            let innerConstraints = innerBackground.constraints.filter({ return $0.firstAttribute == .width && $0.secondItem == nil })
            innerBackground.removeConstraints(innerConstraints)
            firstContainer.addConstraint(NSLayoutConstraint(item: innerBackground,
                                                            attribute: .width,
                                                            relatedBy: .equal,
                                                            toItem: firstContainer,
                                                            attribute: .width,
                                                            multiplier: 1.0,
                                                            constant: 0))
            */
            
                
        }
    }
    //오케이액션에 쓸 함수 만들자
    func okHandler(alert: UIAlertAction){
        print("ok눌림")
        //프레젠트 방식으로 넘긴 화면에서 원래대로 돌아간드아
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //캔슬액션에 쓸 함수 만들자
    func cancelHandler(alert: UIAlertAction){
        //해야할것 : 이미 입력된 텍스트필드의 값에 nil 집어넣어보리기...(입력이 들어갔지만 이걸 다시 없던걸로 돌리는거임 ㅋㅋㅋㅋㅋㅋㅋ뭣이중헌디)
        print("cancel눌림")
        
    }
    
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
            self.settingTableView.reloadData()
        case 1: //영어인 경우
            print("User choose English")
            self.plist.set("English", forKey: "language")
            self.plist.synchronize()
            self.settingTableView.reloadData()
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
    
    //MARK: 셀 내의 토글버튼 작동시 실행되는 함수 모음
    
    //아이클라우드 백업 활성화 토글버튼 작동시 실행할 함수
    func icloudBackupActivate(toggle: Bool){
        if toggle == true {
            print("icloudBackupActivate is true")
        }else{
            print("icloudBackupActivate is false")
        }
    }
    //아이클라우드백업시 사진도 백업 토글버튼 작동시 실행할 함수
    func backupPhotoToo(toggle: Bool){
        if toggle == true {
            print("backupPhotoToo is true")
        }else{
            print("backupPhotoToo is false")
        }
    }
    
    //앱 잠금설정 토글버튼 작동시 실행할 함수
    func lockupSetting(toggle: Bool){
        if toggle == true {
            print("lockupSetting is true")
        }else{
            print("lockupSetting is false")
        }
    }
}
