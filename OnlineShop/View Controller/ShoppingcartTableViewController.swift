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
        super.viewWillAppear(false)
        updateDataSource()
    }
    func updateDataSource() {
        self.cart = CartManager.shared.shoppingcart
        DispatchQueue.main.async {
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
    
}

extension ShoppingcartTableViewController: ShoppingcartTableViewCellDelegate {
    func showMessage() {
        Tool.shared.showAlert(in: self, with: "Hello World")
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
