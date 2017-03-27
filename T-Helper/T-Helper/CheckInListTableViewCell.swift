//
//  CheckInListTableViewCell.swift
//  T-Helper
//
//  Created by 陈陈陈 on 2016/11/26.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit

class CheckInListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var planLabel: UILabel!
    var checked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        //self.changeStatus()
    }
    
//    @IBAction func checkButton(_ sender: UIButton) {
//        self.changeStatus()
//
//    }

    func changeStatus() -> Void {
        if checked {
            //checkButton.setBackgroundImage(#imageLiteral(resourceName: "radio"), for: .normal)
            checked = false
        } else {
            //checkButton.setBackgroundImage(#imageLiteral(resourceName: "radio-selected"), for: .normal)
            checked = true
        }
    }

}
