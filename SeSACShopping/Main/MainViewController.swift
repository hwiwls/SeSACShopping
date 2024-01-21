//
//  MainViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/20/24.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyListImageView: UIImageView!
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var recentSearchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        recentSearchTableView.backgroundColor = .clear
        searchBar.delegate = self
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        recentSearchTableView.register(UINib(nibName: "RecentSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "RecentSearchTableViewCell")
        recentSearchTableView.rowHeight = 55
        configView()
        configNav()
        configUI()
    }
    
    func configUI() {
        if UserDefaultManager.shared.recentSearchWords.isEmpty {
            emptyListLabel.isHidden = false
            emptyListImageView.isHidden = false
            recentSearchTableView.isHidden = true
        } else {
            emptyListLabel.isHidden = true
            emptyListImageView.isHidden = true
            recentSearchTableView.isHidden = false
        }
    }
    
    func configView() {
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
    }
    
    func configNav() {
        navigationItem.title = "떠나고 싶은 \(UserDefaultManager.shared.nickname)님의 새싹쇼핑"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationItem.hidesBackButton = true  // back 버튼 숨기기
    }

}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UserDefaultManager.shared.recentSearchWords.insert(searchBar.text!, at: 0)
        configUI()
        recentSearchTableView.reloadData()

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
        
        cell.magnifyingglassImageView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        cell.searchWordLabel.text = UserDefaultManager.shared.recentSearchWords[indexPath.row]
        cell.searchWordLabel.textColor = .white
        cell.searchWordLabel.font = .systemFont(ofSize: 15)
        
        cell.deleteWordBtn.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
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
        } else {
            recentSearchTableView.reloadData()
        }
    }
}
