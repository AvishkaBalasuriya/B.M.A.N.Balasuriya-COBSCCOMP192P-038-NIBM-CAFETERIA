//
//  ProfileViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-05.
//

import UIKit

struct BillObjects{
    var sectionName:String!
    var sectionObjects:[Any]!
    var sectionTotal:Float
}

var objectsBillArray=[BillObjects]()

class BillCellViewController:UITableViewCell{
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var tblBill: UITableView!
    @IBOutlet weak var pkrStartDate: UIDatePicker!
    @IBOutlet weak var pkrEndDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirestoreDataService().getOrdersByStatus(status: 4){
            completion in
            self.makeDateArray(isFilter: false)
            self.pkrEndDate.isHidden=true
            self.tblBill.delegate=self
            self.tblBill.dataSource=self
            self.lblUsername.text=UserData.emailAddress
            self.lblMobileNumber.text=UserData.mobileNumber
            self.btnLogout.addTarget(self, action: #selector(self.logout(sender:)), for: .touchUpInside)
            self.tblBill.reloadData()
        }
    }
    
    private func makeDateArray(isFilter:Bool){
        objectsBillArray.removeAll()
        self.sectionItem.removeAll()
        self.grandTotal=0.0
        
        var orders:[Order]!
        
        if isFilter{
            orders=BillOrderData.billOrderList
        }else{
            orders=BillOrderData.billOrderList
        }
        
        for order in orders{
            let dateFormatter=DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd"
            let sectionName = dateFormatter.string(from: order.timestamp)
            
            if !self.sectionItem.keys.contains(sectionName){
                self.sectionItem[sectionName]=[]
                self.sectionItem[sectionName]?.append(order)
            }else{
                self.sectionItem[sectionName]?.append(order)
            }
        }
        for (key,_) in self.sectionItem{
            self.sectionItem[key]?.append(true)
        }
        for (key,value) in self.sectionItem{
            var sectionTotal:Float=0.0
            for sectionOrder in value{
                if sectionOrder is Order{
                    let sectionOrderData = sectionOrder as! Order
                    sectionTotal+=sectionOrderData.total
                }
            }
            self.grandTotal+=sectionTotal
            objectsBillArray.append(BillObjects(sectionName: key, sectionObjects: value,sectionTotal:sectionTotal))
        }
        
        self.lblTotal.text = (String(self.grandTotal)=="0.0") ? "No Sale" : String(self.grandTotal)
    }
    
    @IBAction func pkrStartDate(sender: UIDatePicker) {
        self.startDate=sender.date
        self.pkrEndDate.maximumDate=self.startDate
        self.pkrEndDate.isHidden=false
    }
    
    @IBAction func pkrEndDate(sender: UIDatePicker) {
        self.endDate=sender.date
        firestoreDataService().getOrdersByDateRange(start: self.startDate, end:self.endDate,status: 4){
            completion in
            self.makeDateArray(isFilter: true)
            self.tblBill.reloadData()
        }
    }
    
    @objc func logout(sender:UIButton){
        UserDefaults.standard.set(false, forKey: "isLogged")
        let storeTabBarController = self.storyboard?.instantiateViewController(withIdentifier:"LoginViewController") as? LoginViewController
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(storeTabBarController!,animated: true)
    }
}

extension ProfileViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ProfileViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsBillArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsBillArray[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.systemGreen
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if objectsBillArray.count == 0 {
            self.tblBill.setEmptyView(title: "No orders", message: "Your orders will display in here")
            self.btnPrintHistory.isHidden=true
        } else {
            self.btnPrintHistory.isHidden=false
            self.tblBill.restore()
        }
        return objectsBillArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(objectsBillArray[indexPath.section].sectionObjects[indexPath.row] is Order){
            return 80
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(objectsBillArray[indexPath.section].sectionObjects[indexPath.row] is Order){
            let orderData = objectsBillArray[indexPath.section].sectionObjects[indexPath.row] as! Order
            
            let cell:BillCellViewController =  tableView.dequeueReusableCell(withIdentifier: "cellBill") as! BillCellViewController
            
            cell.lblOrderId.text=orderData.orderId
            cell.lblOrderTotal.text=String(orderData.total)
            
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
            cell.layer.masksToBounds = false
            return cell
        }else{
            let cell:BillCellPrintViewController =  tableView.dequeueReusableCell(withIdentifier: "cellBillPrint") as! BillCellPrintViewController
            
            cell.lblTotalDay.text="Day total: "+String(objectsBillArray[indexPath.section].sectionTotal)
            
            cell.layer.backgroundColor = UIColor.systemGray.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
            cell.layer.masksToBounds = false
            return cell
        }
    }
}
