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

class WriteDiaryVC: UITableViewController, UITextViewDelegate{
    
    //여기 빈공간에다가는 변수들을 초기화하셈
    
    //MARK: 일기 내용을 직접 입력할때 사용할 변수들
        //사용자가 템플릿을 만들기 위해 입력한 값을 임시로 저장해놀 변수
        var userInput = ""
    
        //현재 작성중인 셀의 높이를 저장할 변수 자료형에 주의
        var heightForCell: CGFloat = 0
    
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
        var section1 = false
        var section2 = false
        var section3 = false
        var section4 = false
        var section5 = false
    
    //MARK: 일기 내용 작성과는 큰 관련없는 변수들
    
        //에디트 버튼 최초 표시할때 '수정끝'으로 나오기 때문에 그걸 막기위해 설정한 변수
        var editButtonDidSelected = false
    
        //푸터를 표시할지 말지 결정하는 변수
        var showFooter = true
    
        //일기쓴날인지 아닌지를 판단하게 해주는 전역변수....결국엔 쓸모없게 되어벼렸다 걍 아무기능안함....
        var didWriteDiary: Bool!
        //UserDefault사용하기 위한 작업
        let plist = UserDefaults.standard
    
        //db에서 일기을 읽어온 녀석을 저장할 변수
        //순서대로 create_date, moring, night, did_backup, data임
        var diaryData : [(String, Int, Int, Int, String)]!
    
        //diaryData내의 변수를 저장할 변수
        var create_date: String!
        var morning = 0
        var night = 0
        var did_backup = 0
        var data: Data? //String이 아님에 주의해야 한다!!!!!!!!!!!!!!!!!
    
        //일기데이터를 파싱해서 저장할 구조체 선언(파싱할때 편하도록 특별히 프로토콜 선언함)
    struct Body: Codable {
        //일기의 data행에서 각 목록에 해당하는 정보를 저장할 변수
        var date : String?
        var myObjective : [String]?
        var wantToDo : [String]?
        var whatHappened : [String]?
        var gratitude : [String]?
        var success : [String]?
    }
    
        //위의 구조체를 자료형으로 하는 변수 선언(여기에 실제 내용 들어갈예정임)
    var diaryBody : Body!
    
        //이거는 전달받은 날짜 저장할 변수
    var sendedDate: Date?
    
        //JSON받을 변수(db의 data컬럼에 들어있는 정보)
    var jsonData: JSON!
    
        
    
        //db사용하기 위한 작업
    let diaryDAO = DiaryDAO()
    
    
        //json디코딩을 위한 선언
    let decoder = JSONDecoder()
    
