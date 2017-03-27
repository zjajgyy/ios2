//
//  CheckInDetailListTableViewCell.swift
//  T-Helper
//
//  Created by zjajgyy on 2016/11/26.
//  Copyright © 2016年 thelper. All rights reserved.
//

import UIKit

class CheckInDetailListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkInNumberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var taskButton: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
