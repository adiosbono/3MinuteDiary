//
//  settingCellWithSwitch.swift
//  3MinuteDiary
//
//  Created by Boram Cho on 2020/09/03.
//  Copyright © 2020 Bono b Bono. All rights reserved.
//

import Foundation
import UIKit

class SettingCellWithSwith: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBAction func toggleSW(_ sender: UISwitch) {
        if row == nil {
            print("row is fucking nil")
        }else{
            print("row: \(row!)")
            switch row {
            case 2:
                print("goto icloudBackupActivate with \(toggleValue.isOn)")
                backupManageViewController?.icloudBackupActivate(toggle: toggleValue.isOn)
            case 3:
                print("goto backupPhotoToo with \(toggleValue.isOn)")
                backupManageViewController?.backupPhotoToo(toggle: toggleValue.isOn)
            case 5:
                print("goto lockupSetting with \(toggleValue.isOn)")
                backupManageViewController?.lockupSetting(toggle: toggleValue.isOn)
            default :
                print("I dunno why this else phrase is called...row: \(row!)")
            }
        }
    }
    @IBOutlet var toggleValue: UISwitch!
    var row: Int?
    var backupManageViewController: BackupManageVC?
}
