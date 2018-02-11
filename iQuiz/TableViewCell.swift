//
//  TableViewCell.swift
//  iQuiz
//
//  Created by Christy Lu on 2/11/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var descr: UILabel!
    //@IBOutlet weak var description: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
