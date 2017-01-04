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
    
    func saveExistingMemeChanges()
    {
        
    }
    func EditExistingMeme()
    {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditor")as! MemeEditorViewController
        
        // Recreate pieces of original saved image details
        resultVC.topMemeTextField?.text = memeObj?.topText
        resultVC.bottomMemeTextField?.text = memeObj?.bottomText
        resultVC.userSelectedImage?.image = memeObj?.originalImage
        resultVC.memeObj = memeObj
        resultVC.editMemeFlag = true
        resultVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveExistingMemeChanges))
        
        // Communicate the match
        
        present(resultVC, animated: true, completion: nil)
        print("EDIT EXISTING MEME BUTTON PRESSED")
        
    
    }
    
    

    
    

}
