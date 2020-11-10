//
//  LockScreen.swift
//  3MinuteDiary
//
//  Created by Boram Cho on 2020/11/07.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class Passcode: UIView {
    //code는 비밀번호
    var code: String = ""
    //최대몇자리?
    var maxLength = 4
    
}

//이걸 해줘야 키보드를 화면에 보여줄수 있게 된다
extension Passcode{
    override var canBecomeFirstResponder: Bool {
        return true
    }
}

extension Passcode: UIKeyInput{
    var hasText: Bool{
        return code.count > 0 //전역변수 code안에 문자열이 빈값이 아닌경우(한글자라도 들어있는경우) true을 반환하고 아닐경우 false를 반환함
    }
    func insertText(_ text: String) {
        print("inserted text: \(text)")
    }
    func deleteBackward() {
        print("delete key pressed")
    }
}
