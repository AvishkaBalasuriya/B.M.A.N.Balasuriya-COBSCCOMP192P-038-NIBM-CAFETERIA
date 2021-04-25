//
//  OrderViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import UIKit


class OrderTableCustomCell: UITableViewCell {
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
}

class OrderViewController: UIViewController {
    @IBOutlet weak var tableOrderView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    let firestoreDataService = FirestoreDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        self.firestoreDataService.getAllOrders(){
            completion in
            
            self.tableOrderView.delegate=self
            self.tableOrderView.dataSource=self
            self.tableOrderView.isHidden = (OrderData.orderList.count == 0 ?true:false)
            self.noDataView.isHidden = (OrderData.orderList.count == 0 ?false:true)
            self.tableOrderView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.firestoreDataService.getAllOrders(){
            completion in
            
            self.tableOrderView.delegate=self
            self.tableOrderView.dataSource=self
            self.tableOrderView.isHidden = (OrderData.orderList.count == 0 ?true:false)
            self.noDataView.isHidden = (OrderData.orderList.count == 0 ?false:true)
            self.tableOrderView.reloadData()
        }
    }
}

extension OrderViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension OrderViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderData.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderTableCustomCell =  tableView.dequeueReusableCell(withIdentifier: "tblOrderData") as! OrderTableCustomCell
        cell.lblOrderId.text = "Order ID "+Array(OrderData.orderList)[indexPath.row].value.orderId
        cell.lblOrderStatus.text = String(Array(OrderData.orderList)[indexPath.row].value.status)
        return cell
    }
}
