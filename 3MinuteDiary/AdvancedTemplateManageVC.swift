//
//  AdvancedTemplateManageVC.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/02/16.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit
class AdvancedTemplateManageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate  {
    
    
    
    //각종 변수 초기화를 여기서 하면 됨
    
        //사용자가 템플릿을 만들기 위해 입력한 값을 임시로 저장해놀 변수
    var userInput = ""
    
        //각 indexPath를 키로 하고 행의 높이를 값으로 하는 딕셔너리를 저장할 변수
    var heightForCell = [IndexPath : CGFloat]()
    
        //항목추가하기 버튼 눌러서 새로 생긴 셀(TemplateAddCell)의 텍스트뷰 높이를 저장할 변수
    var addCellTextViewHeight: CGFloat = 0
    
        //얼마나 높이가 높아졌는지 저장할 변수
    var diffHeight: CGFloat = 0
        //최근에 추가한 곳의 인덱스를 저장하기 위한 변수
    var insertIndexPath : IndexPath!
        //푸터의 버튼(항목추가하기)누르면 토글이 되는 변수를 선언한다. 기본값은 false
    var forAdd = false
        //푸터의 버튼 눌었을때 어느 섹션을 눌렀는지 확인하기 위한 변수임
        //이 변수는 userDefault에 저장이 완료 된 뒤에 false로 바뀐다.
        //정말 주의해야할 것은 입력이 완료되지 않은 상태에서 다른 화면으로 넘어가버린 경우에는 이게 false로 바뀌어야 하고 셀도 추가하다 만거는 안보이게 해놔야 한다.
    var section0 = false
    var section1 = false
    var section2 = false
    var section3 = false
    var section4 = false
    
        //오늘부터 반영 버튼
    @IBAction func applyToday(_ sender: UIButton) {
        print("오늘부터 반영 클릭됨")
        //여기에는 오늘 작성했던 일기의 내용을 모두 지워서 아무 일기도 안쓴걸로 만들면 된다.
        //팝업도 띄워서 '오늘 미리 작성해두었던 일기가 삭제됩니다. 진행하시겠습니까?' 네 아니오 팝업뜨게 한다.
    }
        //편집버튼
    
    
    @IBOutlet var editButtonOutlet: UIButton!
    
    @IBAction func editButton(_ sender: UIButton) {
        print("편집버튼 클릭됨")
        self.myTableView.isEditing = !self.myTableView.isEditing
        self.editText = (self.myTableView.isEditing) ? "완료" : "편집"
        sender.setTitle(self.editText, for: .normal)
        self.myTableView.reloadData()
    }
    
    //키보드 작동 함 좀 느린거같은느낌적인느낌? dnbonobonobononb영어는 제대로 되네
    //self.tableView.isEditing = !self.tableView.isEditing
        //self.editText = (self.tableView.isEditing) ? "완료" : "편집"
        //sender.setTitle(self.editText, for: .normal)
    
    
        //테이블뷰
    @IBOutlet var myTableView: UITableView!
    
        //테이블 셀의 높이를 저장해놀 변ㅅ
        //이거는 이제 곧 사라질 운명임(딕셔너리로 해결할 예정임)
    //var heightRow: CGFloat!
    
        //UserDefault사용하기 위한 작업
    let plist = UserDefaults.standard
    
        //여기 빈공간에다가는 변수들을 초기화하셈
       
    var editText : String!
    
    
        //템플릿 각 섹션별로 배열로 저장해놓기 위한 변수(UserDefault에 저장할때는 배열로 한방에 저장해야하기때문에 미리 모아두어야 함)
    var myObjective : [String]?
    var wantToDo : [String]?
    var whatHappened : [String]?
    var gratitude : [String]?
    var success : [String]?
    

    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad실행됨")
        
       
        //내용입력할때 키보드 높이만큼 화면을 이동해야하는 경우 있으므로 그때 사용하기위한 작업
        //selelctor인자에 들어있는 함수는 저 아래에 있음...
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
        
        
        //테이블뷰 딜리게이트 설정
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //완료 편집을 토글할 텍스트
        self.editText = (self.myTableView.isEditing) ? "완료" : "편집"
        
        
        //UserDefault에 테스트를 위해 기본적인 템플릿 내용을 강제로 집어넣는다.
            //더미데이터를 둔다
        /*
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
        */
        
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
        print("viewWillAppear 함수 호출됨")
        
        //테이블뷰의 길이를 재조정해주어야 함. 계속 늘어남.....
        
        //이거는 다른화면에서 넘어올때 이 함수 호출되므로 확인차 다시 불러와주는거임
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
        
