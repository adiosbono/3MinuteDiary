//
//  PasscodeViewController.swift
//  3MinuteDiary
//
//  Created by Boram Cho on 2020/11/07.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class PasscodeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        let passcode = Passcode()
        passcode.backgroundColor = .red
        passcode.frame = CGRect(x: 100, y: 100, width: 300, height: 44)
        view.addSubview(passcode)
        //becomeFirstResponder를 호출해주면 키보드가 올라올 것이다
        passcode.becomeFirstResponder()
    }
}
