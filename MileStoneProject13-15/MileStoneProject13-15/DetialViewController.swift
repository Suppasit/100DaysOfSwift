//
//  DetialViewController.swift
//  MileStoneProject13-15
//
//  Created by suppasit chuwatsawat on 6/7/2562 BE.
//  Copyright © 2562 suppasit chuwatsawat. All rights reserved.
//

import UIKit

class DetialViewController: UITableViewController {
    var countryDetial: Country?
    var countryInfo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        guard let details = countryDetial else { return }
        
        title = details.name

        countryInfo.append("Capital City: \(details.capitalCity)")
        countryInfo.append("Population: \(details.population)")
        countryInfo.append("Currency: \(details.currency)")
        countryInfo.append(details.details)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath)
        cell.textLabel?.text = countryInfo[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    @objc func shareTapped() {
        guard let details = countryDetial else { return }
        
        let vc = UIActivityViewController(activityItems: [details.name, details.details], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
