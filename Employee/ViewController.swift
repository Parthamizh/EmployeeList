//
//  ViewController.swift
//  Employee
//
//  Created by Thamizhvel on 30/07/22.
//

import UIKit
import CoreData
import Kingfisher

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var employeeList = [Employee]()
    var companylist = [Company]()
    var addresslist = [Address]()
    
    var filterlist = [Employee]()

    @IBOutlet weak var employeeTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.deleteAllData("Employee")
//
//        self.deleteAllData("Company")
//
//        self.deleteAllData("Address")
//
//        self.deleteAllData("Geo")

        self.title = "Employee List"
        employeeTable.register(UINib.init(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.loadList()
        }
    }

    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try self.context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                self.context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }

    // MARK: - Load employee list
    
    func loadList()
    {
        let Employeerequest : NSFetchRequest<Employee> = Employee.fetchRequest()
        let Comanyrequest : NSFetchRequest<Company> = Company.fetchRequest()
        let Addressrequest : NSFetchRequest<Address> = Address.fetchRequest()


        do{
        self.employeeList = try context.fetch(Employeerequest)
            self.companylist = try context.fetch(Comanyrequest)
            self.addresslist = try context.fetch(Addressrequest)
            self.filterlist = employeeList
        }catch{
            print("error while fethcing")
        }
        if employeeList.count > 0{
            print(employeeList)
            self.employeeTable.reloadData()
        }
        else{
            self.getEmployeeDetailsList()
        }
    }
    
    func saveDatas(){
        
        do{
            try self.context.save()
        }catch{
            print("error while inserting...")
        }
    }
    
    // MARK: - API call
    func getEmployeeDetailsList(){
        
        let url = URL(string: "https://www.mocky.io/v2/5d565297300000680030a986")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!)
            
            do {
                if let results = try JSONSerialization.jsonObject(with: data) as? [[String:Any]] {
                    // results is now an array of dictionary, access what you need
                    print(results)
                    
                    for emp in results{
                        
                        let employee = Employee(context:self.context)

                        employee.id  = emp["id"] as! Int16
                        employee.name  = emp["name"] as? String
                        employee.username  = emp["username"] as? String
                        employee.email  = emp["email"] as? String
                        employee.profileImage  = emp["profile_image"] as? String
                        employee.phone  = emp["phone"] as? String
                        employee.website  = emp["website"] as? String
                        
                        self.saveDatas()
                        
                    }
                    
                    for emp in results{
                        
                        let address = Address(context:self.context)
                        address.street = (emp["address"] as! NSDictionary)["street"] as? String
                        address.suite = (emp["address"] as! NSDictionary)["suite"] as? String
                        address.city = (emp["address"] as! NSDictionary)["city"] as? String
                        address.zipcode = (emp["address"] as! NSDictionary)["zipcode"] as? String
//                        address.geo?.lat = ((emp["address"] as! NSDictionary)["geo"] as! NSDictionary)["lat"] as? String
//                        address.geo?.lat = ((emp["address"] as! NSDictionary)["geo"] as! NSDictionary)["lng"] as? String
                        self.saveDatas()
                        
                    }
                    for emp in results{
                        
                        let company = Company(context:self.context)
                        
                        company.name = (emp["company"] as? NSDictionary)?["name"] as? String
                        company.catchPhrase = (emp["company"] as? NSDictionary)?["catchphrase"] as? String
                        company.bs = (emp["company"] as? NSDictionary)?["bs"] as? String
                        self.saveDatas()
                        
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.loadList()
                    }
                    
                } else {
                    print("JSON was not the expected array of dictonary")
                }
            } catch {
                print("Can't process JSON: \(error)")
            }

        }

        task.resume()

    }

    // MARK: - Table View Data source and delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
        cell.empName.text = filterlist[indexPath.row].name ?? ""
        cell.empCompanyName.text = companylist[indexPath.row].name ?? ""
        cell.empImge.kf.setImage(
            with: URL.init(string: filterlist[indexPath.row].profileImage ?? ""),
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.empdetails = filterlist[indexPath.row]
        vc?.companydetail = companylist[indexPath.row]
        vc?.addressdetail = addresslist[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    

    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

}


extension ViewController:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterlist = searchText.isEmpty ? employeeList : employeeList.filter({ emp in
            if emp.name!.contains(searchBar.text!) {
                print("exists")
                return true
            }

            return false
        })

        self.employeeTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.filterlist = employeeList
        self.employeeTable.reloadData()
        self.searchBar.resignFirstResponder()
        
    }
}
