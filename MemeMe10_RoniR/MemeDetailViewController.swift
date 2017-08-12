//
//  MemeDetailViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 7/12/16.
//  Copyright © 2016 Roni Rozenblat. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet var memeDetailViewImage: UIImageView!
    var combMemeImage: UIImage!
    var topTextString: String = ""
    var bottomTextString: String = ""
    var origImage: UIImage!
    var memeObj:Meme?
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        memeDetailViewImage.image = combMemeImage
        
    }

    
    
    
    
    

    
    

}
