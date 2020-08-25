//
//  Tool.swift
//  OnlineShop
//
//  Created by 陳家豪 on 2020/8/24.
//

import Foundation
import UIKit
struct Tool {
    static let shared = Tool()
    let userDefault = UserDefaults.standard
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    func showAlert(in viewController: UIViewController, with message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
        }))
        viewController.present(controller, animated: true, completion: nil)
    }

    func readUserDefaultData<T>(with key: String, and type: T.Type, with completionHandler: @escaping (T?) -> Void) where T : Decodable {
        if let data = userDefault.data(forKey: key) {
            guard let object = try? jsonDecoder.decode(type.self, from: data) else {return}
            completionHandler(object)
        }else{
            completionHandler(nil)
        }
    }
    
    func writeUserDefault<T>(with key:String, and value: T) where T: Encodable {
        if let data = try? jsonEncoder.encode(value) {
            userDefault.setValue(data, forKey:key)
print("資料儲存成功")
        }
    }
}