        self.myTableView.reloadData()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        //아래 코드가 제대로 작동하지 않는다면 object에 nil을 넣어볼것
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification , object: self.view.window)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification , object: self.view.window)
    }
    
    
    //테이블 행의 개수를 결정하는 메소드
    //userdefault에서 현재 템플릿을 읽어와서 그 갯수를 행마다 return해줘야 함
        //전역변수 섹션의 값을 검사해서 이게 true이면 행을 추가하고있다는 소리이므로 그 해당하는 섹션에 대한 리턴 값에 +1을 해주어야함
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            let allZero = ((self.myObjective == nil) && (self.wantToDo == nil) && (self.whatHappened == nil) && (self.gratitude == nil) && (self.success == nil)) ? 1 : 0 //allZero는 모든값이 nil일때 1이다 다른말로하자면 하나라도 값을 제대로 가지고 있으면 0이다
            if self.section0 {
            return (self.myObjective?.count ?? allZero) + 1 //왜 이 케이스 안의 값들은 ?? 다음 1이 오는지 궁금한가? 적어도 1개는 만들어지게끔 해논것이다.
            }else{
            return self.myObjective?.count ?? allZero
            }
        case 1:
            if self.section1 {
                return (self.wantToDo?.count ?? 0) + 1
            }else{
            return self.wantToDo?.count ?? 0
            }
        case 2:
            if self.section2 {
                return (self.whatHappened?.count ?? 0) + 1
            }else{
            return self.whatHappened?.count ?? 0
            }
        case 3:
            if self.section3 {
                return (self.gratitude?.count ?? 0) + 1
            }else{
            return self.gratitude?.count ?? 0
            }
        case 4:
            if self.section4 {
                return (self.success?.count ?? 0) + 1
            }else{
            return self.success?.count ?? 0
            }
        default:
            print("numberOfRowsInSection에서 디폴드값 사용됨")
            return 1
        }
    }
    
    //테이블 행의 높이
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /*
        if let cell = tableView.cellForRow(at: indexPath){
        let ccell = cell as! TemplateBodyCell
        print("방금 제출한 셀 (섹션 : \(indexPath.section), 행 : \(indexPath.row)이고 반환한 높이는 \(ccell.main.frame.size.height + 20)")
            return ccell.main.frame.size.height + 20
        }else{
            print("cell값이 nil이엇슴 반환된값:\(UITableView.automaticDimension)")
            return UITableView.automaticDimension
        }
 */
        print("heightforrowat에서 현재 셀 (섹션 : \(indexPath.section), 행 : \(indexPath.row))작업중")
        //print("현재 셀 높이 : \(self.heightForCell[indexPath])")
        
        return self.heightForCell[indexPath] ?? 44.0
        
    }
 


    //테이블 행을 구성하는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //forAdd값을 검사하여 true면 행추가를 위한 TemplateAddCell을 반환하도록 하고 false라면 TemplateBodyCell을 반환하도록 한다.
        if self.forAdd == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addBody") as! TemplateAddCell
            
            //맨처음에 아무 텍스트도 안들어가 잇도록 일부러 빈 값을 넣어준다(원래아무것도 안들어있긴 하지만 연속해서 두번 셀 추가할때엔 저번에 입력한 값이 바로 뜨드라...셀재활용 메커니즘때문인듯)
            cell.addTextView.text = ""
            
            cell.addTextView.frame.size.width = tableView.frame.size.width - 40
            self.heightForCell[indexPath] = cell.addTextView.frame.size.height
            
            //기존 셀의 높이를 전역변수인 addCellTextViewHeight에 저장해둔다.
                //addTextView.frame.size.height가 아닌 이유는 델리게이트 메서드에서 아래에 쓴 걸로 값 비교를 할 것이기 때문이다.
            self.addCellTextViewHeight = cell.addTextView.contentSize.height
            
            print("frame.size.height : \(cell.addTextView.frame.size.height), contentSize.height : \(cell.addTextView.contentSize.height)")
            
            //텍스트뷰 딜리게이트 설정
            cell.addTextView.delegate = self
            
            //키보드 위에 done 버튼 넣는 작업임
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAction))
            let cancel: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelButtonAction))
            
            let items = [cancel, flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            
            cell.addTextView.inputAccessoryView = doneToolbar
            
            self.forAdd = false
            
            return cell
        }else{
        
        switch indexPath.section {
            
        case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "body") as! TemplateBodyCell
            //여기에 셀 안에 들어갈 내용을 입력한다.
        //프로그래밍 방식을 이용하여 텍스트뷰를 만들고 이를 서브뷰로 넣은다음 cell에서 sizetofit을 호출하면 제대로 될지 확인해보자
        /*
        let myTextView = UITextView()
        myTextView.frame.size
        */
        
            //바로 아래줄에서 self.myObjective를 읽어올 수 없는 경우 "편집버튼을 눌러 템플릿 내용을 추가해 주세요" 라는 글이 들어가게 되어있다. 여기를 조건분기를 해서 모든 self.wantToDO 기타 모든 녀석들을 읽어 올 수 없는 경우로 만들어야 한다.(numberOfRowsInSection에도 동일한 로직 적용해서 셀 수도 맞춰줘야겠다)
        cell.main.text = self.myObjective?[indexPath.row] ?? "편집버튼을 눌러 템플릿 내용을 추가해 주세요"
        //cell.main.translatesAutoresizingMaskIntoConstraints = true
        cell.main.isScrollEnabled = false
        cell.main.sizeToFit()
        cell.sizeToFit()
        
        print("현재 (섹션 : \(indexPath.section), 행 : \(indexPath.row))이고 텍스트뷰 높이는 \(cell.main.frame.size.height)이고 셀 높이는 \(cell.frame.size.height)")
        
        cell.main.frame.size.width = tableView.frame.size.width - 40
        
        self.heightForCell[indexPath] = cell.main.frame.size.height
            return cell
            
        case 1 :
        let cell = tableView.dequeueReusableCell(withIdentifier: "body") as! TemplateBodyCell
            //여기에 셀 안에 들어갈 내용을 입력한다.
            cell.main.text = self.wantToDo?[indexPath.row]
        //cell.main.translatesAutoresizingMaskIntoConstraints = true
        cell.main.isScrollEnabled = false
        cell.main.sizeToFit()
        cell.sizeToFit()
        print("현재 (섹션 : \(indexPath.section), 행 : \(indexPath.row))이고 텍스트뷰 높이는 \(cell.main.frame.size.height)이고 셀 높이는 \(cell.frame.size.height)")
        cell.main.frame.size.width = tableView.frame.size.width - 40
    self.heightForCell[indexPath] = cell.main.frame.size.height
            return cell
            
        case 2 :
        let cell = tableView.dequeueReusableCell(withIdentifier: "body") as! TemplateBodyCell
        //여기에 셀 안에 들어갈 내용을 입력한다.
        cell.main.text = self.whatHappened?[indexPath.row]
        //cell.main.translatesAutoresizingMaskIntoConstraints = true
        cell.main.isScrollEnabled = false
        cell.main.sizeToFit()
        cell.sizeToFit()
        print("현재 (섹션 : \(indexPath.section), 행 : \(indexPath.row))이고 텍스트뷰 높이는 \(cell.main.frame.size.height)이고 셀 높이는 \(cell.frame.size.height)")
        cell.main.frame.size.width = tableView.frame.size.width - 40
        self.heightForCell[indexPath] = cell.main.frame.size.height
        return cell
            
        case 3 :
        let cell = tableView.dequeueReusableCell(withIdentifier: "body") as! TemplateBodyCell
        //여기에 셀 안에 들어갈 내용을 입력한다.
        cell.main.text = self.gratitude?[indexPath.row]
        //cell.main.translatesAutoresizingMaskIntoConstraints = true
        cell.main.isScrollEnabled = false
        cell.main.sizeToFit()
        cell.sizeToFit()
        
        print("현재 (섹션 : \(indexPath.section), 행 : \(indexPath.row))이고 텍스트뷰 높이는 \(cell.main.frame.size.height)이고 셀 높이는 \(cell.frame.size.height)")
        cell.main.frame.size.width = tableView.frame.size.width - 40
        self.heightForCell[indexPath] = cell.main.frame.size.height
        return cell
            
        case 4 :
        let cell = tableView.dequeueReusableCell(withIdentifier: "body") as! TemplateBodyCell
        //여기에 셀 안에 들어갈 내용을 입력한다.
        cell.main.text = self.success?[indexPath.row]
        //cell.main.translatesAutoresizingMaskIntoConstraints = true
        cell.main.isScrollEnabled = false
        cell.main.sizeToFit()
        cell.sizeToFit()
        
        print("현재 (섹션 : \(indexPath.section), 행 : \(indexPath.row))이고 텍스트뷰 높이는 \(cell.main.frame.size.height)이고 셀 높이는 \(cell.frame.size.height)")
        cell.main.frame.size.width = tableView.frame.size.width - 40
        self.heightForCell[indexPath] = cell.main.frame.size.height
        return cell
            
        default :
        let cell = tableView.dequeueReusableCell(withIdentifier: "addBody") as! TemplateAddCell

        //여기에 셀 안에 들어갈 내용을 입력한다.
        return cell
            
            }
        }
    }

    
    //테이블뷰의 각 행의 에디팅 가능한지 불가능한지를 여기서 설정할수 있다
        //이게 왜필요하냐면 에디트 버튼 누르면 맨 위의 메뉴셀까지 에디트들어가지므로 메뉴셀을 삭제해버릴수 있기 때문(대략난감) 보기도 안좋고
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch indexPath.section {
        default :
            return .delete
        }
    }
    
    //테이블 뷰의 섹션의 수 결정하는 메소드 따로 오버라이드 하지 않으면 기본값은 1임
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    //각 섹션 헤더에 들어갈 뷰를 정의하는 메소드. 섹션별 타이틀을 뷰 형태로 구성하는 메소드 1080
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        headerView.backgroundColor = .quaternarySystemFill
        
        switch section {
        case 0:
            //왼쪽에 들어갈 텍스트
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
            label.text = "나의 목표"
            //label.backgroundColor = .quaternarySystemFill
            headerView.addSubview(label)
            
                return headerView
            
        case 1:
        //왼쪽에 들어갈 텍스트
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
        label.text = "하고싶은일"
        headerView.addSubview(label)
        
            return headerView
            
        case 2:
        //왼쪽에 들어갈 텍스트
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
        label.text = "오늘 있었던일"
        headerView.addSubview(label)
        
            return headerView
            
        case 3:
        //왼쪽에 들어갈 텍스트
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.size.width - 20, height: 20))
        label.text = "감사할일"
        headerView.addSubview(label)
        
            return headerView
            
        case 4:
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        default:
            return 20.0
        }
    }
 
    //footer 사용하기 위한 것
    //footer를 지정하는 함수
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        //버튼을 하나 만들자
        
        switch section {
        case 0:
        let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
        button.setTitle("내용 추가하기", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(buttonAction1), for: .touchUpInside)
        footerView.addSubview(button)
        
            return footerView
            
        case 1:
            let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
            button.setTitle("내용 추가하기", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
            
        case 2:
            let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
            button.setTitle("내용 추가하기", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction3), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
            
        case 3:
            let button = UIButton(frame: CGRect(x: tableView.frame.size.width/2 - 50, y: 0, width: 100, height: 20))
            button.setTitle("내용 추가하기", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(buttonAction4), for: .touchUpInside)
            footerView.addSubview(button)
            
            return footerView
            
        case 4:
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //메뉴바에는 푸터가 필요 없으니 푸터 높이를 0으로 지정하면 안나옴!
        
        if self.myTableView.isEditing == true {
            return 20.0
            
        }else{
            return 0.0
            
        }
        /*
        switch section {
        default:
            return 20.0
        }
 */
    }
    
    //테이블뷰가 에디트모드일때 들여쓰기처럼 모든셀이 움직이게끔 할지 말지 결정하는 것//작동안함
    /*
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    */
    
    //footer안의 버튼 누르면 사용될 함수
    @objc func buttonAction1(_ sender: UIButton!) {
        print("템플릿 나의 목표 추가 tapped")
        self.forAdd = true
        self.section0 = true
        
        //편집모드를 해제한다.
        self.myTableView.isEditing = false
        self.editText = (self.myTableView.isEditing) ? "완료" : "편집"
        //완료라고 되어있는 텍스트를 편집으로 바꾼다.
        self.editButtonOutlet.setTitle(self.editText, for: .normal)
        
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.myTableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.myObjective?.count ?? 0, section: 0)
        self.insertIndexPath = insertIndexPath
        self.myTableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.myTableView.endUpdates()
        
        
        
        let newCell = self.myTableView.cellForRow(at: insertIndexPath) as! TemplateAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
        
    }
    @objc func buttonAction2(_ sender: UIButton!) {
        print("템플릿 하고싶은일 추가 tapped")
        self.forAdd = true
        self.section1 = true
        
        //편집모드를 해제한다.
        self.myTableView.isEditing = false
        self.editText = (self.myTableView.isEditing) ? "완료" : "편집"
        //완료라고 되어있는 텍스트를 편집으로 바꾼다.
        self.editButtonOutlet.setTitle(self.editText, for: .normal)
        
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.myTableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.wantToDo?.count ?? 0, section: 1)
        self.insertIndexPath = insertIndexPath
        self.myTableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.myTableView.endUpdates()
        
        
        
        let newCell = self.myTableView.cellForRow(at: insertIndexPath) as! TemplateAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
    }
    @objc func buttonAction3(_ sender: UIButton!) {
        print("템플릿 오늘 있었던일 tapped")
        self.forAdd = true
        self.section2 = true
        
        //편집모드를 해제한다.
        self.myTableView.isEditing = false
        self.editText = (self.myTableView.isEditing) ? "완료" : "편집"
        //완료라고 되어있는 텍스트를 편집으로 바꾼다.
        self.editButtonOutlet.setTitle(self.editText, for: .normal)
        
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.myTableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.whatHappened?.count ?? 0, section: 2)
        self.insertIndexPath = insertIndexPath
        self.myTableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.myTableView.endUpdates()
        
        
        
        let newCell = self.myTableView.cellForRow(at: insertIndexPath) as! TemplateAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
    }
    @objc func buttonAction4(_ sender: UIButton!) {
        print("템플릿 감사할일 tapped")
        self.forAdd = true
        self.section3 = true
        
        //편집모드를 해제한다.
        self.myTableView.isEditing = false
        self.editText = (self.myTableView.isEditing) ? "완료" : "편집"
        //완료라고 되어있는 텍스트를 편집으로 바꾼다.
        self.editButtonOutlet.setTitle(self.editText, for: .normal)
        
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.myTableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.gratitude?.count ?? 0, section: 3)
        self.insertIndexPath = insertIndexPath
        self.myTableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.myTableView.endUpdates()
        
        
        
        let newCell = self.myTableView.cellForRow(at: insertIndexPath) as! TemplateAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
    }
    @objc func buttonAction5(_ sender: UIButton!) {
        print("템플릿 성공법칙 tapped")
        self.forAdd = true
        self.section4 = true
        
        //편집모드를 해제한다.
        self.myTableView.isEditing = false
        self.editText = (self.myTableView.isEditing) ? "완료" : "편집"
        //완료라고 되어있는 텍스트를 편집으로 바꾼다.
        self.editButtonOutlet.setTitle(self.editText, for: .normal)
        
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.myTableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.success?.count ?? 0, section: 4)
        self.insertIndexPath = insertIndexPath
        self.myTableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.myTableView.endUpdates()
        
        
        
        let newCell = self.myTableView.cellForRow(at: insertIndexPath) as! TemplateAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
    }
    
    //텍스트뷰의 내용 변할때마다 호출될 딜리게이트함수임(한글짜변해도 호출됨)..
    func textViewDidChange(_ textView: UITextView) {
        
        //변화된 내용을 전역변수에 저장한다
        self.userInput = textView.text
        //높이변화를 감지한다.
        if self.addCellTextViewHeight == textView.contentSize.height{
            print("텍스트뷰 높이 변화 없음")
        }else{
            print("텍스트뷰 높이 변화됨")
            //바뀐 높이값을 계산한다. 바뀐 높이가 길어졌으면 양수, 바뀐 높이가 짧아졋으면 음수가 나올 것이다.
            let diff = textView.contentSize.height - self.addCellTextViewHeight
            print("diff : \(diff)")
            //변화된 높이를 전역변수에 집어넣는다.(이걸 다시 기준으로 써야하기 때문이다)
            self.addCellTextViewHeight = textView.contentSize.height
            //셀 높이를 늘린다.
            self.diffHeight = diff
            
            self.heightForCell[self.insertIndexPath]! += diff
            
            self.myTableView.beginUpdates()
            self.myTableView.endUpdates()
        }
    }
    
    //MARK: 에디트모드에서 에디트실행시 어떻게 작업할건지 정하는 메소드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            //삭제 로직 구현
                //UserDefault사용위한 구문 작성
            let plist = UserDefaults.standard
                //첫째론 전역변수에 저장한 목록을 불러와 삭제할녀석을 빼고 그녀석을 userDefault에 덮어쓰기해서 UserDefault에서 삭제하는것
                //둘째론 화면상에 보이는 셀을 없애는것 이는 화면에 표출할 리스트에서 해당 항목 빼고 테이블 리후레시 하면 될듯
            switch indexPath.section {
            case 0:
                
                //일단 전역변수로 해당 섹션의 리스트를 가지고 있는 녀석을 불러온다. 그리고 수정한 뒤 수정한 녀셕을 userdefualt에 집어넣는다.
                var temp = self.myObjective
                temp?.remove(at: indexPath.row)
                plist.set(temp, forKey: "myObjective")
                plist.synchronize()
                //혹시모르니 전역변수의 해당데이터도 삭제해준다.
                self.myObjective?.remove(at: indexPath.row)
                //userdefault에 동기화를 마쳤으니 테이블뷰를 리후레시한다.
                self.myTableView.reloadData()
            case 1:
                //일단 전역변수로 해당 섹션의 리스트를 가지고 있는 녀석을 불러온다. 그리고 수정한 뒤 수정한 녀셕을 userdefualt에 집어넣는다.
                var temp = self.wantToDo
                temp?.remove(at: indexPath.row)
                plist.set(temp, forKey: "wantToDo")
                plist.synchronize()
                //혹시모르니 전역변수의 해당데이터도 삭제해준다.
                self.wantToDo?.remove(at: indexPath.row)
                //userdefault에 동기화를 마쳤으니 테이블뷰를 리후레시한다.
                self.myTableView.reloadData()
            case 2:
                //일단 전역변수로 해당 섹션의 리스트를 가지고 있는 녀석을 불러온다. 그리고 수정한 뒤 수정한 녀셕을 userdefualt에 집어넣는다.
                var temp = self.whatHappened
                temp?.remove(at: indexPath.row)
                plist.set(temp, forKey: "whatHappened")
                plist.synchronize()
                //혹시모르니 전역변수의 해당데이터도 삭제해준다.
                self.whatHappened?.remove(at: indexPath.row)
                //userdefault에 동기화를 마쳤으니 테이블뷰를 리후레시한다.
                self.myTableView.reloadData()
            case 3:
                //일단 전역변수로 해당 섹션의 리스트를 가지고 있는 녀석을 불러온다. 그리고 수정한 뒤 수정한 녀셕을 userdefualt에 집어넣는다.
                var temp = self.gratitude
                temp?.remove(at: indexPath.row)
                plist.set(temp, forKey: "gratitude")
                plist.synchronize()
                //혹시모르니 전역변수의 해당데이터도 삭제해준다.
                self.gratitude?.remove(at: indexPath.row)
                //userdefault에 동기화를 마쳤으니 테이블뷰를 리후레시한다.
                self.myTableView.reloadData()
            case 4:
                //일단 전역변수로 해당 섹션의 리스트를 가지고 있는 녀석을 불러온다. 그리고 수정한 뒤 수정한 녀셕을 userdefualt에 집어넣는다.
                var temp = self.success
                temp?.remove(at: indexPath.row)
                plist.set(temp, forKey: "success")
                plist.synchronize()
                //혹시모르니 전역변수의 해당데이터도 삭제해준다.
                self.success?.remove(at: indexPath.row)
                //userdefault에 동기화를 마쳤으니 테이블뷰를 리후레시한다.
                self.myTableView.reloadData()
            default:
                print("이거슨 디폴드값 반환이여")
            }
                
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification){
        
        //인터넷에서 가져온 코드는 키보드의 높이만큼 그냥 올려버리는 구조임....내 어플에서 중요한건 그게 아니라 추가하고자 하는 섹션의 헤더가 맨 위에 올라오게끔 하는것이 첫째고 둘째는 그러고도 화면의 스크롤이 가능해야함(안보이는것 스크롤하면 전부 볼 수 있어야 함)->뷰 사이즈를 줄이는걸로 해결할 수 있을듯
        //키보드가 올라오면 원래 화면에 보이던 뷰 위를 덮는 방식으로 이루어지는데 이렇게되면 아래에 있는 내용을 보기 위해 스크롤하면 안내려감...이유는 덮여진 아래쪽에 내용이 보이고 있다고 생각하므로 더이상 스크롤을 해도 가려진곳에 있는것을 더 올릴수는 없음 ->해결법 : 뷰 영역 자체를 줄여야 할거 같다(x,y좌표가 아니라 뷰의 height를 키보드 크기만큼 줄여야함)
        
        let userInfo = notification.userInfo!
        var keyboardSize: CGSize!
        var offset: CGSize!
            //옵셔널 에서 뻑날까봐 강제해제하지 않고 에러메시지를 나타내도록 설정해놈....내가모르는코드는 이러케하는게 안전
        if let kkeyboardSize: CGSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            keyboardSize = kkeyboardSize
            print("keyboardSize height: \(kkeyboardSize.height)")
        }else{
            print("keyboardWillShow에서 keyboardSize옵셔널해제 뻑났슴")
        }
        if let ooffset: CGSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size{
            offset = ooffset
            print("offset height: \(ooffset.height)")
        }else{
            print("keyboardWillShow에서 offset옵셔널해제 뻑낫슴")
        }
        
        
        
        
        if keyboardSize.height == offset.height {
            UIView.animate(withDuration: 0.1) {() -> Void in
                //바로 아랫줄의 코드는 키보드 높이만큼 화면을 위로 밀어버림 : 이렇게하면 스크롤을 해서 위에 있는 내용 확인이 불가능함.
                //self.view.frame.origin.y -= keyboardSize.height
                
                //이거슨 해당 셀에 대한 위치정보를 담고 있는거임
                //origin속성을 통해 추가된 셀의 화면에서의 위치(x,y)를 알수있엇슴 이제 이걸 이용하기함 하면 됨
                let rectOfCell = self.myTableView.rectForRow(at: self.insertIndexPath)
                print("rectOfCell / orign / x:\(rectOfCell.origin.x) y:\(rectOfCell.origin.y) height:\(rectOfCell.size.height) width:\(rectOfCell.size.width)" )
                
                //테이블뷰의 길이를 키보드길이마만큼 줄여주자
                //나중에 다시 돌려놓아야된는거 잊지말자
                self.myTableView.frame.size.height -= offset.height
                //해당 인덱스로 스크롤해준다!
                self.myTableView.scrollToRow(at: self.insertIndexPath, at: .top, animated: true)
                //self.view.frame.size.height -= keyboardSize.height
                
            }
        }else{
            print("else실행됨")
            //차이가 있는거면
            
            UIView.animate(withDuration: 0.1) {() -> Void in
                //테이블뷰의 길이를 키보드길이만큼 줄여야 한다. 여기서 키보드 길이 기준은 offset값으로 해보자우선
                self.myTableView.frame.size.height -= offset.height
                //해당 인덱스로 스크롤해준다!
                self.myTableView.scrollToRow(at: self.insertIndexPath, at: .top, animated: true)
                //self.view.frame.origin.y += keyboardSize.height - offset.height
            }
 
        }
        
        /*
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
 */
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        
        let userInfo: [AnyHashable : Any] = notification.userInfo!
        if let offset: CGSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            
            //테이블뷰의 크기를 원래대로 돌려놓는다
            self.myTableView.frame.size.height += offset.height
        
           
        }else{
            print("keyboardWillHide에서 offset옵셔널해제 뻑났슴")
        }
        
        //뷰의 y좌표가 이상하케 되어있다면 이걸 다시 고쳐준다.
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        
        }
    }
    
    //키보드 위의 done버튼이 눌렸을때 할 작업
    @objc func doneButtonAction() {
        print("doneButtonAction실행됨")
        //저장된 내용을 userdefault에 입력한다.
        if self.section0 == true {
            let plist = UserDefaults.standard
            //우선 원래 있던 값을 읽어온다
            if let temp = plist.array(forKey: "myObjective"){
                //self.myObjective = temp1 as? [String]
                print("저장하기전 plist성공myObjective 불러오는거")
                //이제 temp에 사용자가 입력한 값을 추가하면 된다.
                var ttemp = temp as! [String]
                ttemp.append(self.userInput)
                print("ttemp 개수 : \(ttemp.count)")
                //userDefault에 저장한다 드디어
                plist.set(ttemp, forKey: "myObjective")
                
                //sync꼭 해주자 시벌럼아
                plist.synchronize()
                //맨마지막으로 화면에 표시할 각 섹션의 목록을 담고있는 vc내의 변수에도 추가를 해주자
                self.myObjective?.append(self.userInput)
                //userInput원래대로 빈값을 다시 넣어주자
                self.userInput = ""
            }else{
                print("plist에서 myObjective를 읽어오는데 실패했습니다.")
                print("템플릿에 입력된 값이 하나도 없었나 보네요. 따라서 신규 등록을 진행합니다")
                var temp = [String]()
                temp.append(self.userInput)
                print("temp개수 : \(temp.count)")
                //UserDefault에 저장한다
                plist.set(temp, forKey: "myObjective")
                plist.synchronize()
                self.myObjective = [String]()
                self.myObjective?.append(self.userInput)
                print("self.myObjective개수 : \(self.myObjective?.count ?? 5245252)") //5245252는 더미값
                self.userInput = ""
            }
        }else if self.section1 == true{
            //우선 원래 있던 값을 읽어온다
            let plist = UserDefaults.standard
            if let temp = plist.array(forKey: "wantToDo"){
                //self.myObjective = temp1 as? [String]
                print("저장하기전 plist성공 wantToDo 불러오는거")
                //이제 temp에 사용자가 입력한 값을 추가하면 된다.
                var ttemp = temp as! [String]
                ttemp.append(self.userInput)
                //userDefault에 저장한다 드디어
                plist.set(ttemp, forKey: "wantToDo")
                //sync꼭 해주자 시벌럼아
                plist.synchronize()
                //맨마지막으로 화면에 표시할 각 섹션의 목록을 담고있는 vc내의 변수에도 추가를 해주자
                self.wantToDo?.append(self.userInput)
                //userInput원래대로 빈값을 다시 넣어주자
                self.userInput = ""
            }else{
                print("plist에서 wantTodo를 읽어오는데 실패했습니다.")
                print("템플릿에 입력된 값이 하나도 없었나 보네요. 따라서 신규 등록을 진행합니다")
                var temp = [String]()
                temp.append(self.userInput)
                print("temp개수 : \(temp.count)")
                //UserDefault에 저장한다
                plist.set(temp, forKey: "wantToDo")
                plist.synchronize()
                self.wantToDo = [String]()
                self.wantToDo?.append(self.userInput)
                print("self.wantToDo개수 : \(self.wantToDo?.count ?? 5245252)") //5245252는 더미값
                self.userInput = ""
            }
        }else if self.section2 == true{
            //우선 원래 있던 값을 읽어온다
            let plist = UserDefaults.standard
            if let temp = plist.array(forKey: "whatHappened"){
                //self.myObjective = temp1 as? [String]
                print("저장하기전 plist성공 whatHappened 불러오는거")
                //이제 temp에 사용자가 입력한 값을 추가하면 된다.
                var ttemp = temp as! [String]
                ttemp.append(self.userInput)
                //userDefault에 저장한다 드디어
                plist.set(ttemp, forKey: "whatHappened")
                //sync꼭 해주자 시벌럼아
                plist.synchronize()
                //맨마지막으로 화면에 표시할 각 섹션의 목록을 담고있는 vc내의 변수에도 추가를 해주자
                self.whatHappened?.append(self.userInput)
                //userInput원래대로 빈값을 다시 넣어주자
                self.userInput = ""
            }else{
                print("plist에서 whatHappened를 읽어오는데 실패했습니다.")
                print("plist에서 wantTodo를 읽어오는데 실패했습니다.")
                print("템플릿에 입력된 값이 하나도 없었나 보네요. 따라서 신규 등록을 진행합니다")
                var temp = [String]()
                temp.append(self.userInput)
                print("temp개수 : \(temp.count)")
                //UserDefault에 저장한다
                plist.set(temp, forKey: "whatHappened")
                plist.synchronize()
                self.whatHappened = [String]()
                self.whatHappened?.append(self.userInput)
                print("self.whatHappened개수 : \(self.whatHappened?.count ?? 5245252)") //5245252는 더미값
                self.userInput = ""
            }
            
        }else if self.section3 == true{
            //우선 원래 있던 값을 읽어온다
            let plist = UserDefaults.standard
            if let temp = plist.array(forKey: "gratitude"){
                //self.myObjective = temp1 as? [String]
                print("저장하기전 plist성공 gratitude 불러오는거")
                //이제 temp에 사용자가 입력한 값을 추가하면 된다.
                var ttemp = temp as! [String]
                ttemp.append(self.userInput)
                //userDefault에 저장한다 드디어
                plist.set(ttemp, forKey: "gratitude")
                //sync꼭 해주자 시벌럼아
                plist.synchronize()
                //맨마지막으로 화면에 표시할 각 섹션의 목록을 담고있는 vc내의 변수에도 추가를 해주자
                self.gratitude?.append(self.userInput)
                //userInput원래대로 빈값을 다시 넣어주자
                self.userInput = ""
            }else{
                print("plist에서 gratitude를 읽어오는데 실패했습니다.")
                print("plist에서 whatHappened를 읽어오는데 실패했습니다.")
                print("plist에서 wantTodo를 읽어오는데 실패했습니다.")
                print("템플릿에 입력된 값이 하나도 없었나 보네요. 따라서 신규 등록을 진행합니다")
                var temp = [String]()
                temp.append(self.userInput)
                print("temp개수 : \(temp.count)")
                //UserDefault에 저장한다
                plist.set(temp, forKey: "gratitude")
                plist.synchronize()
                self.gratitude = [String]()
                self.gratitude?.append(self.userInput)
                print("self.gratitude개수 : \(self.gratitude?.count ?? 5245252)") //5245252는 더미값
                self.userInput = ""
            }
            
            
        }else if self.section4 == true{
            //우선 원래 있던 값을 읽어온다
            let plist = UserDefaults.standard
            if let temp = plist.array(forKey: "success"){
                //self.myObjective = temp1 as? [String]
                print("저장하기전 plist성공 success 불러오는거")
                //이제 temp에 사용자가 입력한 값을 추가하면 된다.
                var ttemp = temp as! [String]
                ttemp.append(self.userInput)
                //userDefault에 저장한다 드디어
                plist.set(ttemp, forKey: "success")
                //sync꼭 해주자 시벌럼아
                plist.synchronize()
                //맨마지막으로 화면에 표시할 각 섹션의 목록을 담고있는 vc내의 변수에도 추가를 해주자
                self.success?.append(self.userInput)
                //userInput원래대로 빈값을 다시 넣어주자
                self.userInput = ""
            }else{
                print("plist에서 success를 읽어오는데 실패했습니다.")
                print("plist에서 gratitude를 읽어오는데 실패했습니다.")
                print("plist에서 whatHappened를 읽어오는데 실패했습니다.")
                print("plist에서 wantTodo를 읽어오는데 실패했습니다.")
                print("템플릿에 입력된 값이 하나도 없었나 보네요. 따라서 신규 등록을 진행합니다")
                var temp = [String]()
                temp.append(self.userInput)
                print("temp개수 : \(temp.count)")
                //UserDefault에 저장한다
                plist.set(temp, forKey: "success")
                plist.synchronize()
                self.success = [String]()
                self.success?.append(self.userInput)
                print("self.success개수 : \(self.success?.count ?? 5245252)") //5245252는 더미값
                self.userInput = ""
            }
            
        }else{
            print("섹션0부터4까지 모두 false임다이건뭔가 잘못됫슴다")
        }
        
        
        //section변수들을 false로 초기화한다.
        self.section0 = false
        self.section1 = false
        self.section2 = false
        self.section3 = false
        self.section4 = false
        
        //추가하려고 했던 셀을 원래대로 되돌려놓는다.
        self.myTableView.reloadData()
        
        //키보드를 내린다
        self.resignFirstResponder()
    }
    
    //키보드 위의 cancel 버튼이 눌렸을때 할 작업
    @objc func cancelButtonAction(){
        
        //section변수들을 false로 초기화한다.
        self.section0 = false
        self.section1 = false
        self.section2 = false
        self.section3 = false
        self.section4 = false
        //추가하려고 했던 셀을 원래대로 되돌려놓는다.
        self.myTableView.reloadData()
        
        //키보드를 내린다
        self.resignFirstResponder()
    }
    
}
