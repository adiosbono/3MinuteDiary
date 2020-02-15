//
//  TemplateManageVC.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/01/24.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class TemplateManageVC: UITableViewController{
    
    //userdefault사용하기위한 범주를 여기에 적어놓는다
        /*
        키           :   값
        myObjective : [String]배열
        wantToDo : [String]배열
        whatHappened : [String]배열
        gratitude : [String]배열
        success : [String]배열
     
     
     
        저장할땐 : UserDefaults.standard.set(status, forKey: "bloodLowAlarmStatus")
        
        읽어올땐 : let value = UserDefaults.standard.value(forKey: "bloodLowAlarmStatus")
        


        */
    
    
    //UserDefault사용하기 위한 작업
    let plist = UserDefaults.standard
    
    //여기 빈공간에다가는 변수들을 초기화하셈
        //수정버튼의 텍스트를 저장할 변수임
    var editText : String!
    var rightButton : UIButton!
    
    
        //템플릿 각 섹션별로 배열로 저장해놓기 위한 변수(UserDefault에 저장할때는 배열로 한방에 저장해야하기때문에 미리 모아두어야 함)
    var myObjective : [String]?
    var wantToDo : [String]?
    var whatHappened : [String]?
    var gratitude : [String]?
    var success : [String]?
    
override func viewDidLoad() {
    super.viewDidLoad()
    self.editText = (self.tableView.isEditing) ? "완료" : "편집"
    self.rightButton = UIButton(frame: CGRect(x: tableView.frame.size.width - 110, y: 15, width: 100, height: 20))
    self.rightButton.setTitle("편집", for: .normal)
    
    
    //UserDefault에 테스트를 위해 기본적인 템플릿 내용을 강제로 집어넣는다.
        //더미데이터를 둔다
    let tempMyObjective = ["목표템플릿1", "목표템플릿2"]
    let tempWantToDo = ["할일템플릿1", "할일템플릿2"]
    let tempWhatHappened = ["일어난일템플릿1일어난일템플릿2일어난일템플릿3일어난일템플릿4일어난일템플릿5일어난일템플릿6일어난일템플릿7일어난일템플릿8일어난일템플릿9일어난일템플릿10일어난일템플릿11일어난일템플릿12일어난일템플릿13일어난일템플릿14일어난일템플릿15", "두번째줄일어난일템플릿12345678910"]
    let tempGratitude = ["감사템플릿1","감사템플릿2","감사템플릿3"]
    let tempSuccess = ["성공법칙템플릿1","성공법칙템플릿2"]
        //더미데이터를 userdefault에 집어넣는다.
    plist.set(tempMyObjective, forKey: "myObjective")
    plist.set(tempWantToDo, forKey: "wantToDo")
    plist.set(tempWhatHappened, forKey: "whatHappened")
    plist.set(tempGratitude, forKey: "gratitude")
    plist.set(tempSuccess, forKey: "success")
    
    //UserDefault로부터 데이터를 읽어와 전역변수에 대입한다.
    if let temp1 = plist.array(forKey: "myObjective"){
        self.myObjective = temp1 as? [String]
        print("plist성공myObjective")
    }else{
        print("plist에서 myObjective를 읽어오는데 실패했습니다.")
    }
    
    if let temp2 = plist.array(forKey: "wantToDo"){
        self.wantToDo = temp2 as? [String]
        print("plist성공wantToDo")
    }else{
        print("plist에서 wantToDo를 읽어오는데 실패했습니다")
    }
    
    if let temp3 = plist.array(forKey: "whatHappened"){
        self.whatHappened = temp3 as? [String]
        print("plist성공 whatHappened")
    }else{
        print("plist에서 whatHappened 읽어오는데 실패했습니다")
    }
    
    if let temp4 = plist.array(forKey: "gratitude"){
        self.gratitude = temp4 as? [String]
        print("plist성공 gratitude")
    }else{
        print("plist에서 gratitude 읽어오는데 실패")
    }
    
    if let temp5 = plist.array(forKey: "success"){
        self.success = temp5 as? [String]
        print("plist성공 success")
    }else{
        print("plist에서 success 읽어오는거 실패")
    }
    
}
    
//화면이 나타날때마다 호출되는 메소드
override func viewWillAppear(_ animated: Bool) {
    self.tableView.reloadData()
}
//테이블 행의 개수를 결정하는 메소드
        //userdefault에서 현재 템플릿을 읽어와서 그 갯수를 행마다 return해줘야 함 현재는 그냥 하드코딩해놈
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section{
    case 0:
        return 1
    case 1:
        return self.myObjective?.count ?? 1
    case 2:
        return self.wantToDo?.count ?? 1
    case 3:
        return self.whatHappened?.count ?? 1
    case 4:
        return self.gratitude?.count ?? 1
    case 5:
        return self.success?.count ?? 1
    default:
        print("numberOfRowsInSection에서 디폴드값 사용됨")
        return 1
    }
    
}

