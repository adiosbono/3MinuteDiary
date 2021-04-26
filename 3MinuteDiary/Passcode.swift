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
    
    //stack는 비번 한글자씩 입력받을때마다 한동그라미씩 칠해지는 뷰임...그런데 여기 Passcode.swift안에 넣는게 맞는지는 정확히 모르겠음(아마맞는듯)
    let stack = UIStackView()
    
    //code는 비밀번호
    var code: String = ""
    //최대몇자리?
    var maxLength = 4
    override init(frame: CGRect) {
        super.init(frame: frame)
        showKeyboardIfNeeded()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented asshole")
    }
    
    private func setupUI(){
        addSubview(stack)
        self.backgroundColor = .white
        stack.backgroundColor = .white
        stack.translatesAutoresizingMaskIntoConstraints = false //false를 주었다는건 시스템이 알아서 크기 조절하도록 허용한다는 뜻
        NSLayoutConstraint.activate([stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     stack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     stack.topAnchor.constraint(equalTo: self.topAnchor),
                                     stack.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        updateStack(by: code) //지금은 안만들어져 있지만... 이따 만들어질 함수를 호출하고 있다.
    }
    
    private func emptyPin() -> UIView {
        let pin = Pin()
        pin.pin.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return pin
    }
    
    private func pin() -> UIView {
        let pin = Pin()
        pin.pin.backgroundColor = .green
        return pin
    }
    
    private func updateStack(by code: String) {
        var emptyPins:[UIView] = Array(0..<maxLength).map{_ in emptyPin()} //관련된 설명은 아랫줄에 있음. 간단히 말하면 0부터 maxLength번호 전까지의 배열을 만든 다음 그것을 전부 emptyPin()으로 갈아치움
            //maxLength가 3인경우 [0,1,2,3] 이 우선 만들어지고 여기에 전부 치환하면[emptyPin(),emptyPin(),emptyPin(),emptyPin()] 이런녀석이 만들어 지는것임//..< 는 half-open range operator라고 하며 우측 숫자 포함하는 범위
        //Creates an array containing the elements of a sequence.
        ///
        /// You can use this initializer to create an array from any other type that
        /// conforms to the `Sequence` protocol. For example, you might want to
        /// create an array with the integers from 1 through 7. Use this initializer
        /// around a range instead of typing all those numbers in an array literal.
        ///
        ///     let numbers = Array(1...7)
        ///     print(numbers)
        ///     // Prints "[1, 2, 3, 4, 5, 6, 7]"
        ///
        /// You can also use this initializer to convert a complex sequence or
        /// collection type back to an array. For example, the `keys` property of
        /// a dictionary isn't an array with its own storage, it's a collection
        /// that maps its elements from the dictionary only when they're
        /// accessed, saving the time and space needed to allocate an array. If
        /// you need to pass those keys to a method that takes an array, however,
        /// use this initializer to convert that list from its type of
        
        //map에 대한 설명
        /// Returns an array containing the results of mapping the given closure
        /// over the sequence's elements.
        ///`map` is used first to convert the names in the array
        /// to lowercase strings and then to count their characters.
        ///
        ///     let cast = ["Vivien", "Marlon", "Kim", "Karl"]
        ///     let lowercaseNames = cast.map { $0.lowercased() }
        ///     // 'lowercaseNames' == ["vivien", "marlon", "kim", "karl"]
        ///     let letterCounts = cast.map { $0.count }
        ///     // 'letterCounts' == [6, 6, 3, 4]
        ///
        /// - Parameter transform: A mapping closure. `transform` accepts an
        ///   element of this sequence as its parameter and returns a transformed
        ///   value of the same or of a different type.
        /// - Returns: An array containing the transformed elements of this
        ///   sequence.
        // 뒤치기뒤치기 뒤치기뒤치기
        let userPinLength = code.count
        let pins:[UIView] = Array(0..<userPinLength).map{_ in pin()}
        
        for (index, element) in pins.enumerated() {
            
        }
    }
    
}

//이걸 해줘야 키보드를 화면에 보여줄수 있게 된다
extension Passcode{
    override var canBecomeFirstResponder: Bool {
        return true
    }
    private func showKeyboardIfNeeded(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    @objc private func showKeyboard(){
        self.becomeFirstResponder()
    }
}

extension Passcode: UIKeyInput{
    var hasText: Bool{
        return code.count > 0 //전역변수 code안에 문자열이 빈값이 아닌경우(한글자라도 들어있는경우) true을 반환하고 아닐경우 false를 반환함
    }
    func insertText(_ text: String) {
        print("inserted text: \(text)")
        if code.count == maxLength{
            print("code over maxLength")
            return //최대값을 넘어가는 값에 대해선 저장되지 않도록 하는 기능... 함수 실행을 여기서 끝낸다
        }
        code.append(contentsOf: text)
        print("now code: \(code)")
    }
    func deleteBackward() {
        print("delete key pressed")
        if hasText {
            code.removeLast()
        }
        print("now code: \(code)")
    }
}
