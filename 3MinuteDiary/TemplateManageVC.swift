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
    
    //여기 빈공간에다가는 변수들을 초기화하셈
    
    
override func viewDidLoad() {
    super.viewDidLoad()
}
    
//화면이 나타날때마다 호출되는 메소드
override func viewWillAppear(_ animated: Bool) {
    self.tableView.reloadData()
}
//테이블 행의 개수를 결정하는 메소드
        //userdefault에서 현재 템플릿을 읽어와서 그 갯수를 행마다 return해줘야 함 현재는 그냥 하드코딩해놈
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
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
        
        let rightButton = UIButton(frame: CGRect(x: tableView.frame.size.width - 110, y: 15, width: 100, height: 20))
        rightButton.setTitle("수정하기", for: .normal)
        rightButton.setTitleColor(.blue, for: .normal)
        rightButton.addTarget(self, action: #selector(edit), for: .touchUpInside)
        cell.addSubview(rightButton)
        
        return cell
        
    case 1 :
        let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
        //여기에 셀 안에 들어갈 내용을 입력한다.
        return cell
        
    case 2 :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    return cell
        
    case 3 :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    return cell
        
    case 4 :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    return cell
        
    case 5 :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    return cell
        
    default :
    let cell = tableView.dequeueReusableCell(withIdentifier: "templateBodyCell") as! TemplateBodyCell
    //여기에 셀 안에 들어갈 내용을 입력한다.
    return cell
        
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
    
    @objc func edit(_ sender: UIButton!) {
        print("에디트버튼 터치됨")
    }
}
