//
//  NewsDetailController.swift
//  sampleTableView
//
//  Created by 이유승 on 12/03/2020.
//  Copyright © 2020 이유승. All rights reserved.
//

import UIKit

class NewsDetailController : UIViewController {
    
    @IBOutlet weak var ImageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    // 1. Image URL
    // 2. description
    
    var imageUrl: String?
    var desc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = imageUrl {
            // Get to Image 처리
            if let data = try? Data(contentsOf: URL(string: img)!) {
                DispatchQueue.main.async {
                    self.ImageMain.image = UIImage(data:  data)  // Main 처리
                }
            }
        }
        
        if let d = desc {
            // 뉴스 본문 처리
            self.LabelMain.text = d
        }
    }
}
