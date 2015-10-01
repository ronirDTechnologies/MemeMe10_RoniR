//
//  ViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 9/27/15.
//  Copyright © 2015 Roni Rozenblat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var memeView: UIView!
    
    @IBAction func performActionButton(sender: AnyObject) {
        print("THE ACTION BUTTON HAS BEEN PRESSED")
    }
    
    
    // Display the saved photo for user to choose from existing pictures to MeMe.
    @IBAction func performAlbumButtonAction(sender: AnyObject) {
        
        print("THE ALBUM BUTTON HAS BEEN PRESSED")
        
        showImagePickerController(.SavedPhotosAlbum)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       setToInitialState()
  

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Present Image Picker Based on Source Type Provided
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType){
        
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = sourceType
            imagePickerController.delegate = self
            presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    // Display the camera for the user to take a picture
    @IBAction func performCameraButtonAction(sender: AnyObject) {
        
        print("THE CAMERA BUTTON HAS BEEN PRESSED")
        showImagePickerController(.Camera)
    }
    
    // Sets everything back to the intial state
    func setToInitialState()
    {
        self.actionButton.enabled = false
        self.memeView.backgroundColor = UIColor.blackColor()
    }


}

