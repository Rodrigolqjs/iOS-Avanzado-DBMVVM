//
//  LoginViewController.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 24/6/22.
//

import UIKit
import KeychainSwift

final class LoginViewModel {
    private var networkModel: NetworkModel
    private var keychain: KeychainSwift
    
    var onError: ((String) -> Void)?
    var onLogin: (() -> Void)?
    
    init(networkModel: NetworkModel = NetworkModel(),
         keychain: KeychainSwift = KeychainSwift(),
         onError: ( (String) -> Void)? = nil,
         onLogin: ( () -> Void)? = nil) {
        self.networkModel = networkModel
        self.keychain = keychain
        self.onError = onError
        self.onLogin = onLogin
    }
    
    func login(with user: String, password: String) {
        networkModel.login(user: user, password: password) { [weak self] token, error in
            
            if let error {
                self?.onError?("Error")
            }
            
            guard let token, !token.isEmpty else {
                self?.onError?("Wrong token")
                return
            }
            self?.keychain.set(token, forKey: "KCToken")
            self?.onLogin?()
            
        }
    }
    
}

final class LoginViewController: UIViewController {

  @IBOutlet weak var userTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
    let viewModel = LoginViewModel()
    
  override func viewDidLoad() {
    super.viewDidLoad()
      print("print llego aqui 1")
      
      viewModel.onError = { [weak self] message in
          DispatchQueue.main.async {
              self?.activityIndicator.stopAnimating()
              self?.loginButton.isEnabled = true
          }
      }
      
      viewModel.onLogin = { [weak self] in
          DispatchQueue.main.async {
              self?.activityIndicator.stopAnimating()
              self?.loginButton.isEnabled = true
              
              let nextViewController = TableViewController()
              print("llego aqui")
              self?.navigationController?.setViewControllers([nextViewController], animated: true)
          }
      }
  }
    

  @IBAction func onLoginTap(_ sender: Any) {
    activityIndicator.startAnimating()
    loginButton.isEnabled = false
    
      viewModel.login(with: userTextField.text ?? "", password: passwordTextField.text ?? "")
  }
}
