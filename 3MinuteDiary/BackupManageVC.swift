//
//  BackupManageVC.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/02/29.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit
class BackupManageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    //전역변수 설정하기
    @IBOutlet var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingTableView.delegate = self
        self.settingTableView.dataSource = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        cell.title.text = "언어설정"
        return cell
    case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        cell.title.text = "일기데이터 내보내기"
        return cell
    case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellWithSwitch") as! SettingCellWithSwith
        cell.title.text = "아이클라우드 백업 활성화"
        return cell
    case 3:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellWithSwitch") as! SettingCellWithSwith
        cell.title.text = "아이클라우드 백업시 사진도 백업"
        return cell
    case 4:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        cell.title.text = "광고제거하기"
        return cell
    case 5:
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellWithSwitch") as! SettingCellWithSwith
        cell.title.text = "앱 잠금설정"
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
}
