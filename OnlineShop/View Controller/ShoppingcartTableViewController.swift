//
//  ShoppingcartTableViewController.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/22.
//

import UIKit

class ShoppingcartTableViewController: UITableViewController {
    
    var cart = [CartItem]()
    var heightForHeader:CGFloat = 0.0
    var heightForFooter:CGFloat = 0.0
    var footer: FooterViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataSource()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        updateDataSource()
    }
    func updateDataSource() {
        self.cart = CartManager.shared.shoppingcart
        DispatchQueue.main.async { [self] in
            self.tableView.reloadData()
        }
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cart.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.shoppingcartCell, for: indexPath) as? ShoppingcartTableViewCell else {return UITableViewCell()}
        cell.configure(with: cart[indexPath.row], at: indexPath.row)
        cell.delegate = self
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if cart.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.header) as! HeaderViewCell
            return cell.contentView
        }else {
            return nil
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if cart.count == 0 {
            heightForHeader = tableView.frame.height
        }else {
            heightForHeader = 0
        }
        return heightForHeader
    }
 
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if cart.count == 0 {
            self.footer = nil
            return nil
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.footer) as! FooterViewCell
            if let total = CartManager.shared.getTotal() {
                let totalPrice = "NT$ "+total
                cell.setUp(with: totalPrice)
                self.footer = cell
            }
            return cell.contentView
        }
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if cart.count != 0 {
            heightForFooter = 90
        }else {
            heightForFooter = 0
        }
        return heightForFooter
    }
}


extension ShoppingcartTableViewController: ShoppingcartTableViewCellDelegate {
    func showMessage(with message: String) {
        Tool.shared.showAlert(in: self, with: message)
    }

    func confirmAction(with completionHandler: @escaping (Bool?) -> Void) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "刪除商品", style: .default, handler: { (_) in
            completionHandler(true)
        }))
        controller.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {
            (_) in
            completionHandler(false)
        }))
        present(controller, animated: true, completion: nil)
    }
}
