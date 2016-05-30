//
//  ViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 9/27/15.
//  Copyright © 2015 Roni Rozenblat. All rights reserved.
//

import UIKit
import Foundation


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, PickFontProtocol{

    @IBOutlet weak var fontSelectorButton: UIBarButtonItem!
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
    var globalFontValue = "Impact"
    
    
    
    @IBAction func performCancelButton(sender: UIBarButtonItem)
    {
        // if the user cancels go back to intial state of app
        setToInitialState()
        topMemeTextField.text = ""
        bottomMemeTextField.text = ""
    }
    @IBAction func performFontSelectorButton(sender: UIBarButtonItem) {
        var controller: PickFontViewController
        
        controller  = storyboard?.instantiateViewControllerWithIdentifier("FontSelectorVC") as! PickFontViewController
        controller.m_currentFont = globalFontValue
        controller.delegate = self
      //PickFontViewController.delegate = self
                presentViewController(controller, animated: true, completion: nil)
       
        
    }
    @IBAction func performActionButton(sender: AnyObject)
    {
       // UNCOMMENT TO DEBUG print("THE ACTION BUTTON HAS BEEN PRESSED")
        
        // 1. generate a memed image
        combinedMeme = generateMemedImage()
       
        
        // 2. define an instance of ActivityViewController
        // 3. pass the ActivityViewController a memedImage as an activity item
        let actViewController = UIActivityViewController(activityItems: [combinedMeme], applicationActivities: nil)
        
        //-------------------------------------------------------------------------------------------------
        // RR: 05-17-2016 Make change per app Udacity project review.  I found this code in 
        // the Forum titled: "I’m not understanding the UIActivityViewController completionWithItemsHandler 
        // iOSND P2 | UIKit Fundamentals"
        // I thought that I could just call the saveMe func and pass it into the presentViewController completion 
        // param.  Didn't realize that would be saved as soon as the Activity view is presented.  Now I 
        // understand that it need to be saved once the actual Activity was completed.
        //-------------------------------------------------------------------------------------------------
        //If the user completes an action in the activity view controller,
        //save the meme to the shared storage.
        actViewController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        // 4. present the ActivityViewController and add a completion method to save the meme
        presentViewController(actViewController, animated: true, completion: nil)
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
        topMemeTextField.delegate = self
        bottomMemeTextField.delegate = self
        setToInitialState()
        
        
        // List all available font names3
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
        
    }

    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        // Allow Editing to allow for cropping an image per Udacity forums.
        imagePickerController.allowsEditing = true
        
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
                                NSFontAttributeName: UIFont(name: globalFontValue, size: 40)!,
                                NSStrokeWidthAttributeName: -3.0]
        
        
        return memeTextAttri

    }
    
    func setPlaceHolderAttributedStringValue(placeholderTxt: String) -> NSAttributedString
    {
       let placeHolderASV = NSAttributedString(string: placeholderTxt, attributes: [
                            NSForegroundColorAttributeName:UIColor.whiteColor(),
                            NSFontAttributeName : UIFont(name: globalFontValue, size: 40)!,
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
        
        // Initial Font will always be impact
        globalFontValue = "Impact"
        
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
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
            //view.frame.origin.y -= getKeyboardHeight(notification)
            
            // Better way to accomplish the above as per review suggestion.
            view.frame.origin.y =  getKeyboardHeight(notification) * -1
            
            //UNCOMMENT TO DEBUG print("Keyboard showing")
            
            
        }
        // Handle the case when the user has the keyboard showing and rotates the device.
        if getKeyboardHeight(notification) != priorKeyboardHeight && priorKeyboardHeight != 0.0
        {
           //UNCOMMENT TO DEBUG print("KeyboardHeight is \(getKeyboardHeight(notification)) not equal to \(priorKeyboardHeight)")
        
            if getKeyboardHeight(notification) != priorKeyboardHeight
            {
               //UNCOMMENT TO DEBUG print("KeyboardHeight is \(getKeyboardHeight(notification)) not equal to \(priorKeyboardHeight)")
                view.frame.origin.y += getKeyboardHeight(notification)
            }
            
        }
        
        priorKeyboardHeight = getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if bottomMemeTextField.isFirstResponder(){
            view.frame.origin.y = 0//+= getKeyboardHeight(notification)
            // UNCOMMENT TO DEBUG print("Keyboard hiding")
            
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        memeToolBar.hidden = true
        memeNavBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
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
        print("IMAGE SAVED AND ADDED TO ARRAY")
    
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
    
   
    // Implementing this methods conforms to PickFontProtocol.  It will kick off once a users selects an existing or new font.
    func updateFont(newFontValue: String)
    {
        globalFontValue = newFontValue
        print("THE FOLLOWING FONT WAS SELECTED AND NOW UPDATE \(globalFontValue)")
    
        bottomMemeTextField.defaultTextAttributes = setAttributedStringValue()
        bottomMemeTextField.textAlignment = .Center
        topMemeTextField.defaultTextAttributes = setAttributedStringValue()
        topMemeTextField.textAlignment = .Center
    
    }
}

