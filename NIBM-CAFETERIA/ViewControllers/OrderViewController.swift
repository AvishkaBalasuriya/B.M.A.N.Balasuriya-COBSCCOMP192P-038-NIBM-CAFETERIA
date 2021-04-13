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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableOrderView.delegate=self
        tableOrderView.dataSource=self
        tableOrderView.isHidden = (OrderData.order.orderId != "" ?true:false)
        noDataView.isHidden = (OrderData.order.orderId != "" ?false:true)
    }
}

extension OrderViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension OrderViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderData.itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderTableCustomCell =  tableView.dequeueReusableCell(withIdentifier: "tblOrderData") as! OrderTableCustomCell
        cell.lblOrderId.text = "Order ID "+String(OrderData.orderId)
        cell.lblOrderStatus.text = OrderData.orderStatus as! String
        return cell
    }
}
