//
//  AlarmCell.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/06/14.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class AlarmCell: UITableViewCell {
    //화면전환을 위해 viewController의 storyboard를 사용하기 위해 viewController를 받아주는 변수마련함
    var originVC: AlarmSettingVC?
    //맨위 하고싶은일 내용들어갈 레이블
    @IBOutlet var wantToDo: UILabel!
    //시각을 크게 보여주는 레이블
    @IBOutlet var TimeText: UILabel!
    
    //시각수정하기버튼 텍스트 현지화 위해서...
    @IBOutlet var changeTimeText: UIButton!
    //시각수정하기 버튼 눌렸을때 실행될 함수
    @IBAction func changeTime(_ sender: UIButton) {
        print("시각수정하기 버튼 터치됨")
        //버튼이 속한 테이블뷰셀의 정보를 받는다.
        var superTableViewCell: UITableViewCell?{
            //슈펴뷰 두번쓴 이유 : 바로위의것은 컨텐츠뷰였고 거기서 한단계 더 가야 테이블뷰셀나옴
            return sender.superview?.superview as? UITableViewCell
        }
        //원하는녀석으로 캐스팅
        let tempTableViewCell = superTableViewCell as! AlarmCell
        //하고싶은일 정보를 얻는다.
        let tempWantToDo = tempTableViewCell.wantToDo.text //리턴값은 옵셔널이다
        print("하고싶은일 추출 : \(tempWantToDo)")
        
        //화면을 present 방식으로 전환하면서 하고싶은일을 대입해준다
        let uvc = originVC?.storyboard!.instantiateViewController(withIdentifier: "alarmTimeSetVC") as! AlarmTimeSetVC //에러난 이유는 self가 viewController가 아니기 때문임... 이걸 받아오면 됨.
        uvc.originVC = originVC
        uvc.tempTableViewCell = tempTableViewCell
        uvc.wantToDo = tempWantToDo
        //드디어 화면전환 실시
        self.originVC?.present(uvc, animated: true, completion: nil)
    }
    //맨오른쪽 토글온오프스위치 눌렸을때 실행될 함수
    @IBAction func toggleSwitch(_ sender: UISwitch) {
        print("토글스위치 눌림")
        //버튼이 속한 테이블뷰셀의 정보를 받는다.
        var superTableViewCell: UITableViewCell?{
            //슈펴뷰 두번쓴 이유 : 바로위의것은 컨텐츠뷰였고 거기서 한단계 더 가야 테이블뷰셀나옴
            return sender.superview?.superview as? UITableViewCell
        }
        //원하는녀석으로 캐스팅
        let tempTableViewCell = superTableViewCell as! AlarmCell
        //하고싶은일 정보를 얻는다.
        let tempWantToDo = tempTableViewCell.wantToDo.text //리턴값은 옵셔널이다
        print("하고싶은일 추출 : \(tempWantToDo)")
        //스위치가 on인지 off인지 확인하기
        if self.toggleSW.isOn == true {//on인 경우 : 알람을 등록해야 한다.
            print("toggleSW is on")
        }else{//off인 경우 : 알람을 해제해야 한다
            print("toggleSW is off")
            //originVC(AlarmSettingVC)를 이용하여 알람제거하는 함수 호출한다
            self.originVC?.userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [tempWantToDo!])
            print("알람제거완료")
            //셀에서 보이는 시각을 00:00 으로 바꿔버린다.
            self.TimeText.text = "00:00"
            //switch를 disable한다
            self.toggleSW.isEnabled = false
        }
    }
    @IBOutlet var toggleSW: UISwitch!
    
}
