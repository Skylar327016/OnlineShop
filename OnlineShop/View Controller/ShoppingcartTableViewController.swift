//
//  ShoppingcartTableViewController.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/22.
//

import UIKit

class ShoppingcartTableViewController: UITableViewController {
    
    var cart = [CartItem]()
    @IBOutlet weak var totalLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataSource()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateDataSource()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Tool.shared.writeUserDefault(with: PropertyKeys.cart, and: self.cart)
    }
    func updateDataSource() {
        Tool.shared.readUserDefaultData(with: PropertyKeys.cart, and: [CartItem].self) { (cart) in
            guard let cart = cart else {return}
            self.cart = cart
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
    
}

extension ShoppingcartTableViewController: ShoppingcartTableViewCellDelegate {
    func showMessage() {
        Tool.shared.showAlert(in: self, with: "Hello World")
    }
}
