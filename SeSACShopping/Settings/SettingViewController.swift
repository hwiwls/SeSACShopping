//
//  SettingViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/22/24.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet var profileViewTapGesture: UITapGestureRecognizer!
    
    let contents = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "처음부터 시작하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        settingTableView.backgroundColor = .black
        
        configView()
        configNav()
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        settingTableView.rowHeight = 40
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 프로필 수정 후 pop 했을 때 반영하기 위해
        profileImageView.image = UIImage(named: UserDefaultManager.shared.selectedImage)
        nicknameLabel.text = UserDefaultManager.shared.nickname
        likeCountLabel.text = "\(UserDefaultManager.shared.likeProduct.count)개의 상품을 좋아하고 있어요!"
    }
}

extension SettingViewController {
    func configView() {
        editView.layer.cornerRadius = 15
    
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.customColor.pointColor.cgColor
        
        nicknameLabel.textColor = .white
        nicknameLabel.font = .boldSystemFont(ofSize: 18)
        
        likeCountLabel.font = .boldSystemFont(ofSize: 15)
        likeCountLabel.textColor = .white
    }

    func configNav() {
        navigationItem.title = "설정"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @IBAction func profileViewClicked(_ sender: UITapGestureRecognizer) {
        UserDefaultManager.shared.isSetting = false
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ProfileSettingViewController") as! ProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath)
        
        cell.selectionStyle = .none
        
        
        cell.textLabel?.text = contents[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = .systemFont(ofSize: 15)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let alert = UIAlertController(title: "처음부터 시작하기", message: "데이터를 모두 초기화하시겠습니까?", preferredStyle: .alert)
            
            let btn1 = UIAlertAction(title: "취소", style: .cancel)
            let btn2 = UIAlertAction(title: "확인", style: .default) { action in
                UserDefaultManager.shared.removeAll()
                UserDefaultManager.shared.userState = false
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                let nav = UINavigationController(rootViewController: vc)
                
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            
            alert.addAction(btn1)
            alert.addAction(btn2)
            
            present(alert, animated: true)
        }
    }
    
    
}
