//
//  CartItemController.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/25.
//

import Foundation
struct CartItemController {
    static let shared = CartItemController()
    
    func newCartItem(with product: Product, chosenColor: String, chosenIndex: Int, quantity: String) -> CartItem {
        let itemImageUrl = product.imageUrl
        let itemName = product.productName
        let itemPrice = product.productPrice
        let itemColor = chosenColor
        var subtotal = 0
        if let itemPrice = Int(product.productPrice), let itemQuantity = Int(quantity) {
            subtotal = itemPrice * itemQuantity
        }
        let itemSize = ProductController.shared.getProductSize(with: chosenIndex)
        let cartItem = CartItem(itemImageUrl: itemImageUrl, itemName: itemName, itemColor: itemColor, itemSize: itemSize, itemQuantity: quantity, itemPrice: itemPrice, subtotal: String(subtotal))
        return cartItem
    }
    
    func updateQuantityAndSubtotal(of cartItem: CartItem, with newQuantity: Int, and subtotal: String, in cart: [CartItem], with completion: @escaping ([CartItem]?) -> Void) {
        var newCart = cart
        guard let cartItemIndex = cart.firstIndex(of: cartItem) else {return}
        newCart[cartItemIndex].itemQuantity = String(newQuantity)
        newCart[cartItemIndex].subtotal = subtotal
        completion(newCart)

    }
    func remove(cartItem: CartItem, in cart: [CartItem], completion: @escaping ([CartItem]?) -> Void){
        var newCart = cart
        guard let cartItemIndex = cart.firstIndex(of: cartItem) else {return}
        newCart.remove(at: cartItemIndex)
        completion(newCart)
    }
}
