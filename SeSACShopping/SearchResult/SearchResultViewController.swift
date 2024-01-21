//
//  SearchResultViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/21/24.
//

import UIKit
import Alamofire
import Kingfisher

class SearchResultViewController: UIViewController {

    @IBOutlet weak var resultCountLabel: UILabel!
    @IBOutlet weak var accuracyBtn: UIButton!
    @IBOutlet weak var dateOrederBtn: UIButton!
    @IBOutlet weak var highPriceBtn: UIButton!
    @IBOutlet weak var lowPriceBtn: UIButton!
    @IBOutlet weak var searchResultCollecitonView: UICollectionView!
    
    lazy var buttons: [UIButton] = [accuracyBtn, dateOrederBtn, highPriceBtn, lowPriceBtn]
    
    var list: Shopping = Shopping(lastBuildDate: "", total: 10, start: 1, display: 30, items: [])
    
    var searchBarInput: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        searchResultCollecitonView.backgroundColor = .clear
        configView()
        configBtn()
        configNav()
        callRequset(text: searchBarInput)
    }
    
    func callRequset(text: String) {
        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = "https://openapi.naver.com/v1/search/shop?query=\(query)"
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]

        AF.request(url, method: .get, headers: headers).responseDecodable(of: Shopping.self) { response in
            
            switch response.result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
            
        }
    }
    
    func configBtn() {
        accuracyBtn.setTitle("정확도", for: .normal)
        accuracyBtn.isSelected = true
        
        dateOrederBtn.setTitle("날짜순", for: .normal)
        
        highPriceBtn.setTitle("높은가격순", for: .normal)
        
        lowPriceBtn.setTitle("낮은가격순", for: .normal)
        
        
        for button in buttons {
            updateButtonColor(button)
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        }
    }
    
    // 버튼의 배경색을 업데이트하는 함수
    func updateButtonColor(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = .white
            button.tintColor = .black
            button.layer.cornerRadius = 10
        } else {
            button.backgroundColor = .black
            button.tintColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 10
        }
    }

    // 버튼이 클릭되었을 때 호출되는 함수
    @objc func buttonClicked(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false  // 모든 버튼의 선택 상태를 해제
            updateButtonColor(button)  // 버튼의 배경색 업데이트
        }
        sender.isSelected = true  // 클릭된 버튼만 선택 상태로 설정
        updateButtonColor(sender)  // 클릭된 버튼의 배경색 업데이트
    }

    
    func configView() {
        resultCountLabel.text = "()개의 검색 결과"
        resultCountLabel.font = .boldSystemFont(ofSize: 14)
        resultCountLabel.textColor = UIColor.customColor.pointColor
        
        
        let xib = UINib(nibName: "SearchResultCollectionViewCell", bundle: nil) // 실제 파일 이름을 적어주어야 한다.
        searchResultCollecitonView.register(xib, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        
        searchResultCollecitonView.delegate = self
        searchResultCollecitonView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()   // 여러행, 여러열
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - spacing * 3
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2 + 70)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .vertical
        
        searchResultCollecitonView.collectionViewLayout = layout
    }
    
    func configNav() {
        navigationItem.title = searchBarInput
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let item = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), style: .plain, target: self, action: #selector(backToPrevios))
        navigationItem.leftBarButtonItem = item
    }
    
    @objc func backToPrevios() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        cell.productImageView.layer.cornerRadius = 10
        
        
        return cell
    }
    
    
}
