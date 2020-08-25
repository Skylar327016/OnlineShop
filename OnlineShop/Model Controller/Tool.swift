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
    func setLoadingView(in viewController: UIViewController, with loadingView: UIActivityIndicatorView) -> UIActivityIndicatorView{
        let view = viewController.view!
        let frame = CGRect(origin: .zero, size: viewController.view.frame.size)
        loadingView.frame = frame
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        loadingView.startAnimating()
        loadingView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        loadingView.color = UIColor(red: CGFloat(255/255), green: CGFloat(214/255), blue: CGFloat(222/255), alpha: 1)
        loadingView.hidesWhenStopped = true
        loadingView.style = .large
        loadingView.alpha = 1
        return loadingView
    }
    func setLoadingView(in viewController: UITableViewController, with loadingView: UIActivityIndicatorView) -> UIActivityIndicatorView{
        let view = viewController.view!
        let frame = CGRect(origin: .zero, size: viewController.view.frame.size)
        loadingView.frame = frame
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        loadingView.startAnimating()
        loadingView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        loadingView.color = UIColor(red: CGFloat(255/255), green: CGFloat(214/255), blue: CGFloat(222/255), alpha: 1)
        loadingView.hidesWhenStopped = true
        loadingView.style = .large
        loadingView.alpha = 1
        return loadingView
    }
    func loading(activity indicator: UIActivityIndicatorView,  is stillLoading:Bool) {
        DispatchQueue.main.async {
            if stillLoading {
                indicator.startAnimating()
                
            }else {
                indicator.stopAnimating()
            }
        }
       
    }
}
