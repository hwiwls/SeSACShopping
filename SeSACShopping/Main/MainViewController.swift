//
//  MainViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/20/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyListImageView: UIImageView!
    @IBOutlet weak var emptyListLabel: UILabel!
//    @IBOutlet weak var recentSearchTableView: UITableView!
    @IBOutlet weak var tableViewHeader: UIView!
    @IBOutlet weak var recentSearchLabel: UILabel!
    @IBOutlet weak var clearAllBtn: UIButton!
    
    let recentSearchTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        searchBar.delegate = self
        recentSearchTableView.backgroundColor = .clear
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        recentSearchTableView.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: "RecentSearchTableViewCell")
        recentSearchTableView.rowHeight = 55
        
        configView()
        configNav()
        configUI()
    }
}

extension MainViewController {
    func configUI() {
        if UserDefaultManager.shared.recentSearchWords.isEmpty {
            emptyListLabel.isHidden = false
            emptyListImageView.isHidden = false
            recentSearchTableView.isHidden = true
            tableViewHeader.isHidden = true
            recentSearchLabel.isHidden = true
            clearAllBtn.isHidden = true
        } else {
            emptyListLabel.isHidden = true
            emptyListImageView.isHidden = true
            recentSearchTableView.isHidden = false
            tableViewHeader.isHidden = false
            recentSearchLabel.isHidden = false
            clearAllBtn.isHidden = false
        }
    }
    
    func configView() {
        tableViewHeader.backgroundColor = .black
        
        recentSearchLabel.text = "최근 검색"
        recentSearchLabel.textColor = .white
        recentSearchLabel.font = .boldSystemFont(ofSize: 14)
        
        clearAllBtn.setTitle("모두 지우기", for: .normal)
        clearAllBtn.tintColor = UIColor.customColor.pointColor
        clearAllBtn.addTarget(self, action: #selector(clearAllSearchList), for: .touchUpInside)
        
        searchBar.showsBookmarkButton = false
        searchBar.barTintColor = .black
        searchBar.searchTextField.backgroundColor = .darkGray
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "브랜드, 상품, 프로필 태그 등", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.searchBar.searchTextField.leftView?.tintColor = .white
        
        emptyListImageView.image = UIImage(named: "empty")
        emptyListImageView.contentMode = .scaleAspectFit
        
        emptyListLabel.text = "최근 검색어가 없어요"
        emptyListLabel.textColor = .white
        emptyListLabel.font = .boldSystemFont(ofSize: 18)
        
        layout()
    }
    
    func layout() {
        view.addSubview(recentSearchTableView)
        
        recentSearchTableView.snp.makeConstraints {
            $0.top.equalTo(tableViewHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configNav() {
        navigationItem.title = "\(UserDefaultManager.shared.nickname)님의 새싹쇼핑"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationItem.hidesBackButton = true  // back 버튼 숨기기
    }
    
    @objc func clearAllSearchList() {
        UserDefaultManager.shared.removeRecentSearchWords()
        if UserDefaultManager.shared.recentSearchWords.isEmpty {
            emptyListLabel.isHidden = false
            emptyListImageView.isHidden = false
            recentSearchTableView.isHidden = true
            tableViewHeader.isHidden = true
            recentSearchLabel.isHidden = true
            clearAllBtn.isHidden = true
        } else {
            recentSearchTableView.reloadData()
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UserDefaultManager.shared.recentSearchWords.insert(searchBar.text!, at: 0)
        configUI()
        recentSearchTableView.reloadData()
        
        searchBar.resignFirstResponder()    // return 버튼 누르면 키보드 내리기

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        vc.searchBarInput = searchBar.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDefaultManager.shared.recentSearchWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchTableViewCell", for: indexPath) as? RecentSearchTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.searchWordLabel.text = UserDefaultManager.shared.recentSearchWords[indexPath.row]
        
        // tag를 전달해서 해당 요소를 삭제할 수 있게끔 함
        cell.deleteWordBtn.tag = indexPath.row
        cell.deleteWordBtn.addTarget(self, action: #selector(deleteWord(_:)), for: .touchUpInside)

        return cell
    }
    
    @objc func deleteWord(_ sender: UIButton) {
        let index = sender.tag
        UserDefaultManager.shared.recentSearchWords.remove(at: index)
        
        if UserDefaultManager.shared.recentSearchWords.isEmpty {
            emptyListLabel.isHidden = false
            emptyListImageView.isHidden = false
            recentSearchTableView.isHidden = true
            tableViewHeader.isHidden = true
            recentSearchLabel.isHidden = true
            clearAllBtn.isHidden = true
        } else {
            recentSearchTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        vc.searchBarInput = UserDefaultManager.shared.recentSearchWords[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
