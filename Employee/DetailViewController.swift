//
//  DetailViewController.swift
//  Employee
//
//  Created by Thamizhvel on 30/07/22.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var empImage: UIImageView!
    
    @IBOutlet weak var empName: UILabel!
    @IBOutlet weak var empuserName: UILabel!

    @IBOutlet weak var empemail: UILabel!
    @IBOutlet weak var empwebsite: UILabel!
    @IBOutlet weak var empAddress: UILabel!
    @IBOutlet weak var empPhone: UILabel!
    @IBOutlet weak var empComapnyName: UILabel!

    var empdetails = Employee()
    var companydetail = Company()
    var addressdetail = Address()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.empName.text = empdetails.name
        self.empuserName.text = empdetails.username
        self.empemail.text = empdetails.email
        self.empwebsite.text = empdetails.website
        self.empPhone.text = empdetails.phone
        self.empAddress.text = (addressdetail.street ?? "") + ","  + (addressdetail.suite ?? "") + "," + (addressdetail.city ?? "") + "," + (addressdetail.zipcode ?? "") + ","
        self.empComapnyName.text = (companydetail.name ?? "") + "," + (companydetail.catchPhrase ?? "") + "," + (companydetail.bs ?? "") + ","
        
        self.empImage.kf.setImage(
            with: URL.init(string: empdetails.profileImage ?? ""),
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        self.empImage.layer.cornerRadius = self.empImage.frame.height/2
        self.empImage.clipsToBounds = true


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
