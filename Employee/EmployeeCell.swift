//
//  EmployeeCell.swift
//  Employee
//
//  Created by Thamizhvel on 30/07/22.
//

import UIKit

class EmployeeCell: UITableViewCell {

    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var empCompanyName: UILabel!

    @IBOutlet weak var empImge: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.empImge.layer.cornerRadius = self.empImge.frame.height/2
        self.empImge.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
