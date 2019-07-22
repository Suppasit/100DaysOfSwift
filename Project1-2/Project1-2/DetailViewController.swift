//
//  DetailViewController.swift
//  Project1
//
//  Created by suppasit chuwatsawat on 21/5/2562 BE.
//  Copyright © 2562 suppasit chuwatsawat. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var pictureIndex: Int?
    var totalPicture: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = selectedImage
        if let thePictureIndex = pictureIndex, let theTotalPicture = totalPicture {
            title = "Picture \(thePictureIndex + 1) of \(theTotalPicture)"
        }
        
        navigationItem.largeTitleDisplayMode = .never

        // Do any additional setup after loading the view.
        assert(selectedImage != nil)
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