        //json인코딩을 위한 선언
    let incoder = JSONEncoder()
    
    
    
     
        //맨위의 취소버튼임
    @IBAction func cancelButton(_ sender: UIButton) {
        print("cancelBtn2")
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    //맨위의 저장버튼임...텍스트는 저장인데 실제 저장하는 로직은 없음...내용을 작성할때 바로 디비에 저장되니까 그냥 화면 닫고 리프레시하는게 다임
    @IBAction func saveButton(_ sender: UIButton) {
        if self.showFooter == false{//'내용추가'인경우
            self.showFooter = true
            self.tableView.reloadData()
            print("리로딩로딩로딩")
            
        }else{//footer보여줘야되는경우 분기점 즉 '저장'인경우
            //평상시 '저장'버튼의 기능임 즉 showFooter 값이 true인경우에 쓸거임
            print("saveBtn2")
            //self.presentingViewController?.viewWillAppear(false)
            
            //let temp = self.presentingViewController as! CalendarVC
            //temp.viewWillAppear(false)
            self.presentingViewController?.children[0].viewWillAppear(false)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            print("캘린더리프레싱가즈아")
            
            
        }
        
    }
    
    //맨위의 수정버튼임
    @IBAction func editButton(_ sender: UIButton) {
        let toolBarIndex = IndexPath(row: 0, section: 0)
        //let editButtonIndex = tableView(self.tableView, cellForRowAt: toolBarIndex)
        //let editBTN = editButtonIndex as! ToolBarCell
        print("에디트버튼눌림")
        self.editButtonDidSelected = true
        if self.tableView.isEditing == true{//현재 에디팅중인경우(삭제버튼 보이고 있는 경우)
            
            //editBTN.editButton.setTitle("수정", for: .normal)
            self.tableView.reloadRows(at: [toolBarIndex], with: .automatic)
            self.tableView.isEditing = false
        }else{//현재 에디팅상태가아닌경우(삭제버튼 안보이고있음)
            
            //editBTN.editButton.setTitle("수정끝", for: .normal)
            self.tableView.reloadRows(at: [toolBarIndex], with: .automatic)
            self.tableView.isEditing = true
        }
    }
    
    
    
    
     
     
override func viewDidLoad() {
    super.viewDidLoad()
   
    self.editButtonDidSelected = false
    
    //내용입력할때 키보드 높이만큼 화면을 이동해야하는 경우 있으므로 그때 사용하기위한 작업
    //selelctor인자에 들어있는 함수는 저 아래에 있음...
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: self.view.window)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    
    
        //self.sendedDate에는 직접 선택한 날짜와 동일한 날짜가 입력되어있다.
    print("sended date : \(self.sendedDate!)")
    //db에서 main테이블을 읽어와서 diaryData에 저장해두고 이걸 바탕으로 셀을 만든다.
    
    //주의해야될 점은 findMain함수는 인자로 String값을 받는데 그 값으로 검색을 한다. 검색시에는 날짜의 형식이 년년년년-월월-일일 이므로 인자값에 넣어주기전에 형식변환을 하여 변환된 값을 넣어줘야 한다.
    //--------------------------------------------------------------------------------
    //잘 생각해보니까 DiaryDAO에서 findmain함수의 인자로 보낼때 굳이 이 귀찮은 변환을 계속 해서 String타입으로 보내줄게 아니라 그냥 Date 타입을 인자로 넣고 함수내에서 알아서 변환하면 되자나...그게더 편하지않나?
    /*
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
        //이해는 잘 안되지만 왜 toGlobalTime써줘야되는지 모르갓슴
    let writingDay = dateFormatter.string(from: (self.sendedDate?.toGlobalTime())!)
    print("writingDay : \(writingDay)")
    */
        //self.sendedDate에 해당하는 날짜의 레코드를 불러온다
    self.diaryData = self.diaryDAO.findMain(date: self.sendedDate!)
    
    //배열을 반환받는데 사실 일자별로 일기는 하나씩밖에 없으니깐 배열안에는 인자가 하나밖에 없을거암. 그거를 쓰기 쉽게 지역변수에 대입해놓는다
    if self.diaryData == nil {
        print("findMain함수 리턴값이 없는듯...self.diaryDAO 값에서 nil 나옴")
        //일기데이터가 없다는 말은 일기를 쓰지 않았다는 거니까, 템플릿을 읽어오도록 하자 토오오옷
        self.didWriteDiary = false
        
    }else{
        print("findMAin함수 반환이 정상적으로 된듯...반환된 배열내 값 갯수 : \(self.diaryData.count)")
        
        if self.diaryData.count == 0 {
            //조건식 값이 0이라면 아무값도 리턴된게 없으니 일기를 쓰지 않은 날이라는 것이다
            print("일기를 안쓴 날을 고르셨습니다.")
            //일기 안쓴날이므로 템플릿에 있는 내용을 표출해주면 된다.
            //else문과는 달리 레코드 내의 값(create_date부터 did_backup까지)을 지금부터 일일히 설정하지 않아도 된다.
            //우선 diaryBody역할을 할 변수를 선언하자...여기에 템플릿 내용을 다 넣은 후에 전역변수인 diaryBody에 대입한다.
            var tempBody = Body()
            
            //일기를 쓰지 않았으므로 전역변수에 false를 넣는다.
            self.didWriteDiary = false
            
            //각 섹션에 해당하는 템플릿을 읽어온다. 읽어왔을때 값이 있는 경우에만 tempBody안에 내용을 입력한다.
            if let templateMyObjective = plist.array(forKey: "myObjective"){
                tempBody.myObjective = templateMyObjective as? [String]
                print("myObject의 템플릿 입력 완료")
            }else{
                print("myObject의 template읽어올수 없음. 템플릿에 내용을 입력하지 않았다.")
            }
            if let templateWantToDo = plist.array(forKey: "wantToDo"){
                tempBody.wantToDo = templateWantToDo as? [String]
                print("wantToDo의 템플릿 입력 완료")
            }else{
                print("wantToDO의 template읽어올수 없음. 템플릿에 내용을 입력하지 않았다.")
            }
            if let templateWhatHappened = plist.array(forKey: "whatHappened"){
                tempBody.whatHappened = templateWhatHappened as? [String]
                print("whatHappened의 템플릿 입력 완료")
            }else{
                print("whatHappened의 template읽어올수 없음. 템플릿에 내용을 입력하지 않았다.")
            }
            if let templateGratitude = plist.array(forKey: "gratitude"){
                tempBody.gratitude = templateGratitude as? [String]
                print("gratitude의 템플릿 입력 완료")
            }else{
                print("gratitude의 template읽어올수 없음. 템플릿에 내용을 입력하지 않았다.")
            }
            if let templateSuccess = plist.array(forKey: "success"){
                tempBody.success = templateSuccess as? [String]
                print("success의 템플릿 입력 완료")
            }else{
                print("success의 template읽어올수 없음. 템플릿에 내용을 입력하지 않았다.")
            }
            
            //이제 tempBody녀석을 전역변수에 대입해야 한다
            self.diaryBody = tempBody
            
        }else{
            //일기를 작성한적이 있다는 분기이므로 여기선 전역변수에 true를 넣는다
            self.didWriteDiary = true
        //전역변수로 선언된 녀석들에게 직접 값을 넣어준다.
        self.create_date = self.diaryData[0].0
        self.morning = self.diaryData[0].1
        self.night = self.diaryData[0].2
        self.did_backup = self.diaryData[0].3
            
        let jsonString = self.diaryData[0].4
            
            
        self.data = jsonString.data(using: .utf8)
            
            if self.data == nil {
                print("data is nil")
            }else{
                print("data is not nil")
            }
            //데이터 파싱!
        
            if let data = self.data {
                do{
                    let tempBody = try decoder.decode(Body.self, from: data)
                print("파싱 컴플릿")
                    self.diaryBody = tempBody
                    
                
                }catch{
                    print("파싱 error")
                }
            }else{
                print("옵셔널 벗기기 에러")
            }
           
        
            
            /*
            if let data = self.data, let myBody = try? decoder.decode(Body.self, from: data) {

                print("파싱시작")
                print(myBody.myObjective)
                print(myBody.wantToDo)
                print(myBody.whatHappened)
                print(myBody.success)
                print(myBody.gratitude)
                print("파싱끝")

            }else{
                print("파싱안됨")
            }
 */
        }
        
        //테이블 셀의 높이를 동적으로 설정하기 위한 코드
        //tableView.estimatedRowHeight = 70.0
        //tableView.rowHeight 
        
    }
    
    
    //여기 아래에 들어가야 할 코드 : 읽어온 일기의 data열의 정보(json형식)를 읽어와 그 내용을 각 변수에 저장해야한다.---------------------------------------
    //self.create_date = self.diaryData.
    }
    
//화면이 나타날때마다 호출되는 메소드
override func viewWillAppear(_ animated: Bool) {
    self.tableView.reloadData()
    }
    
//화면이 사라질때 호출되는 메서드
override func viewWillDisappear(_ animated: Bool) {
        //아래 코드가 제대로 작동하지 않는다면 object에 nil을 넣어볼것
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification , object: self.view.window)
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillHideNotification , object: self.view.window)
    }
