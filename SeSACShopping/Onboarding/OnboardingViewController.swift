//
//  OnboardingViewController.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/19/24.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configView()
    }
    
    func configView() {
        logoImageView.image = UIImage(named: "sesacShopping")
        logoImageView.contentMode = .scaleAspectFit
        
        onboardingImageView.image = UIImage(named: "onboarding")
        onboardingImageView.contentMode = .scaleAspectFit
        
        startBtn.backgroundColor = UIColor.customColor.pointColor
        startBtn.setTitle("시작하기", for: .normal)
        startBtn.setTitleColor(.white, for: .normal)
        startBtn.setTitleColor(.white, for: .highlighted)
        startBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        startBtn.layer.cornerRadius = 10
    }
   
    @IBAction func startBtnClicked(_ sender: UIButton) {
        UserDefaultManager.shared.isReg = true
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ProfileSettingViewController") as! ProfileSettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
