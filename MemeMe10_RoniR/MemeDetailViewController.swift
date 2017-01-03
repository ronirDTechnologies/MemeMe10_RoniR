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
    var memeObj:MemeModel?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.edit, target: self, action: #selector(MemeDetailViewController.EditExistingMeme))
        memeDetailViewImage.image = combMemeImage

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func EditExistingMeme()
    {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditor")as! MemeEditorViewController
        resultVC.topMemeTextField?.text = topTextString
        resultVC.bottomMemeTextField?.text = bottomTextString
        resultVC.userSelectedImage?.image = origImage
        resultVC.memeObj = memeObj
        
        // Communicate the match
        
        present(resultVC, animated: true, completion: nil)
        print("EDIT EXISTING MEME BUTTON PRESSED")
        
    
    }
    
    

    
    

}