//테이블 행의 개수를 결정하는 메소드
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0:
        return 1
    case 1:
        //참고시작
        if self.section1 {
            return (self.diaryBody.myObjective?.count ?? 0) + 1
        }else{
            return self.diaryBody.myObjective?.count ?? 0
        }
        /*
        //참고끝
        if self.diaryData.count == 0 {
            print("return default at numberOfRowsInSection")
            return 1
        }else{
        return self.diaryBody.myObjective?.count ?? 1
        }
 */
    case 2:
        if self.section2 {
            return (self.diaryBody.wantToDo?.count ?? 0) + 1
        }else{
            return self.diaryBody.wantToDo?.count ?? 0
        }
    case 3:
        if self.section3 {
            return (self.diaryBody.whatHappened?.count ?? 0) + 1
        }else{
            return self.diaryBody.whatHappened?.count ?? 0
        }
    case 4:
        if self.section4 {
            return (self.diaryBody.gratitude?.count ?? 0) + 1
        }else{
            return self.diaryBody.gratitude?.count ?? 0
        }
    case 5:
       if self.section5 {
            return (self.diaryBody.success?.count ?? 0) + 1
        }else{
            return self.diaryBody.success?.count ?? 0
        }
    default :
        print("return default at numberOfRowsInSection")
        return 1
    }
 
    }

