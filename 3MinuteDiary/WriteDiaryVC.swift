//
//  WriteDiaryVC.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2019/12/27.
//  Copyright © 2019 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import FMDB

class WriteDiaryVC: UITableViewController{
    
    //여기 빈공간에다가는 변수들을 초기화하셈
    
        //db에서 일기을 읽어온 녀석을 저장할 변수
        //순서대로 create_date, moring, night, did_backup, data임
    var diaryData : [(String, Int, Int, Int, String)]!
    
        //diaryData내의 변수를 저장할 변수
    var create_date: String!
    var morning: Int!
    var night: Int!
    var did_backup: Int!
    var data: String!
        //이거는 전달받은 날짜 저장할 변수
    var sendedDate: Date?
    
        //JSON받을 변수(db의 data컬럼에 들어있는 정보)
    var jsonData: JSON!
    
        //일기의 data행에서 각 목록에 해당하는 정보를 저장할 변수
    var myObjective : String?
    var wantToDo : String?
    var whatHappened : String?
    var gratitude : String?
    var success : String?
    
        //db사용하기 위한 작업
    let diaryDAO = DiaryDAO()
     
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
    //db에서 main테이블을 읽어와서 diaryData에 저장해두고 이걸 바탕으로 셀을 만든다.
    
    //주의해야될 점은 findMain함수는 인자로 String값을 받는데 그 값으로 검색을 한다. 검색시에는 날짜의 형식이 년년년년-월월-일일 이므로 인자값에 넣어주기전에 형식변환을 하여 변환된 값을 넣어줘야 한다.
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
        //이해는 잘 안되지만 왜 toGlobalTime써줘야되는지 모르갓슴
    let writingDay = dateFormatter.string(from: (self.sendedDate?.toGlobalTime())!)
    print("writingDay : \(writingDay)")
    
    self.diaryData = self.diaryDAO.findMain(date: writingDay)
    
    //여기 아래에 들어가야 할 코드 : 읽어온 일기의 data열의 정보(json형식)를 읽어와 그 내용을 각 변수에 저장해야한다.---------------------------------------
    //self.create_date = self.diaryData.
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
        
        //날짜를 받은대로 출력하면 시분초까지 나오니까 원하는 포맷으로 설정하기
        
       
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd"
            //왠진모르겠지만 toGlobalTime안해주면...그냥 아무날짜 선택하지 않고 기본세팅 오늘날짜로 했을때 다음날짜가 일기쓰기 화면에 나옴...
        let date = dateFormatter.string(from: (self.sendedDate?.toGlobalTime())!)
        
        print("dateFromString : \(date)")
        cell.showDate.text = date
        
                   
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
    return 6
    }
//각 섹션 헤더에 들어갈 뷰를 정의하는 메소드. 섹션별 타이틀을 뷰 형태로 구성하는 메소드 1080
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "메뉴"
        case 1:
            return "나의 목표"
        case 2:
            return "하고싶은일"
        case 3:
            return "오늘 있었던일"
        case 4:
            return "감사할일"
        case 5:
            return "성공법칙"
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

//footer 사용하기 위한 것
    //footer를 지정하는 함수
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        //버튼을 하나 만들자
        
        switch section {
        case 1:
        let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
        button.setTitle("내용 추가하기", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonAction1), for: .touchUpInside)
        footerView.addSubview(button)
        
            return footerView
            
        case 2:
            let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
            button.setTitle("내용 추가하기", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
            
        case 3:
            let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
            button.setTitle("내용 추가하기", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction3), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
            
        case 4:
            let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
            button.setTitle("내용 추가하기", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction4), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
            
        case 5:
            let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
            button.setTitle("내용 추가하기", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction5), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
        
        
        default:
            let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
            button.setTitle("내용 추가하기", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction1), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
        }
    }
    
    //footer높이지정
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //메뉴바에는 푸터가 필요 없으니 푸터 높이를 0으로 지정하면 안나옴!
        if section == 0 {
            return 0
        }else{
            return 20
        }
    }
    //footer안의 버튼 누르면 사용될 함수
    @objc func buttonAction1(_ sender: UIButton!) {
        print("나의 목표 추가 tapped")
    }
    @objc func buttonAction2(_ sender: UIButton!) {
        print("하고싶은일 추가 tapped")
    }
    @objc func buttonAction3(_ sender: UIButton!) {
        print("오늘 있었던일 tapped")
    }
    @objc func buttonAction4(_ sender: UIButton!) {
        print("감사할일 tapped")
    }
    @objc func buttonAction5(_ sender: UIButton!) {
        print("성공법칙 tapped")
    }
    
    
}

