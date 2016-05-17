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
    @IBOutlet weak var memeNavBar: UINavigationBar!
    @IBOutlet weak var memeToolBar: UIToolbar!
    var priorKeyboardHeight: CGFloat = 0.0
    var combinedMeme: UIImage!
    var savedMemes = [MemeModel]()
    
    @IBAction func performCancelButton(sender: UIBarButtonItem)
    {
        // if the user cancels go back to intial state of app
        setToInitialState()
        topMemeTextField.text = ""
        bottomMemeTextField.text = ""
    }
    
    @IBAction func performActionButton(sender: AnyObject)
    {
       // UNCOMMENT TO DEBUG print("THE ACTION BUTTON HAS BEEN PRESSED")
        
        // 1. generate a memed image
        combinedMeme = generateMemedImage()
        
        // 2. define an instance of ActivityViewController
        // 3. pass the ActivityViewController a memedImage as an activity item
        let actViewController = UIActivityViewController(activityItems: [combinedMeme], applicationActivities: nil)
        // 4. present the ActivityViewController and add a completion method to save the meme
        self.presentViewController(actViewController, animated: true, completion: saveMeme)
    }
    
    
    // Display the saved photo for user to choose from existing pictures to MeMe.
    @IBAction func performAlbumButtonAction(sender: AnyObject)
    {
        //UNCOMMENT TO DEBUG print("THE ALBUM BUTTON HAS BEEN PRESSED")
        showImagePickerController(.SavedPhotosAlbum)
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.topMemeTextField.delegate = self
        self.bottomMemeTextField.delegate = self
        setToInitialState()
    }

    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    // Display the camera for the user to take a picture
    @IBAction func performCameraButtonAction(sender: AnyObject)
    {
        // UNCOMMENT TO DEBUG print("THE CAMERA BUTTON HAS BEEN PRESSED")
        showImagePickerController(.Camera)
    }
    
    
    func setAttributedStringValue() -> [String : AnyObject]
    {
        let memeTextAttri = [   NSStrokeColorAttributeName: UIColor.blackColor(),
                                NSForegroundColorAttributeName: UIColor.whiteColor(),
                                NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                NSStrokeWidthAttributeName: -3.0]
        
        return memeTextAttri

    }
    
    func setPlaceHolderAttributedStringValue(placeholderTxt: String) -> NSAttributedString
    {
       let placeHolderASV = NSAttributedString(string: placeholderTxt, attributes: [
                            NSForegroundColorAttributeName:UIColor.whiteColor(),
                            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                            NSStrokeColorAttributeName: UIColor.blackColor(),
                            NSStrokeWidthAttributeName: -3.0]
                            )
        
        return placeHolderASV

    }
    
    // Sets everything back to the intial state
    func setToInitialState()
    {
        actionButton.enabled = false
        memeView.backgroundColor = UIColor.blackColor()
        userSelectedImage.image = nil
        
        
        
        // Set Text Properties
        
        let memeTextAttri = setAttributedStringValue()
        
        // Set Placeholder attributes
        
        let topPlaceHolderColor = setPlaceHolderAttributedStringValue("TOP")
            
        let bottomPlaceHolderColor = setPlaceHolderAttributedStringValue("BOTTOM")
            
            
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
    

    // Implement delegate methods of UIImagePickerController delegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let userSelectedImageVal = info[UIImagePickerControllerOriginalImage] as! UIImage
        userSelectedImage.image = userSelectedImageVal
        actionButton.enabled = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // Clear out the placeholder text when the user begins editing
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if ((textField.placeholder == "TOP") || (textField.placeholder == "BOTTOM"))
        {
            textField.placeholder?.removeAll()
        }
    }
    
    //  If the user is done editing and the textfield is blank, set it to the appropriate place holder text value
    func textFieldDidEndEditing(textField: UITextField)
    {
        if (textField.text == "")
        {
            if (textField.tag == 1)
            {
                textField.defaultTextAttributes = setAttributedStringValue()
                textField.attributedPlaceholder = setPlaceHolderAttributedStringValue("BOTTOM")
                textField.textAlignment = .Center
            }
            else if (textField.tag == 2)
            {
                textField.defaultTextAttributes = setAttributedStringValue()
                textField.attributedPlaceholder = setPlaceHolderAttributedStringValue("TOP")
                textField.textAlignment = .Center
            }
            else
            {
                print("INVALID TAG SUPPLIED \(textField.tag)")
            }
        }
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillShowNotification,object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self,name: UIKeyboardWillHideNotification,object:nil)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if bottomMemeTextField.isFirstResponder()
        {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            //UNCOMMENT TO DEBUG print("Keyboard showing")
            
            
        }
        // Handle the case when the user has the keyboard showing and rotates the device.
        if getKeyboardHeight(notification) != priorKeyboardHeight && priorKeyboardHeight != 0.0
        {
           //UNCOMMENT TO DEBUG print("KeyboardHeight is \(getKeyboardHeight(notification)) not equal to \(priorKeyboardHeight)")
        
            if getKeyboardHeight(notification) != priorKeyboardHeight
            {
               //UNCOMMENT TO DEBUG print("KeyboardHeight is \(getKeyboardHeight(notification)) not equal to \(priorKeyboardHeight)")
                self.view.frame.origin.y += getKeyboardHeight(notification)
            }
            
        }
        
        priorKeyboardHeight = getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if bottomMemeTextField.isFirstResponder(){
            self.view.frame.origin.y = 0//+= getKeyboardHeight(notification)
            // UNCOMMENT TO DEBUG print("Keyboard hiding")
            
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        memeToolBar.hidden = true
        memeNavBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        memeToolBar.hidden = false
        memeNavBar.hidden = false
        
        return memedImage
    }
    
   func saveMeme()
   {
        // Save the Meme in the MemeModel
        let memeModelVal = MemeModel( topText: topMemeTextField.text!,
                                bottomText: bottomMemeTextField.text!,
                                    originalImage: userSelectedImage.image!,
                                    memedImage: combinedMeme)
    
    // Add this new meme to our array of Meme's
    savedMemes.append(memeModelVal)
    
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }


}

