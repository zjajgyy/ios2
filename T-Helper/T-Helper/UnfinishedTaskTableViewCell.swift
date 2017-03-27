//
//  UnfinishedTaskTableViewCell.swift
//  T-Helper
//
//  Created by 李鹏翔 on 2016/12/2.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit

class UnfinishedTaskTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    var checked: Bool = false
    
    var id: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        //print(detailLabel.text)
        //self.changeStatus()
    }
    
    @IBAction func clickRadioBtn(_ sender: UIButton) {
        //self.changeStatus()
    }
    
//    func changeStatus() -> Void {
//
//        if checked {
//            checkBtn.setBackgroundImage(#imageLiteral(resourceName: "radio"), for: .normal)
//            checked = false
//            
//            print("cell \(detailLabel.text): disselected")
//        } else {
//            checkBtn.setBackgroundImage(#imageLiteral(resourceName: "radio-selected"), for: .normal)
//            checked = true
//            
//            print("cell \(detailLabel.text): selected")
//        }
//    }


}
