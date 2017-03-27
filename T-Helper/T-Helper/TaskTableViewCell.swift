//
//  TaskTableViewCell.swift
//  T-Helper
//
//  Created by 李鹏翔 on 2016/11/28.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var detailLabel: UILabel!
    
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
    
    @IBAction func clickRadioBtn(_ sender: UIButton) {
        //self.changeStatus()
    }
    
//    func changeStatus() -> Void {
//        if checked {
//            checkBtn.setBackgroundImage(#imageLiteral(resourceName: "radio"), for: .normal)
//            checked = false
//        } else {
//            checkBtn.setBackgroundImage(#imageLiteral(resourceName: "radio-selected"), for: .normal)
//            checked = true
//        }
//    }
    
    
}
