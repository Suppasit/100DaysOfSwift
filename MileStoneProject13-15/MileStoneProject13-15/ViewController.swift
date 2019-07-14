//
//  ViewController.swift
//  MileStoneProject13-15
//
//  Created by suppasit chuwatsawat on 6/7/2562 BE.
//  Copyright © 2562 suppasit chuwatsawat. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries Table"
        
        performSelector(inBackground: #selector(fetchJsonFile), with: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = DetialViewController()
//        vc.countryDetial = countries[indexPath.row]
//
//        navigationController?.pushViewController(vc, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailTable") as? DetialViewController {
            vc.countryDetial = countries[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func fetchJsonFile() {
        if let path  = Bundle.main.path(forResource: "Countries", ofType: "json") {
            let fileURL = URL(fileURLWithPath: path)
            guard let data =  try? Data(contentsOf: fileURL) else { return }
            
            let decoder = JSONDecoder()
            if let jsonCountries = try? decoder.decode(Countries.self, from: data) {
                countries = jsonCountries.list
            }
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
    }

}

