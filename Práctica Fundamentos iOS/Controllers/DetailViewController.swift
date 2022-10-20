//
//  DetailViewController.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 19/6/22.
//

import UIKit
import KeychainSwift

final class DetailViewController: UIViewController {
  @IBOutlet weak var headerView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var textView: UILabel!
  
  @IBOutlet weak var transformationsButton: UIButton!
  
  private var model: ModelDisplayable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard let model = model else {
      return
    }

    self.title = model.name
    self.titleLabel.text = model.name
    self.textView.text = model.description
    self.headerView.setImage(url: model.photo.absoluteString)
    
    //This could be moved to a method
    if let hero = model as? Hero {
      guard let token = KeychainSwift().get("KCToken") else { return }
      
      let networkModel = NetworkModel(token: token)
      
      networkModel.getTransformations(for: hero, completion: { [weak self] transformations, error in
        let transformationsCount = transformations.count
        DispatchQueue.main.async {
          self?.transformationsButton.isHidden = transformationsCount == 0
        }
      })
    }
  }
  
  func set(model: Hero) {
    self.model = model
  }
  
  @IBAction func onTransformationsTap(_ sender: Any) {
    guard let model = model as? Hero else {
      return
    }

    //Now that we have the transformations at this point, we could pass the transformations array here
    let nextVC = TransformationsTableViewController()
    nextVC.set(model: model)
    navigationController?.pushViewController(nextVC, animated: true)
  }
}
