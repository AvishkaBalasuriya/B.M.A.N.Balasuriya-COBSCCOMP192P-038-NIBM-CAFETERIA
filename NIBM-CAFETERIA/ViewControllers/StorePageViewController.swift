//
//  StorePageViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import UIKit
import MaterialComponents.MaterialButtons

class StoreTableCustomCell: UITableViewCell {
    @IBOutlet weak var imgFoodImage: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblFoodPrice: UILabel!
    @IBOutlet weak var lblFoodDiscount: UILabel!
    
}

class CartTableCustomCell: UITableViewCell {
    @IBOutlet weak var lblCartFoodName: UILabel!
    @IBOutlet weak var stpFoodQty: UIStepper!
    @IBOutlet weak var lblCartFoodPrice: UILabel!
}

class StorePageViewController: UIViewController {

    @IBOutlet weak var storeTableView: UITableView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var foodCartView: UIView!
    @IBOutlet weak var lblQtyCount: UILabel!
    var floatingButton = MDCFloatingButton()
    var firebaseFoodData=FirebaseService()
    let firestoreDataService = FirestoreDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firestoreDataService.fetchItems(){
            completion in
            
            if completion{
                self.setFloatingButton()
                self.lblItemCount.text!=String(CartData.cartItemList.count)+" Items"
                self.storeTableView.delegate=self
                self.storeTableView.dataSource=self
                self.storeTableView.isHidden = (ItemData.itemList.count==0 ? true:false)
                self.cartTableView.delegate=self
                self.cartTableView.dataSource=self
                self.foodCartView.isHidden = (CartData.cartItemList.count==0 ? true:false)
                self.storeTableView.reloadData()
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        foodCartView.isHidden = (CartData.cartItemList.count==0 ? true:false)
        floatingButton.isHidden = (CartData.cartItemList.count==0 ? true:false)
        cartTableView.reloadData()
        storeTableView.reloadData()
        lblItemCount.text!=String(CartData.cartItemList.count)+" Items"
    }
    
    func setFloatingButton() {
        floatingButton.mode = .expanded
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setTitle("Order", for: .normal)
        floatingButton.backgroundColor = .systemYellow
        floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(floatingButton)
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant:-50))
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
    }
    
    @objc func tap(_ sender: Any) {
        let order = Order(orderId: generateOrderId(), userEmailAddress: UserData.emailAddress, items: CartData.cartItemList, total: generateOrderTotal(), status: 0)
        OrderData.order=order
        let orderViewController = storyboard?.instantiateViewController(withIdentifier:"OrderView") as? OrderViewController
        self.navigationController?.pushViewController(orderViewController!, animated: true)
    }
    @IBAction func stpQtyUpdate(_ sender: UIStepper) {
        let itemId = sender.accessibilityIdentifier
        for item in CartData.cartItemList{
            if(String(item.itemId)==itemId){
                item.itemQty=Int(sender.value)
                item.totalPrice=item.itemPrice * Float(item.itemQty)
            }
        }
        cartTableView.reloadData()
    }
    
}

extension StorePageViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodViewController = storyboard?.instantiateViewController(withIdentifier:"FoodView") as? FoodViewController
        foodViewController?.itemDetails = ItemData.itemList[indexPath.row]
        self.navigationController?.pushViewController(foodViewController!, animated: true)
    }
}

extension StorePageViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == storeTableView{
            return ItemData.itemList.count
        }else if tableView == cartTableView{
            return CartData.cartItemList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == storeTableView{
            let cell:StoreTableCustomCell =  tableView.dequeueReusableCell(withIdentifier: "tbvCell") as! StoreTableCustomCell
            cell.imgFoodImage.image = UIImage(named: ItemData.itemList[indexPath.row].itemThumbnail)
            cell.lblFoodName.text = ItemData.itemList[indexPath.row].itemName
            cell.lblFoodDescription.text = ItemData.itemList[indexPath.row].itemDescription
            cell.lblFoodPrice.text = String(format:"%.2f", ItemData.itemList[indexPath.row].itemPrice)
            cell.lblFoodDiscount.text = String(format:"%.2f", ItemData.itemList[indexPath.row].itemDiscount)
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
            cell.layer.masksToBounds = false
            return cell
        }else if tableView == cartTableView{
            let cell:CartTableCustomCell =  tableView.dequeueReusableCell(withIdentifier: "tbvCartCell") as! CartTableCustomCell
            cell.lblCartFoodName.text=ItemData.itemList[indexPath.row].itemName
            cell.stpFoodQty.accessibilityIdentifier=String(CartData.cartItemList[indexPath.row].itemId)
            cell.lblCartFoodPrice.text=String(format:"%.2f", CartData.cartItemList[indexPath.row].totalPrice)
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
            cell.layer.masksToBounds = false
            return cell
        }else{
            let cell:UITableViewCell=UITableViewCell()
            return cell
        }
        
    }
}
