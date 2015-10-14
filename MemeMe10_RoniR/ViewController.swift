//
//  ViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 9/27/15.
//  Copyright © 2015 Roni Rozenblat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var memeView: UIView!
    
    @IBOutlet weak var topMemeTextField: UITextField!
    @IBOutlet weak var bottomMemeTextField: UITextField!
    @IBOutlet weak var userSelectedImage: UIImageView!
   
    
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
        
        // Set Text Properties
        //TODO:
        // FONT BOLD
        // ALL CAPS
        // WHITE COLOR
        // BLACK OUTLINE
        // SHRINK TO FIT
        // IMPACT FONT
        
        // Set Placeholder attributes
        
        let memeAttr: defaultTextAttributes
        
        
        let topPlaceHolderColor = NSAttributedString(string: "TOP", attributes: [
                                                        NSBackgroundColorAttributeName:UIColor.clearColor(),
                                                        NSForegroundColorAttributeName:UIColor.whiteColor(),
                                                        NSFontAttributeName : UIFont(name: "Arial-BoldMT", size: 25)!,
                                                        NSStrokeColorAttributeName: UIColor.blackColor(),
                                                        NSStrokeWidthAttributeName: -3.0

                                                                                ]
                                                    )
        let bottomPlaceHolderColor = NSAttributedString(string: "BOTTOM", attributes: [
                                                        NSForegroundColorAttributeName:UIColor.whiteColor(),
                                                        NSBackgroundColorAttributeName:UIColor.clearColor(),
                                                        NSFontAttributeName : UIFont(name: "Arial-BoldMT", size: 25)!,
                                                        NSStrokeColorAttributeName: UIColor.blackColor(),
                                                        NSStrokeWidthAttributeName: -3.0
                                                                                      ]
                                                    )
        
        self.topMemeTextField.attributedPlaceholder = topPlaceHolderColor
        self.topMemeTextField.borderStyle = .None
        self.bottomMemeTextField.attributedPlaceholder = bottomPlaceHolderColor
        self.bottomMemeTextField.borderStyle = .None
        
       // Set Text Attributes
        
        self.topMemeTextField.textAlignment = .Center
        self.bottomMemeTextField.textAlignment = .Center
  
        self.topMemeTextField.textColor = UIColor.whiteColor()
        
        // Check to see if a camera exists on a device
        if ((UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil) &&
                (UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil)){

            cameraButton.enabled = true
        }
        else
        {
            cameraButton.enabled = false
        }
        
        
    }
    
    
    // MARK: UIImagPickerControllerDelegate
    // Implement delegate methods of UIImagePickerController delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let userSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.userSelectedImage.image = userSelectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }


}

