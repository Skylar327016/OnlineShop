//
//  ShoppingcartTableViewCell.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/22.
//

import UIKit

class ShoppingcartTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
 
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemColorLabel: UILabel!
    @IBOutlet weak var itemSizeLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    var cartItem: CartItem?
    var cart:[CartItem]?
    var delegate: ShoppingcartTableViewCellDelegate?

    @IBAction func removeFromCart(_ sender: UIButton) {
        delegate?.confirmAction(with: { [self] (positive) in
            guard let positive = positive else {return}
            if positive {
                guard let controller = delegate as? ShoppingcartTableViewController else {return}
                guard let cartItem = self.cartItem else {return}
                CartManager.shared.remove(cartItem: cartItem) { [self] (newCart) in
                    guard let newCart = newCart else {return}
                    self.cart = newCart
                    DispatchQueue.main.async {
                        controller.tableView.reloadData()
                    }
                }
            }
        })
        

    }
    @IBAction func changeQuantity(_ sender: UIButton) {
        guard let qty = quantityTextField.text, let currentQuantity = Int(qty) else {return} 
        if sender.tag == 0 {
            if currentQuantity > 1{
                let newQuantity = currentQuantity - 1
                updateQuantityAndSubtotalLabels(with: newQuantity)
            }else {
                delegate?.confirmAction(with: { [self] (positive) in
                    guard let positive = positive else {return}
                    if positive {
                        guard let controller = delegate as? ShoppingcartTableViewController else {return}
                        guard let cartItem = self.cartItem else {return}
                        CartManager.shared.remove(cartItem: cartItem) { [self] (newCart) in
                            guard let newCart = newCart else {return}
                            self.cart = newCart
                            controller.cart = newCart
                            DispatchQueue.main.async {
                                controller.tableView.reloadData()
                            }
                        }
                    }
                })
                
            }
        }else if sender.tag == 1{
            if currentQuantity < 5{
                let newQuantity = currentQuantity + 1
                updateQuantityAndSubtotalLabels(with: newQuantity)
            }else {
                delegate?.showMessage(with: "一次只能購買最多五件")
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with cartItem: CartItem, at row: Int) {
        self.cart = CartManager.shared.shoppingcart
        self.cartItem = cartItem
        self.selectionStyle = .none
        DispatchQueue.main.async { [self] in
            let image = ProductController.shared.loadProductImage(with: cartItem.itemImageUrl)
            itemImageView.image = image
            itemNameLabel.text = cartItem.itemName
            itemPriceLabel.text = "NT$ \(cartItem.subtotal)"
            itemColorLabel.text = cartItem.itemColor
            itemSizeLabel.text = "Size: \(cartItem.itemSize)"
            quantityTextField.text = cartItem.itemQuantity
        }
        
    }

    func updateQuantityAndSubtotalLabels(with quantity:Int) {
        self.cartItem?.itemQuantity = String(quantity)
        guard let cartItem = cartItem, let itemPrice = Int(cartItem.itemPrice) else {return}
        let newSubtotal = String(quantity * itemPrice)
        self.cartItem?.subtotal = newSubtotal
        CartManager.shared.updateQuantityAndSubtotal(of: cartItem, with: quantity, and: newSubtotal) { [self] (newCart) in
            guard let newCart = newCart else {return}
            self.cart = newCart
            guard let controller = delegate as? ShoppingcartTableViewController, let footer = controller.footer else {return}
            DispatchQueue.main.async {
                self.quantityTextField.text = String(quantity)
                self.itemPriceLabel.text = "NT$ "+newSubtotal
                footer.setUp()
            }
        }
      
    }
    
}

