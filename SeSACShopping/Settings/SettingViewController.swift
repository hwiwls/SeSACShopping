//
//  SettingViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/22/24.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet var profileViewTapGesture: UITapGestureRecognizer!
    
    let profileImageView: ProfileImageView = {
        let imageView = ProfileImageView(frame: .zero)
        return imageView
    }()
    
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
    
        view.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(editView.snp.top).offset(12)
            $0.leading.equalTo(editView.snp.leading).offset(12)
            $0.bottom.equalTo(editView.snp.bottom).offset(-12)
            $0.width.equalTo(profileImageView.snp.height).multipliedBy(1.0)
        }
        
        nicknameLabel.textColor = .white
        nicknameLabel.font = .boldSystemFont(ofSize: 18)
        
        likeCountLabel.font = .boldSystemFont(ofSize: 15)
        likeCountLabel.textColor = .white
    }
    
    // 이 메소드는 뷰의 레이아웃이 결정된 후에 호출되므로, 이 시점에서 이미지 뷰의 너비를 알 수 있
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius =  profileImageView.frame.size.width / 2
    }

    func configNav() {
        navigationItem.title = "설정"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @IBAction func profileViewClicked(_ sender: UITapGestureRecognizer) {
        UserDefaultManager.shared.isReg = false
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
