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
    }
    
    @objc func backToPrevios() {
        navigationController?.popViewController(animated: true)
    }
    
    func  requestWebView() {
        let urlString = productUrl
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            productWebView.load(request)
        }
    }
}
