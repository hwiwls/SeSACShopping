//
//  ProductDatailViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/22/24.
//

import UIKit
import WebKit

class ProductDatailViewController: UIViewController {
    
    @IBOutlet weak var productWebView: WKWebView!
    
    var productTitle = ""
    var productUrl = ""
    var productID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configNav()
        requestWebView()
    }
    
    func configNav() {
        navigationItem.title = productTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(backToPrevios))
        navigationItem.leftBarButtonItem = item
        
       
        // 좋아요 버튼 기능 구현
        let isLike = UserDefaultManager.shared.likeProduct.contains(productID)
        let item2 = UIBarButtonItem(image: UIImage(systemName: isLike ? "heart.fill" : "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(likeBtnClicked))
        navigationItem.rightBarButtonItem = item2
    }
    
    @objc func backToPrevios() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func likeBtnClicked() {
        var likeProducts = UserDefaultManager.shared.likeProduct

        if let index = likeProducts.firstIndex(of: productID) {
            likeProducts.remove(at: index)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        } else {
            likeProducts.append(productID)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        }
                    
        UserDefaultManager.shared.likeProduct = likeProducts
    }
    
    func  requestWebView() {
        let urlString = productUrl
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            productWebView.load(request)
        }
    }
}
