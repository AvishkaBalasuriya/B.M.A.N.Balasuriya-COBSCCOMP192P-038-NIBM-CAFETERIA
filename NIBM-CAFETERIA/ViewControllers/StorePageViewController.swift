//
//  StorePageViewController.swift
//  NIBM-CAFETERIA
//
//  Created by Avishka Balasuriya on 2021-03-04.
//

import UIKit

class StoreTableCustomCell: UITableViewCell {
    @IBOutlet weak var imgFoodImage: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblFoodPrice: UILabel!
    @IBOutlet weak var lblFoodDiscount: UILabel!
    
}

class CartTableCustomCell: UITableViewCell {
    @IBOutlet weak var lblCartFoodName: UILabel!
    @IBOutlet weak var stpCartQty: UIStepper!
    @IBOutlet weak var lblCartFoodPrice: UILabel!
}

class StorePageViewController: UIViewController {

    @IBOutlet weak var storeTableView: UITableView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var lblItemCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFoodData()
        lblItemCount.text!=String(CartData.cartList.count)+" Items"
        storeTableView.delegate=self
        storeTableView.dataSource=self
        cartTableView.delegate=self
        cartTableView.dataSource=self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartTableView.reloadData()
        lblItemCount.text!=String(CartData.cartList.count)+" Items"
    }
    
}


extension StorePageViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodViewController = storyboard?.instantiateViewController(withIdentifier:"FoodView") as? FoodViewController
        foodViewController?.foodDetails = FoodData.foodList[indexPath.row]
        self.navigationController?.pushViewController(foodViewController!, animated: true)
    }
}

extension StorePageViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == storeTableView{
            return FoodData.foodList.count
        }else if tableView == cartTableView{
            return CartData.cartList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == storeTableView{
            let cell:StoreTableCustomCell =  tableView.dequeueReusableCell(withIdentifier: "tbvCell") as! StoreTableCustomCell
            cell.imgFoodImage.image = UIImage(named: FoodData.foodList[indexPath.row].foodPhoto)
            cell.lblFoodName.text = FoodData.foodList[indexPath.row].foodName
            cell.lblFoodDescription.text = FoodData.foodList[indexPath.row].foodDescription
            cell.lblFoodPrice.text = String(format:"%.2f", FoodData.foodList[indexPath.row].foodPrice)
            cell.lblFoodDiscount.text = String(format:"%.2f", FoodData.foodList[indexPath.row].foodDiscount)
            return cell
        }else if tableView == cartTableView{
            let cell:CartTableCustomCell =  tableView.dequeueReusableCell(withIdentifier: "tbvCartCell") as! CartTableCustomCell
            cell.lblCartFoodName.text=CartData.cartList[indexPath.row].foodName
            cell.stpCartQty.minimumValue=Double(CartData.cartList[indexPath.row].foodQty)
            cell.lblCartFoodPrice.text=String(format:"%.2f", CartData.cartList[indexPath.row].totalPrice)
            return cell
        }else{
            let cell:UITableViewCell=UITableViewCell()
            return cell
        }
        
    }
}
