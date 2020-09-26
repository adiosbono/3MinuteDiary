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
}
