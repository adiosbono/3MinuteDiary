//
//  DiaryDAO.swift
//  3MinuteDiary
//
//  Created by Bono b Bono on 2020/02/02.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit
import FMDB

class DiaryDAO {
    
    //변수들을 여기에 정리한다
        //main 테이블의 데이터를 읽어오기 위한 변수 선언
        //순서대로 create_date, moring, night, did_backup, data임 (맨마지막 data는 일기내용을 json방식으로 저장하는곳임)
    typealias diaryRecord = (String, Int, Int, Int, String)
    
    
    //디비사용위한 구문
    //SQLite 연결 및 초기화
       lazy var fmdb : FMDatabase! = {
           //파일매니저객체 생성(1022)
           let fileMgr = FileManager.default
           //샌드박스 내 문서디렉토리 주소를 따서 데이터베이스 파일 경로를 만든다
           let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
           let dbPath = docPath!.appendingPathComponent("db.sqlite").path
           
           //위에서 만든 경로에 파일이 없다면 메인 번들에 만들어 둔 db.sqlite를 가져와 복사
           if fileMgr.fileExists(atPath: dbPath) == false {
               let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
               try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
               print("번들에 들어있는 템플릿용 디비파일을 복사해서 문서디렉토리에 저장햇습니다")
           }
           
           //준비된 데이터베이스 파일을 바탕으로 FMDatabase객체 생성
           let db = FMDatabase(path: dbPath)
           //임시로 디비가 저장된 경로를 표시함...찾아볼껴 수정되는지 진짜로
           print(dbPath)
           
           
           return db
           
       }()
       
       //생성자와 소멸자를 정의
       init() {
           self.fmdb.open()
       }
       deinit {
           self.fmdb.close()
       }
    
    
    
    //디비의 메인테이블 목록을 읽어올 메소드 정의------------------------------------잘 작동하는지는 점검 아직 안됨
        func findMain() -> [diaryRecord] {
            //반환할 데이터를 담을 [diaryRecord] 타입의 객체 정의
            var diaryList = [diaryRecord]()
            
            do{
                //카드목록을 가져올 sql작성 및 쿼리 실행
                let sql = """
                    SELECT create_date, morning, night, did_backup, data
                    FROM main
                    ORDER BY create_date ASC
    """
                
                let rs = try self.fmdb.executeQuery(sql, values: nil)

                //결과 집합 추출
                while rs.next() {
                    let createDate = rs.string(forColumn: "create_date")
                    let morning = rs.int(forColumn: "morning")
                    let night = rs.int(forColumn: "night")
                    let did_backup = rs.int(forColumn: "did_backup")
                    let data = rs.string(forColumn: "data")
                    
                    //diaryRecord에 들어있는순서대로 create_date, moring, night, did_backup, data
                    diaryList.append((createDate!, Int(morning), Int(night), Int(did_backup), data!))
                }
                
            }catch let error as NSError {
                print("Failed from db: \(error.localizedDescription)")
            }
            return diaryList
        }
    
    
    
    
}