//테이블 행을 구성하는 메소드
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("쎌폴로앳 실행됨")
    if self.forAdd == true {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell") as! WriteDiaryAddCell
        
        //맨처음에 아무 텍스트도 안들어가 잇도록 일부러 빈 값을 넣어준다(원래아무것도 안들어있긴 하지만 연속해서 두번 셀 추가할때엔 저번에 입력한 값이 바로 뜨드라...셀재활용 메커니즘때문인듯)
        cell.addTextView.text = ""
        cell.addTextView.delegate = self
        cell.addTextView.frame.size.width = tableView.frame.size.width - 40
        self.heightForCell = cell.addTextView.frame.size.height
        
        //기존 셀의 높이를 전역변수인 addCellTextViewHeight에 저장해둔다.
            //addTextView.frame.size.height가 아닌 이유는 델리게이트 메서드에서 아래에 쓴 걸로 값 비교를 할 것이기 때문이다.
        self.addCellTextViewHeight = cell.addTextView.contentSize.height
        
        print("frame.size.height : \(cell.addTextView.frame.size.height), contentSize.height : \(cell.addTextView.contentSize.height)")
        
        
        
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
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "toolBarCell") as! ToolBarCell
        
        //날짜를 받은대로 출력하면 시분초까지 나오니까 원하는 포맷으로 설정하기
        
       
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd"
            //왠진모르겠지만 toGlobalTime안해주면...그냥 아무날짜 선택하지 않고 기본세팅 오늘날짜로 했을때 다음날짜가 일기쓰기 화면에 나옴...
        let date = dateFormatter.string(from: self.sendedDate!.toGlobalTime())
        
        print("dateFromString : \(date)")
        cell.showDate.text = date
        //showFooter값을 확인해서 false라면 저장버튼을 수정버튼으로 바꿔주기
        if self.showFooter == false {
            cell.saveButton.setTitle("내용추가", for: .normal)
        }else{
            cell.saveButton.setTitle("저장", for: .normal)
        }
        
        if self.editButtonDidSelected == true{
        if self.tableView.isEditing == true{
            cell.editButton.setTitle("수정", for: .normal)
        }else{
            cell.editButton.setTitle("수정끝", for: .normal)
        }
        }
                   return cell
        
    case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell") as! WriteDiaryAddCell
        cell.addTextView.delegate = self
        if self.diaryData.count == 0 {
            //diaryBody.myObjective의 값을 검사해서 값이 있으면 값을대입, 없으면 빈값 대입
            if self.diaryBody.myObjective == nil {
                cell.addTextView.text = ""
            }else{
                cell.addTextView.text = self.diaryBody.myObjective![indexPath.row]
            }
            
        }else{
        cell.addTextView.text = self.diaryBody.myObjective![indexPath.row]
        }
        return cell
        /*원래있던녀석
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
        if self.diaryData.count == 0 {
            //diaryBody.myObjective의 값을 검사해서 값이 있으면 값을대입, 없으면 빈값 대입
            if self.diaryBody.myObjective == nil {
                cell.mainText.text = ""
            }else{
                cell.mainText.text = self.diaryBody.myObjective![indexPath.row]
            }
            
        }else{
        cell.mainText.text = self.diaryBody.myObjective![indexPath.row]
        }
        return cell
        */
        
    case 2:
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell") as! WriteDiaryAddCell
        cell.addTextView.delegate = self
        if self.diaryData.count == 0 {
            //diaryBody.myObjective의 값을 검사해서 값이 있으면 값을대입, 없으면 빈값 대입
            if self.diaryBody.wantToDo == nil {
                cell.addTextView.text = ""
            }else{
                cell.addTextView.text = self.diaryBody.wantToDo![indexPath.row]
            }
            
        }else{
        cell.addTextView.text = self.diaryBody.wantToDo![indexPath.row]
        }
        return cell
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
        if self.diaryData.count == 0 {
            
            if self.diaryBody.wantToDo == nil {
                cell.mainText.text = ""
            }else{
                cell.mainText.text = self.diaryBody.wantToDo![indexPath.row]
            }
            
        }else{
        cell.mainText.text = self.diaryBody.wantToDo![indexPath.row]
        }
        return cell
        */
    case 3:
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell") as! WriteDiaryAddCell
        cell.addTextView.delegate = self
        if self.diaryData.count == 0 {
            //diaryBody.myObjective의 값을 검사해서 값이 있으면 값을대입, 없으면 빈값 대입
            if self.diaryBody.whatHappened == nil {
                cell.addTextView.text = ""
            }else{
                cell.addTextView.text = self.diaryBody.whatHappened![indexPath.row]
            }
            
        }else{
        cell.addTextView.text = self.diaryBody.whatHappened![indexPath.row]
        }
        return cell
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
        if self.diaryData.count == 0 {
            if self.diaryBody.whatHappened == nil {
                cell.mainText.text = ""
            }else{
                cell.mainText.text = self.diaryBody.whatHappened![indexPath.row]
            }
        }else{
        cell.mainText.text = self.diaryBody.whatHappened![indexPath.row]
        }
        return cell
        */
    case 4:
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell") as! WriteDiaryAddCell
        cell.addTextView.delegate = self
        if self.diaryData.count == 0 {
            //diaryBody.myObjective의 값을 검사해서 값이 있으면 값을대입, 없으면 빈값 대입
            if self.diaryBody.gratitude == nil {
                cell.addTextView.text = ""
            }else{
                cell.addTextView.text = self.diaryBody.gratitude![indexPath.row]
            }
            
        }else{
        cell.addTextView.text = self.diaryBody.gratitude![indexPath.row]
        }
        return cell
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
        if self.diaryData.count == 0 {
            if self.diaryBody.gratitude == nil {
                cell.mainText.text = ""
            }else{
                cell.mainText.text = self.diaryBody.gratitude![indexPath.row]
            }
        }else{
        cell.mainText.text = self.diaryBody.gratitude![indexPath.row]
        }
        return cell
        */
    case 5:
        let cell = tableView.dequeueReusableCell(withIdentifier: "addCell") as! WriteDiaryAddCell
        cell.addTextView.delegate = self
        if self.diaryData.count == 0 {
            //diaryBody.myObjective의 값을 검사해서 값이 있으면 값을대입, 없으면 빈값 대입
            if self.diaryBody.success == nil {
                cell.addTextView.text = ""
            }else{
                cell.addTextView.text = self.diaryBody.success![indexPath.row]
            }
            
        }else{
        cell.addTextView.text = self.diaryBody.success![indexPath.row]
        }
        return cell
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
        if self.diaryData.count == 0 {
            if self.diaryBody.success == nil {
                cell.mainText.text = ""
            }else{
                cell.mainText.text = self.diaryBody.success![indexPath.row]
            }
        }else{
        cell.mainText.text = self.diaryBody.success![indexPath.row]
        }
        return cell
         */
         
    default:
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as! MainCell
        print("default로 MainCell을 생성하였습니다.")
        cell.mainText.text = "default값으로 생성된 셀"
                   //여기안에 디비에서 받아온 정보를 가지고 각 셀 안의 데이터를 입력해준다.
                   
                   
        
                   return cell
    }
    }
    }
    /*
//테이블의 특정 행이 선택되었을때 호출되는 메소드
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.insertIndexPath = indexPath
    print("didSelectRowAt함수 실행됨")
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
        //전달받은 showFooter값을 이용하여 이 값이 false 라면 아예 안보이게 한다.
        if self.showFooter == false {//footer를 안보이게 해야 하는 상황
            return 0
        }else{//footer를 보여줘야 되는 상황
            //요거는 푸터를 표시하는 경우에 사용하는 부분임. 메뉴바에는 푸터가 필요 없으니 푸터 높이를 0으로 지정하면 안나옴!
            if section == 0 {
                return 0
            }else{
                return 20
            }
        }
    }
    
    //MARK: TextViewDelegate함수들
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
            //셀 높이를 늘린다. 이제와서보니깐 이게 굳이 필요한가 싶기도 함
            self.diffHeight = diff
            
            //여기서는 현재 작성중인 셀의 높이값만 저장하면 되므로 이렇게 딕셔너리 값까지 사용할 필요가 없을것 같음
            self.heightForCell += diff
            
            self.tableView.beginUpdates()
            /*
            //여기 사이에다가 테이블 셀의 높이를 증가시키는 코드를 넣으면 될까? 해보니깐 안됨 ㅋㅋㅋㅋㅋ
                //현재 에디팅하고 있는 셀을 불러온다
            let editingCell = self.tableView.cellForRow(at: self.insertIndexPath) as! WriteDiaryAddCell
                //이 셀의 높이 값에 diff만큼을 더해준다
            editingCell.frame.size.height += diff
            */
            self.tableView.endUpdates()
        }
    }
    
    /*
    //텍스트뷰 수정하려고 할때 실행될 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    */
    
    //텍스트뷰 수정되기전에 실행될 메서드..이녀석에서 true를 반환하면 수정시작되고 false반환하면 수정자체가 일어나지 않음
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.tableView.isEditing == true{
            print("return true")
            return true
        }else{
            if self.insertIndexPath != nil {
                return true
            }else{//nil인경우 즉 추가한게아니라 그냥 터치한경우
                print("return false")
                return false
            }
            
        }
    }
    
    
    //셀의 높이값을 반환할 함수.............이거 있으면 오토로 안되는거 아님? 리턴값을 슈퍼를 통해서 해놓으니까 되넹 헤헤헤
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("heightForRowAt실행됨")
        if indexPath == self.insertIndexPath{
            print("새로운높이 : \(self.heightForCell)")
            return (super.tableView(tableView, heightForRowAt: indexPath) + self.heightForCell)
        }else{
        return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    //에디트모드가 되었을때 어떤 모드를 제공할지 설정해주는 함수
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let toolBarIndex = IndexPath(row: 0, section: 0)
        if indexPath == toolBarIndex{
            return .none
        }else{
            return .delete
        }
    }
    
    //수정시 들여쓰기 여부를 결정하는 메서드
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        let toolBarIndex = IndexPath(row: 0, section: 0)
        if indexPath == toolBarIndex{
            print("indentation denied")
            return false
        }else{
            return true
        }
    }
    
    //각 행에서 삭제버튼을 눌렀을때 호출될 함수
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section{
            case 0:
                print("섹션0은 툴바니까 지워질리 없는데 어떻게 지우는버튼 누른거임? 님 어뷰징 유저임 신고 ㄱㄱ")
            case 1:
                self.diaryBody.myObjective?.remove(at: indexPath.row)
                print("나의 목표 섹션의 \(indexPath.row)행을 지웠습니다.전역변수만")
                    //여기 아래서부터는 디비에 저장할때 쓸 코드
                //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                self.diaryBody.date = dateFormat.string(from: Date())
                
                //JSON으로 인코딩한다
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(self.diaryBody)
                let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                print("stringfiedJsonData : \(stringfiedJsonData!)")
                //이제 db에 넣어주자...
                    //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!)
                print("writeDate : \(writeDate)")
                    //대망의 디비를 수정하는 부분
                self.diaryDAO.updateDiaryBody(writeDate: writeDate, data: stringfiedJsonData!)
                //화면에 보이는 선택한 행을 삭제한다
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
            case 2:
                self.diaryBody.wantToDo?.remove(at: indexPath.row)
                print("하고 싶은 일 섹션의 \(indexPath.row)행을 지웠습니다.전역변수만")
                    //여기 아래서부터는 디비에 저장할때 쓸 코드
                //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                self.diaryBody.date = dateFormat.string(from: Date())
                
                //JSON으로 인코딩한다
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(self.diaryBody)
                let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                print("stringfiedJsonData : \(stringfiedJsonData!)")
                //이제 db에 넣어주자...
                    //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!)
                print("writeDate : \(writeDate)")
                    //대망의 디비를 수정하는 부분
                self.diaryDAO.updateDiaryBody(writeDate: writeDate, data: stringfiedJsonData!)
                //화면에 보이는 선택한 행을 삭제한다
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            case 3:
                self.diaryBody.whatHappened?.remove(at: indexPath.row)
                print("오늘 있었던일 섹션의 \(indexPath.row)행을 지웠습니다.전역변수만")
                    //여기 아래서부터는 디비에 저장할때 쓸 코드
                //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                self.diaryBody.date = dateFormat.string(from: Date())
                
                //JSON으로 인코딩한다
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(self.diaryBody)
                let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                print("stringfiedJsonData : \(stringfiedJsonData!)")
                //이제 db에 넣어주자...
                    //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!)
                print("writeDate : \(writeDate)")
                    //대망의 디비를 수정하는 부분
                self.diaryDAO.updateDiaryBody(writeDate: writeDate, data: stringfiedJsonData!)
                //화면에 보이는 선택한 행을 삭제한다
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            case 4:
                self.diaryBody.gratitude?.remove(at: indexPath.row)
                print("감사할일 섹션의 \(indexPath.row)행을 지웠습니다.전역변수만")
                    //여기 아래서부터는 디비에 저장할때 쓸 코드
                //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                self.diaryBody.date = dateFormat.string(from: Date())
                
                //JSON으로 인코딩한다
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(self.diaryBody)
                let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                print("stringfiedJsonData : \(stringfiedJsonData!)")
                //이제 db에 넣어주자...
                    //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!)
                print("writeDate : \(writeDate)")
                    //대망의 디비를 수정하는 부분
                self.diaryDAO.updateDiaryBody(writeDate: writeDate, data: stringfiedJsonData!)
                //화면에 보이는 선택한 행을 삭제한다
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            case 5:
                self.diaryBody.success?.remove(at: indexPath.row)
                print("성공법칙 섹션의 \(indexPath.row)행을 지웠습니다.전역변수만")
                    //여기 아래서부터는 디비에 저장할때 쓸 코드
                //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                self.diaryBody.date = dateFormat.string(from: Date())
                
                //JSON으로 인코딩한다
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(self.diaryBody)
                let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                print("stringfiedJsonData : \(stringfiedJsonData!)")
                //이제 db에 넣어주자...
                    //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!)
                print("writeDate : \(writeDate)")
                    //대망의 디비를 수정하는 부분
                self.diaryDAO.updateDiaryBody(writeDate: writeDate, data: stringfiedJsonData!)
                //화면에 보이는 선택한 행을 삭제한다
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                print("디폴드값으로지우게?말도안되")
            }
        }
    }
    
    
    //MARK: @objc 붙은 함수녀석들 모음
    //footer안의 버튼 누르면 사용될 함수
    @objc func buttonAction1(_ sender: UIButton!) {
        print("나의 목표 추가 tapped")
        self.forAdd = true
        self.section1 = true
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.tableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.diaryBody.myObjective?.count ?? 0, section: 1)
        self.insertIndexPath = insertIndexPath
        self.tableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.tableView.endUpdates()
        
        let newCell = self.tableView.cellForRow(at: insertIndexPath) as! WriteDiaryAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
    }
    @objc func buttonAction2(_ sender: UIButton!) {
        print("하고싶은일 추가 tapped")
        self.forAdd = true
        self.section2 = true
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.tableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.diaryBody.wantToDo?.count ?? 0, section: 2)
        self.insertIndexPath = insertIndexPath
        self.tableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.tableView.endUpdates()
        
        let newCell = self.tableView.cellForRow(at: insertIndexPath) as! WriteDiaryAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
    }
    @objc func buttonAction3(_ sender: UIButton!) {
        print("오늘 있었던일 tapped")
        self.forAdd = true
        self.section3 = true
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.tableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.diaryBody.whatHappened?.count ?? 0, section: 3)
        self.insertIndexPath = insertIndexPath
        self.tableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.tableView.endUpdates()
        
        let newCell = self.tableView.cellForRow(at: insertIndexPath) as! WriteDiaryAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
    }
    @objc func buttonAction4(_ sender: UIButton!) {
        print("감사할일 tapped")
        self.forAdd = true
        self.section4 = true
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.tableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.diaryBody.gratitude?.count ?? 0, section: 4)
        self.insertIndexPath = insertIndexPath
        self.tableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.tableView.endUpdates()
        
        let newCell = self.tableView.cellForRow(at: insertIndexPath) as! WriteDiaryAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
    }
    @objc func buttonAction5(_ sender: UIButton!) {
        print("성공법칙 tapped")
        self.forAdd = true
        self.section5 = true
        //테이블뷰에 셀을 추가하는 방법이 아래 네줄의 코드임
        self.tableView.beginUpdates()
        //insertRows에 첫번째 인자값으로 IndexPath변수가 필요해서 이러케 함.
        let insertIndexPath = IndexPath(row: self.diaryBody.success?.count ?? 0, section: 5)
        self.insertIndexPath = insertIndexPath
        self.tableView.insertRows(at: [insertIndexPath], with: .automatic)
        self.tableView.endUpdates()
        
        let newCell = self.tableView.cellForRow(at: insertIndexPath) as! WriteDiaryAddCell
        
        newCell.addTextView.becomeFirstResponder() //키보드 활성화 하는 코드
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
           
           
           
        if self.tableView.isEditing == false {
           
            if self.insertIndexPath != nil{
                if keyboardSize.height == offset.height {
               UIView.animate(withDuration: 0.1) {() -> Void in
                   //바로 아랫줄의 코드는 키보드 높이만큼 화면을 위로 밀어버림 : 이렇게하면 스크롤을 해서 위에 있는 내용 확인이 불가능함.
                   //self.view.frame.origin.y -= keyboardSize.height
                   
                   //이거슨 해당 셀에 대한 위치정보를 담고 있는거임
                   //origin속성을 통해 추가된 셀의 화면에서의 위치(x,y)를 알수있엇슴 이제 이걸 이용하기함 하면 됨
                   let rectOfCell = self.tableView.rectForRow(at: self.insertIndexPath)
                   print("rectOfCell / orign / x:\(rectOfCell.origin.x) y:\(rectOfCell.origin.y) height:\(rectOfCell.size.height) width:\(rectOfCell.size.width)" )
                   
                   //테이블뷰의 길이를 키보드길이마만큼 줄여주자
                   //나중에 다시 돌려놓아야된는거 잊지말자
                   self.tableView.frame.size.height -= offset.height
                   //해당 인덱스로 스크롤해준다!
                   self.tableView.scrollToRow(at: self.insertIndexPath, at: .top, animated: true)
                self.insertIndexPath = nil
                   //self.view.frame.size.height -= keyboardSize.height
                }
               
            }else{
               print("else실행됨")
               //차이가 있는거면
               
               UIView.animate(withDuration: 0.1) {() -> Void in
                   //테이블뷰의 길이를 키보드길이만큼 줄여야 한다. 여기서 키보드 길이 기준은 offset값으로 해보자우선
                   self.tableView.frame.size.height -= offset.height
                   //해당 인덱스로 스크롤해준다!
                   self.tableView.scrollToRow(at: self.insertIndexPath, at: .top, animated: true)
                   //self.view.frame.origin.y += keyboardSize.height - offset.height
                self.insertIndexPath = nil
                }
              }
           }else{//self.insertIndexPath가 nil인경우...즉 수정모드도아닌데 셀을 눌러서 키보드 올라오게 한 경우
            
            }
        }else{//self.tableView.isEditing == true인 경우에 실행된다. 즉 수정중일때 실행된다.
            //우선 아무것도 하지 말아봐....아무것도 안하면 에러 안남
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
               self.tableView.frame.size.height += offset.height
           
              
           }else{
               print("keyboardWillHide에서 offset옵셔널해제 뻑났슴")
           }
           
           //뷰의 y좌표가 이상하케 되어있다면 이걸 다시 고쳐준다.
           if self.view.frame.origin.y != 0 {
               self.view.frame.origin.y = 0
           
           }
       }
    
    //키보드 위의 cancel 버튼이 눌렸을때 할 작업
    @objc func cancelButtonAction(){
        
        //section변수들을 false로 초기화한다.
        self.section1 = false
        self.section2 = false
        self.section3 = false
        self.section4 = false
        self.section5 = false
        //추가하려고 했던 셀을 원래대로 되돌려놓는다.
        self.tableView.reloadData()
        
        //키보드를 내린다
        self.resignFirstResponder()
    }
    
    //MARK: 키보드 done버튼이 눌렸을때 할 작업
    @objc func doneButtonAction() {
        print("doneButtonAction실행됨")
        //저장된 내용을 userdefault에 입력한다.
        
        if self.section1 == true {
            if self.diaryBody.myObjective != nil {//일기를 쓴적이 있는 경우
                //diaryBody의 해당에 사용자 입력을 추가한다.
                self.diaryBody.myObjective?.append(self.userInput)
                //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                self.diaryBody.date = dateFormat.string(from: Date())
                
                //JSON으로 인코딩한다
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(self.diaryBody)
                let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                print("stringfiedJsonData : \(stringfiedJsonData!)")
                //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                    //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                print("writeDate : \(writeDate)")
                    //대망의 디비에 넣는 구분
                self.diaryDAO.editData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
            }else{//일기를 쓴적이 없는 경우
                print("일기를 처음 쓰는구먼유!")
                //diaryBody의 해당에 사용자 입력을 추가한다.
                self.diaryBody.myObjective = [self.userInput]
                //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                self.diaryBody.date = dateFormat.string(from: Date())
                
                //JSON으로 인코딩한다
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(self.diaryBody)
                let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                print("stringfiedJsonData : \(stringfiedJsonData!)")
                //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                    //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                print("writeDate : \(writeDate)")
                    //대망의 디비에 넣는 구분
                self.diaryDAO.newData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
            }
                self.userInput = ""
        }else if self.section2 == true{
            //주의할점 : 여기서는 오전 일기를 작성한것으로 판단하는 morning값을 1로 만들어줘야 한다.
            self.morning = 1
            if self.diaryBody.wantToDo != nil {//일기를 쓴적이 있는 경우
                //diaryBody의 해당에 사용자 입력을 추가한다.
                self.diaryBody.wantToDo?.append(self.userInput)
                //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                self.diaryBody.date = dateFormat.string(from: Date())
                
                //JSON으로 인코딩한다
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(self.diaryBody)
                let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                print("stringfiedJsonData : \(stringfiedJsonData!)")
                //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                    //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                print("writeDate : \(writeDate)")
                    //대망의 디비에 넣는 구분
                self.diaryDAO.editData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
            }else{//일기를 쓴적이 없는 경우
                print("일기를 처음 쓰는구먼유!")
                //diaryBody의 해당에 사용자 입력을 추가한다.
                self.diaryBody.wantToDo = [self.userInput]
                //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                self.diaryBody.date = dateFormat.string(from: Date())
                
                //JSON으로 인코딩한다
                let encoder = JSONEncoder()
                let jsonData = try? encoder.encode(self.diaryBody)
                let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                print("stringfiedJsonData : \(stringfiedJsonData!)")
                //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                    //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                print("writeDate : \(writeDate)")
                    //대망의 디비에 넣는 구분
                self.diaryDAO.newData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
            }
                self.userInput = ""
                
        }else if self.section3 == true{
            //오늘 있었던일을 쓰면 오후것도 작성한것으로 친다
            self.night = 1
               if self.diaryBody.whatHappened != nil {//일기를 쓴적이 있는 경우
                    //diaryBody의 해당에 사용자 입력을 추가한다.
                    self.diaryBody.whatHappened?.append(self.userInput)
                    //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                    self.diaryBody.date = dateFormat.string(from: Date())
                    
                    //JSON으로 인코딩한다
                    let encoder = JSONEncoder()
                    let jsonData = try? encoder.encode(self.diaryBody)
                    let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                    print("stringfiedJsonData : \(stringfiedJsonData!)")
                    //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                        //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                    dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                    print("writeDate : \(writeDate)")
                        //대망의 디비에 넣는 구분
                    self.diaryDAO.editData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
                }else{//일기를 쓴적이 없는 경우
                    print("일기를 처음 쓰는구먼유!")
                    //diaryBody의 해당에 사용자 입력을 추가한다.
                    self.diaryBody.whatHappened = [self.userInput]
                    //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                    self.diaryBody.date = dateFormat.string(from: Date())
                    
                    //JSON으로 인코딩한다
                    let encoder = JSONEncoder()
                    let jsonData = try? encoder.encode(self.diaryBody)
                    let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                    print("stringfiedJsonData : \(stringfiedJsonData!)")
                    //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                        //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                    dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                    print("writeDate : \(writeDate)")
                        //대망의 디비에 넣는 구분
                    self.diaryDAO.newData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
                }
                    self.userInput = ""
        }else if self.section4 == true{
                if self.diaryBody.gratitude != nil {//일기를 쓴적이 있는 경우
                    //diaryBody의 해당에 사용자 입력을 추가한다.
                    self.diaryBody.gratitude?.append(self.userInput)
                    //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                    self.diaryBody.date = dateFormat.string(from: Date())
                    
                    //JSON으로 인코딩한다
                    let encoder = JSONEncoder()
                    let jsonData = try? encoder.encode(self.diaryBody)
                    let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                    print("stringfiedJsonData : \(stringfiedJsonData!)")
                    //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                        //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                    print("writeDate : \(writeDate)")
                        //대망의 디비에 넣는 구분
                    self.diaryDAO.editData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
                }else{//일기를 쓴적이 없는 경우
                    print("일기를 처음 쓰는구먼유!")
                    //diaryBody의 해당에 사용자 입력을 추가한다.
                    self.diaryBody.gratitude = [self.userInput]
                    //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                    self.diaryBody.date = dateFormat.string(from: Date())
                    
                    //JSON으로 인코딩한다
                    let encoder = JSONEncoder()
                    let jsonData = try? encoder.encode(self.diaryBody)
                    let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                    print("stringfiedJsonData : \(stringfiedJsonData!)")
                    //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                        //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                    dateFormat.dateFormat = "yyyy-MM-dd"
                    let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                    print("writeDate : \(writeDate)")
                        //대망의 디비에 넣는 구분
                    self.diaryDAO.newData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
                }
                    self.userInput = ""
        }else if self.section5 == true{
               if self.diaryBody.success != nil {//일기를 쓴적이 있는 경우
                    //diaryBody의 해당에 사용자 입력을 추가한다.
                    self.diaryBody.success?.append(self.userInput)
                    //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                    self.diaryBody.date = dateFormat.string(from: Date())
                    
                    //JSON으로 인코딩한다
                    let encoder = JSONEncoder()
                    let jsonData = try? encoder.encode(self.diaryBody)
                    let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                    print("stringfiedJsonData : \(stringfiedJsonData!)")
                    //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                        //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                    dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                    print("writeDate : \(writeDate)")
                        //대망의 디비에 넣는 구분
                    self.diaryDAO.editData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
                }else{//일기를 쓴적이 없는 경우
                    print("일기를 처음 쓰는구먼유!")
                    //diaryBody의 해당에 사용자 입력을 추가한다.
                    self.diaryBody.success = [self.userInput]
                    //date값도 지금 시각으로 수정한다.(db의 data항목 안에 들어갈 녀석임. pk로 쓰는녀석이 아니고)
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy.MM.dd.HH:mm"
                    self.diaryBody.date = dateFormat.string(from: Date())
                    
                    //JSON으로 인코딩한다
                    let encoder = JSONEncoder()
                    let jsonData = try? encoder.encode(self.diaryBody)
                    let stringfiedJsonData = String(data: jsonData!, encoding: .utf8) //리턴값은 옵셔널이넹
                    print("stringfiedJsonData : \(stringfiedJsonData!)")
                    //이제 db에 넣어주자...일기를 쓴적이 있는 경우니까 editData를 써야 한다!
                        //일기의 날짜는 self.sendedDate에 들어있으므로 이거를 pk로 써서 해당 db를 찾는데 써야 하므로 적절한 형변환을 시켜줘야 한다.(sendedDate는 초까지 나오니깐...)
                    dateFormat.dateFormat = "yyyy-MM-dd"
                let writeDate = dateFormat.string(from: self.sendedDate!.toGlobalTime())
                    print("writeDate : \(writeDate)")
                        //대망의 디비에 넣는 구분
                    self.diaryDAO.newData(writeDate: writeDate, morning: self.morning, night: self.night, backup: self.did_backup, data: stringfiedJsonData!)
                }
                    self.userInput = ""
        }else{
            print("섹션0부터4까지 모두 false임다이건뭔가 잘못됫슴다")
        }
        
        
        //section변수들을 false로 초기화한다.
        self.section5 = false
        self.section1 = false
        self.section2 = false
        self.section3 = false
        self.section4 = false
        
        //추가하려고 했던 셀을 원래대로 되돌려놓는다.
        self.tableView.reloadData()
        
        //키보드를 내린다
        self.resignFirstResponder()

    }

}

