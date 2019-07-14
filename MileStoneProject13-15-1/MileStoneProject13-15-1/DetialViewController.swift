//
//  DetialViewController.swift
//  MileStoneProject13-15
//
//  Created by suppasit chuwatsawat on 6/7/2562 BE.
//  Copyright © 2562 suppasit chuwatsawat. All rights reserved.
//

import UIKit
import WebKit

class DetialViewController: UIViewController {
    var webView: WKWebView!
    var countryDetial: Country?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        guard let details = countryDetial else { return }
        let imageToShow = UIImage(named: details.name.lowercased())
        let stringImage = imageToShow?.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width", initial-scale=1">
        <style>
            body { font-size: 150% }
        
            td, th {
                border: 1px solid #dddddd;
                text-align: left;
            }
        
            tr:nth-child(even) {
                background-color: #dddddd;
            }
        </style>
        </head>
        <body style="background-color:powderblue;">
        <p>
        <i><h3 style="color:lightcoral">\(details.name.uppercased())</h3></i>
        <img src="data:image/png;base64, \(stringImage)">
        <table style="width:100%">
        <tr>
        <th>Capital City</th>
        <th>Population</th>
        <th>Currency</th>
        </tr>
        <tr>
        <td>\(details.capitalCity)</td>
        <td>\(details.population)</td>
        <td>\(details.currency)</td>
        </tr>
        </table>
        </p>
        <font size="+1">\(details.details)</font>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)

    }
    
    @objc func shareTapped() {
        guard let details = countryDetial else { return }
        
        let vc = UIActivityViewController(activityItems: [details.name, details.details], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}
