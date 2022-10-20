//
//  TableViewController.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 24/6/22.
//

import UIKit
import KeychainSwift

final class TableViewController: UITableViewController {
  
  var content: [Hero] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Heroes"
    
    navigationController?.navigationBar.isHidden = false
    
    tableView?.register(
      UINib(nibName: "TableViewCell", bundle: nil),
      forCellReuseIdentifier: "reuseIdentifier"
    )
    
      guard let token = KeychainSwift().get("KCToken") else { return }
    
    let networkModel = NetworkModel(token: token)
    networkModel.getHeroes { [weak self] heros, error in
        print(error)
        print(heros)
      self?.content = heros
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return content.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? TableViewCell else {
      let cell = UITableViewCell()
      cell.textLabel?.text = "no content"
      return cell
    }
    cell.set(model: content[indexPath.row])
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let hero = content[indexPath.row]
    let nextVC = DetailViewController()
    nextVC.set(model: hero)
    navigationController?.pushViewController(nextVC, animated: true)
  }
  
}
