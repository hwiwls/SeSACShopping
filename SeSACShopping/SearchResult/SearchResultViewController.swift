//
//  SearchResultViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/21/24.
//

import UIKit
import Alamofire


class SearchResultViewController: UIViewController {

    @IBOutlet weak var resultCountLabel: UILabel!
    @IBOutlet weak var accuracyBtn: UIButton!
    @IBOutlet weak var dateOrederBtn: UIButton!
    @IBOutlet weak var highPriceBtn: UIButton!
    @IBOutlet weak var lowPriceBtn: UIButton!
    @IBOutlet weak var searchResultCollecitonView: UICollectionView!
    
    lazy var buttons: [UIButton] = [accuracyBtn, dateOrederBtn, highPriceBtn, lowPriceBtn]
    
    var list: Shopping = Shopping(lastBuildDate: "", total: 0, start: 1, display: 30, items: [])
    
    var searchBarInput: String = ""
    
    var start = 1
    var totalCount = 70
    
    var shouldScrollToTop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        searchResultCollecitonView.backgroundColor = .clear
        start = 1
        configView()
        configBtn()
        configNav()
        Task {
            await sortingBySim(text: searchBarInput)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // CollectionView를 리로드합니다.
        searchResultCollecitonView.reloadData()
    }
}

extension SearchResultViewController {
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

    @objc func buttonClicked(_ sender: UIButton) {
        for button in buttons {
            button.isSelected = false
            updateButtonColor(button)
        }
        sender.isSelected = true
        updateButtonColor(sender)
        
        Task {
            switch sender {
            case accuracyBtn:
                await sortingBySim(text: searchBarInput)
            case dateOrederBtn:
                await sortingByDate(text: searchBarInput)
            case highPriceBtn:
                await sortingByDsc(text: searchBarInput)
            case lowPriceBtn:
                await sortingByAsc(text: searchBarInput)
            default:
                break
            }
        }
    }
    
    func configView() {
        resultCountLabel.font = .boldSystemFont(ofSize: 14)
        resultCountLabel.textColor = UIColor.customColor.pointColor
        
        
        let xib = UINib(nibName: "SearchResultCollectionViewCell", bundle: nil) // 실제 파일 이름을 적어주어야 한다.
        searchResultCollecitonView.register(xib, forCellWithReuseIdentifier: "SearchResultCollectionViewCell")
        
        searchResultCollecitonView.delegate = self
        searchResultCollecitonView.dataSource = self
        searchResultCollecitonView.prefetchDataSource = self
        
        let layout = UICollectionViewFlowLayout()   // 여러행, 여러열
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - spacing * 3
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2 + 90)
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
        return list.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCollectionViewCell", for: indexPath) as? SearchResultCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(list.items[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ProductDatailViewController") as! ProductDatailViewController
        vc.productTitle = list.items[indexPath.row].title
        vc.productUrl = list.items[indexPath.row].link
        vc.productID = list.items[indexPath.row].productID 
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            // 카카오 책 API에 있던 isEnd 변수를 이런식으로 대체하는 게 맞는지 모르겠습니다.(totalCount는 70으로 초기화하였음)
            if list.items.count - 3 == item.row && list.items.count < totalCount {
                Task {
                    start += 30
                    shouldScrollToTop = true
                    await sortingBySim(text: searchBarInput)
                }
            }
        }
    }
}
    
extension SearchResultViewController {
    func sortingBySim(text: String) async {
        do {
            let shopping = try await ShoppingAPISessionManager.shared.callRequestBySim2(text: text, start: start)
            if self.start == 1 {
                self.list = shopping
            } else {
                self.list.items.append(contentsOf: shopping.items)
                self.totalCount = shopping.total
            }
            
            DispatchQueue.main.async {
                self.searchResultCollecitonView.reloadData()
                self.resultCountLabel.text = "\(shopping.total)개의 검색 결과"
                if self.shouldScrollToTop {
                    self.searchResultCollecitonView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    self.shouldScrollToTop = false
                }
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func sortingByDate(text: String) async {
        do {
            let shopping = try await ShoppingAPISessionManager.shared.callRequestByDate2(text: text, start: start)
            if start == 1 {
                self.list = shopping
            } else {
                self.list.items.append(contentsOf: shopping.items)
                self.totalCount = shopping.total
            }
            
            DispatchQueue.main.async {
                self.searchResultCollecitonView.reloadData()
                self.resultCountLabel.text = "\(shopping.total)개의 검색 결과"
                if self.shouldScrollToTop {
                    self.searchResultCollecitonView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    self.shouldScrollToTop = false
                }
            }
        } catch {
            print("Error fetching results by date: \(error)")
        }
    }

    
    func sortingByAsc(text: String) async {
        do {
            let shopping = try await ShoppingAPISessionManager.shared.callRequestByAsc2(text: text, start: start)
            if start == 1 {
                self.list = shopping
            } else {
                self.list.items.append(contentsOf: shopping.items)
                self.totalCount = shopping.total
            }
            
            DispatchQueue.main.async {
                self.searchResultCollecitonView.reloadData()
                self.resultCountLabel.text = "\(shopping.total)개의 검색 결과"
                if self.start == 1 {
                    self.searchResultCollecitonView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    self.shouldScrollToTop = false
                }
            }
        } catch {
            print("Error fetching results in ascending order: \(error)")
        }
    }

    
    func sortingByDsc(text: String) async {
        do {
            let shopping = try await ShoppingAPISessionManager.shared.callRequestByDsc2(text: text, start: start)
            if start == 1 {
                self.list = shopping
            } else {
                self.list.items.append(contentsOf: shopping.items)
                self.totalCount = shopping.total
            }
            
            DispatchQueue.main.async {
                self.searchResultCollecitonView.reloadData()
                self.resultCountLabel.text = "\(shopping.total)개의 검색 결과"
                if self.start == 1 {
                    self.searchResultCollecitonView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    self.shouldScrollToTop = false
                }
            }
        } catch {
            print("Error fetching results in descending order: \(error)")
        }
    }

}
