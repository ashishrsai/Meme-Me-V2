//
//  finalView.swift
//  Meme
//
//  Created by Ashutosh Kumar Sai on 15/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import UIKit

class finalView: UIViewController {

    @IBOutlet weak var finalImage: UIImageView!
    var meme : Meme!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        finalImage!.image = meme.memedImage
        
    }


}
