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
   
    
    @IBAction func performCancelButton(sender: UIBarButtonItem) {
        // if the user cancels go back to intial state of app
        setToInitialState()
        topMemeTextField.text = ""
        bottomMemeTextField.text = ""
    }
    
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
        self.topMemeTextField.delegate = self
        self.bottomMemeTextField.delegate = self
       setToInitialState()
  

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
        actionButton.enabled = false
        memeView.backgroundColor = UIColor.blackColor()
        userSelectedImage.image = nil
        
        
        // Set Text Properties
        
        let memeTextAttri = [   NSStrokeColorAttributeName: UIColor.blackColor(),
                                NSForegroundColorAttributeName: UIColor.whiteColor(),
                                NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                NSStrokeWidthAttributeName: -3.0]
        
        
        // Set Placeholder attributes
        
        let topPlaceHolderColor = NSAttributedString(string: "TOP", attributes: [
                                                        NSForegroundColorAttributeName:UIColor.whiteColor(),
                                                        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                                        NSStrokeColorAttributeName: UIColor.blackColor(),
                                                        NSStrokeWidthAttributeName: -3.0

                                                                                ]
                                                    )
        let bottomPlaceHolderColor = NSAttributedString(string: "BOTTOM", attributes: [
                                                        NSForegroundColorAttributeName:UIColor.whiteColor(),
                                                        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                                        NSStrokeColorAttributeName: UIColor.blackColor(),
                                                        NSStrokeWidthAttributeName: -3.0
                                                                                      ]
                                                    )
        
        
        // Set Text Attributes
        
       
        
        topMemeTextField.defaultTextAttributes = memeTextAttri
        bottomMemeTextField.defaultTextAttributes  = memeTextAttri

        topMemeTextField.attributedPlaceholder = topPlaceHolderColor
        
        
        bottomMemeTextField.attributedPlaceholder = bottomPlaceHolderColor
       
        topMemeTextField.textAlignment = .Center
        bottomMemeTextField.textAlignment = .Center
        
        
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
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // Move keyboard code
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillShowNotification,object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillHideNotification,object:nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomMemeTextField.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if bottomMemeTextField.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }


}

