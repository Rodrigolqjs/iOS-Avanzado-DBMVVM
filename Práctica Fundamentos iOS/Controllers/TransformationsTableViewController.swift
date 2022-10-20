//
//  TransformationsTableViewController.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 24/6/22.
//

import UIKit
import KeychainSwift

final class TransformationsTableViewController: UITableViewController {
  
  private var content: [Transformation] = []
  
  private var model: Hero?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView?.register(
      UINib(nibName: "TableViewCell", bundle: nil),
      forCellReuseIdentifier: "reuseIdentifier"
    )
    
    guard let model = model, let token = KeychainSwift().get("KCToken") else { return }
    
    let networkModel = NetworkModel(token: token)
    
    networkModel.getTransformations(for: model, completion: { [weak self] transformations, error in
      self?.content = transformations.sorted {
        $0.name.localizedStandardCompare($1.name) == .orderedAscending
      }
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    })
  }
  
  func set(model: Hero) {
    self.model = model
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
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
}