//테이블 행을 구성하는 메소드
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
        
    case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "templateMenuCell") as! TemplateMenuCell
        
        
        
        let leftButton = UIButton(frame: CGRect(x: 10, y: 15, width: 100, height: 20))
        leftButton.setTitle("오늘부터 반영", for: .normal)
        leftButton.setTitleColor(.blue, for: .normal)
        leftButton.addTarget(self, action: #selector(applyToday), for: .touchUpInside)
        cell.addSubview(leftButton)
        
        let middleText = UILabel(frame: CGRect(x: tableView.frame.size.width/2 - 50 , y: 15, width: 100, height: 20))
        middleText.text = "템플릿관리"
        cell.addSubview(middleText)
        
        //edit버튼임
        self.rightButton.setTitleColor(.blue, for: .normal)
        self.rightButton.addTarget(self, action: #selector(edit1), for: .touchUpInside)
        cell.addSubview(rightButton)
        
        return cell
        
    case 1 :
        let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
        //여기에 셀 안에 들어갈 내용을 입력한다.
        cell.textBody.text = self.myObjective?[indexPath.row]
        return cell
        
    case 2 :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    cell.textBody.text = self.wantToDo?[indexPath.row]
    return cell
        
    case 3 :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    cell.textBody.text = self.whatHappened?[indexPath.row]
    return cell
        
    case 4 :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    cell.textBody.text = self.gratitude?[indexPath.row]
    return cell
        
    case 5 :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    cell.textBody.text = self.success?[indexPath.row]
    return cell
        
    default :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    return cell
        
    }
    
}
    
    //테이블뷰의 각 행의 에디팅 가능한지 불가능한지를 여기서 설정할수 있다
        //이게 왜필요하냐면 에디트 버튼 누르면 맨 위의 메뉴셀까지 에디트들어가지므로 메뉴셀을 삭제해버릴수 있기 때문(대략난감) 보기도 안좋고
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch indexPath.section {
        case 0 :
            return .none
        default :
            return .delete
        }
    }
//테이블의 특정 행이 선택되었을때 호출되는 메소드
    /*
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
 */
//테이블 뷰의 섹션의 수 결정하는 메소드 따로 오버라이드 하지 않으면 기본값은 1임
override func numberOfSections(in tableView: UITableView) -> Int {
    return 6
}
    

//각 섹션 헤더에 들어갈 뷰를 정의하는 메소드. 섹션별 타이틀을 뷰 형태로 구성하는 메소드 1080
override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
    
    switch section {
    case 1:
        //왼쪽에 들어갈 텍스트
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
        label.text = "나의 목표"
        headerView.addSubview(label)
        
            return headerView
        
    case 2:
    //왼쪽에 들어갈 텍스트
    let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
    label.text = "하고싶은일"
    headerView.addSubview(label)
    
        return headerView
        
    case 3:
    //왼쪽에 들어갈 텍스트
    let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
    label.text = "오늘 있었던일"
    headerView.addSubview(label)
    
        return headerView
        
    case 4:
    //왼쪽에 들어갈 텍스트
    let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
    label.text = "감사할일"
    headerView.addSubview(label)
    
        return headerView
        
    case 5:
    //왼쪽에 들어갈 텍스트
    let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
    label.text = "성공법칙"
    headerView.addSubview(label)
    
        return headerView
        
    default :
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
        label.text = "default"
        headerView.addSubview(label)
        
            return headerView
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
            button.setTitle("default", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction1), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
        }
    }
    
    //footer높이지정
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //메뉴바에는 푸터가 필요 없으니 푸터 높이를 0으로 지정하면 안나옴!
        switch section {
        case 0:
            return 0.0
        default:
            return 20.0
        }
    }
    //footer안의 버튼 누르면 사용될 함수
    @objc func buttonAction1(_ sender: UIButton!) {
        print("템플릿 나의 목표 추가 tapped")
    }
    @objc func buttonAction2(_ sender: UIButton!) {
        print("템플릿 하고싶은일 추가 tapped")
    }
    @objc func buttonAction3(_ sender: UIButton!) {
        print("템플릿 오늘 있었던일 tapped")
    }
    @objc func buttonAction4(_ sender: UIButton!) {
        print("템플릿 감사할일 tapped")
    }
    @objc func buttonAction5(_ sender: UIButton!) {
        print("템플릿 성공법칙 tapped")
    }
    
    //메뉴왼쪽의 오늘부터 반영 버튼 누르면 사용될 함수
    @objc func applyToday(_ sender: UIButton!) {
        print("오늘부터 적용")
    }
    
    @objc func edit1(_ sender: UIButton!) {
        print("에디트버튼 터치됨")
        self.tableView.isEditing = !self.tableView.isEditing
        self.editText = (self.tableView.isEditing) ? "완료" : "편집"
        sender.setTitle(self.editText, for: .normal)
    }
}
