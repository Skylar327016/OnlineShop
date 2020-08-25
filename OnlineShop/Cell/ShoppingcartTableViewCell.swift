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
        guard let controller = delegate as? ShoppingcartTableViewController else {return}
        guard let cart = self.cart, let cartItem = self.cartItem else {return}
        CartItemController.shared.remove(cartItem: cartItem, in: cart) { (newCart) in
            guard let newCart = newCart else {return}
            self.cart = newCart
            controller.cart = newCart
            Tool.shared.writeUserDefault(with: PropertyKeys.cart, and: newCart)
            DispatchQueue.main.async {
                controller.tableView.reloadData()
            }
            
            
        }
    }
    @IBAction func changeQuantity(_ sender: UIButton) {
        guard let qty = quantityTextField.text, let currentQuantity = Int(qty) else {return} 
        if sender.tag == 0 {
            if currentQuantity > 1{
                let newQuantity = currentQuantity - 1
                updateQuantityAndSubtotalLabels(with: newQuantity)
            }else {
                delegate?.showMessage()
                
            }
        }else if sender.tag == 1{
            if currentQuantity < 5{
                let newQuantity = currentQuantity + 1
                updateQuantityAndSubtotalLabels(with: newQuantity)
            }else {
                delegate?.showMessage()
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
        self.loadCart(and: cartItem)
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
    func loadCart(and cartItem: CartItem) {
        self.cartItem = cartItem
        Tool.shared.readUserDefaultData(with: PropertyKeys.cart, and: [CartItem].self) { (cart) in
            guard let cart = cart else {return}
            self.cart = cart
        }
    }
    func updateQuantityAndSubtotalLabels(with quantity:Int) {
        guard let controller = delegate as? ShoppingcartTableViewController else {return}
        self.cartItem?.itemQuantity = String(quantity)
        guard let cart = cart, let cartItem = cartItem, let itemPrice = Int(cartItem.itemPrice) else {return}
        let newSubtotal = String(quantity * itemPrice)
        self.cartItem?.subtotal = newSubtotal
        CartItemController.shared.updateQuantityAndSubtotal(of: cartItem, with: quantity, and: newSubtotal, in: cart) { (newCart) in
            guard let newCart = newCart else {return}
            self.cart = newCart
            controller.cart = newCart
        }
        DispatchQueue.main.async {
            self.quantityTextField.text = String(quantity)
            self.itemPriceLabel.text = "NT$ "+newSubtotal
        }
    }
    
}
