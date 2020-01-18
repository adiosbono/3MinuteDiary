//
//  WriteDiaryVC.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2019/12/27.
//  Copyright © 2019 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class WriteDiaryVC: UITableViewController{
    
    //여기 빈공간에다가는 변수들을 초기화하셈
    
        //이거는 전달받은 날짜 저장할 변수
    var sendedDate: Date?
     
        //맨위의 저장버튼과 취소버튼임
    @IBAction func cancelButton(_ sender: UIButton) {
        print("cancelBtn2")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: UIButton) {
        print("saveBtn2")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
     
     
override func viewDidLoad() {
    super.viewDidLoad()
    print("sended date : \(self.sendedDate!)")
    
    }
    
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
    switch indexPath.section {
    case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "toolBarCell") as! ToolBarCell
        
        cell.showDate.text = "\(self.sendedDate!)"
        
                   
                   //여기안에 디비에서 받아온 정보를 가지고 각 셀 안의 데이터를 입력해준다.
                   
                   
        
                   return cell
        
    case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
                   
                   //여기안에 디비에서 받아온 정보를 가지고 각 셀 안의 데이터를 입력해준다.
                   
                   
        
                   return cell
    default:
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
        
                   //여기안에 디비에서 받아온 정보를 가지고 각 셀 안의 데이터를 입력해준다.
                   
                   
        
                   return cell
    }
    }
//테이블의 특정 행이 선택되었을때 호출되는 메소드
    /*
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
 */
//테이블 뷰의 섹션의 수 결정하는 메소드 따로 오버라이드 하지 않으면 기본값은 1임
override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
    }
//각 섹션 헤더에 들어갈 뷰를 정의하는 메소드. 섹션별 타이틀을 뷰 형태로 구성하는 메소드 1080
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "메뉴"
        case 1:
            return "별칭"
        case 2:
            return "메모"
        case 3:
            return "카드사용조건"
        case 4:
            return "상점명"
        case 5:
            return "혜택"
        case 6:
            return "제약"
        default:
            return "eat my shorts"
        }
    }
//각 섹션 헤더의 높이를 결정하는 메소드
override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch section {
    case 0:
        return 0.0
    default:
        return 20.0
    }
    }

}

