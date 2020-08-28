//
//  Cart.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/27.
//

import Foundation
struct CartManager{
    static var shared = CartManager(shoppingcart: [CartItem]())
    var shoppingcart:[CartItem]
    
    mutating func updateQuantityAndSubtotal(of cartItem: CartItem, with newQuantity: Int, and subtotal: String, with completion: @escaping ([CartItem]?) -> Void) {
        guard let cartItemIndex = shoppingcart.firstIndex(of: cartItem) else {return}
        shoppingcart[cartItemIndex].itemQuantity = String(newQuantity)
        shoppingcart[cartItemIndex].subtotal = subtotal
        completion(shoppingcart)

    }
    mutating func remove(cartItem: CartItem, completion: @escaping ([CartItem]?) -> Void){
        guard let cartItemIndex = shoppingcart.firstIndex(of: cartItem) else {return}
        shoppingcart.remove(at: cartItemIndex)
        completion(shoppingcart)
    }
    func getTotal() -> String?{
        var total = 0
        for cartItem in shoppingcart {
            guard let quantity = Int(cartItem.itemQuantity), let price = Int(cartItem.itemPrice) else {return nil}
            total += quantity * price
        }
        return String(total)
    }
}
