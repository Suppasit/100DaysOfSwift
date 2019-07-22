//
//  ViewController.swift
//  Project1
//
//  Created by suppasit chuwatsawat on 20/5/2562 BE.
//  Copyright © 2562 suppasit chuwatsawat. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [PicDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Strom Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let defaults = UserDefaults.standard
        
        if let savedPictures = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([PicDetails].self, from: savedPictures)
            } catch {
                print("Failed to load pictures")
            }
        }
        
        performSelector(inBackground: #selector(fetchImageList), with: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row].name
        cell.detailTextLabel?.text = "View count: \(pictures[indexPath.row].count)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.pictureIndex = indexPath.row
            vc.totalPicture = pictures.count
            vc.selectedImage = pictures[indexPath.row].name
            
            pictures[indexPath.row].count += 1
            tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = "View count: \(pictures[indexPath.row].count)"
            
            save()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareTapped() {
        let recommend = "I highly recommend the app.\n Strom Viewer, Give it a try!"
        let vc = UIActivityViewController(activityItems: [recommend], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    @objc fileprivate func fetchImageList() {
        // Do any additional setup after loading the view.
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                let newPic = PicDetails(name: item, count: 0)
                pictures.append(newPic)
            }
        }
        
        pictures.sort()
        print(pictures)
        
        // Reload tableView data
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        } else {
            print("Failed to save pictures")
        }
    }
}

