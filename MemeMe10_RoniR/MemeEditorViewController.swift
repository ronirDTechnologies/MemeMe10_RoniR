//
//  ViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 9/27/15.
//  Copyright © 2015 Roni Rozenblat. All rights reserved.
//

import UIKit
import Foundation


class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, PickFontProtocol{

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
    var didComeFromDetailVC = false
    var memeObj: MemeModel?
    var editMemeFlag = false
    
    
    
    @IBAction func performCancelButton(_ sender: UIBarButtonItem)
    {
        // if the user cancels go back to intial state of app
        setToInitialState()
        topMemeTextField.text = ""
        bottomMemeTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    @IBAction func performFontSelectorButton(_ sender: UIBarButtonItem) {
        var controller: PickFontViewController
        
        controller  = storyboard?.instantiateViewController(withIdentifier: "FontSelectorVC") as! PickFontViewController
        controller.m_currentFont = globalFontValue
        controller.delegate = self
      //PickFontViewController.delegate = self
                present(controller, animated: true, completion: nil)
       
        
    }
    @IBAction func performActionButton(_ sender: AnyObject)
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
                self.dismiss(animated: true, completion: nil)
            }
        }
        // 4. present the ActivityViewController and add a completion method to save the meme
        present(actViewController, animated: true, completion: nil)
    }
    
    
    // Display the saved photo for user to choose from existing pictures to MeMe.
    @IBAction func performAlbumButtonAction(_ sender: AnyObject)
    {
        //UNCOMMENT TO DEBUG print("THE ALBUM BUTTON HAS BEEN PRESSED")
        showImagePickerController(.savedPhotosAlbum)
    }
    
    func saveExistingMemeChanges()
    {
        print("EDIT EXISTING MEME CHANGE TO SAVE ICON")
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        topMemeTextField.delegate = self
        bottomMemeTextField.delegate = self
        setToInitialState()
        topMemeTextField.text = memeObj?.topText
        bottomMemeTextField.text = memeObj?.bottomText
        userSelectedImage.image = memeObj?.originalImage
        
        if (editMemeFlag == true)
        {
            actionButton.isEnabled = true
            //actionButton = nil
            //actionButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveExistingMemeChanges))
            actionButton = UIBarButtonItem(title: "SAVE", style: UIBarButtonItemStyle.plain, target: self, action: #selector(saveExistingMemeChanges))
           navigationItem.leftBarButtonItem = actionButton
            
        }
        
        
        // List all available font names3
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        
    }

    
    func showImagePickerController(_ sourceType: UIImagePickerControllerSourceType)
    {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        
        // Allow Editing to allow for cropping an image per Udacity forums.
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    // Display the camera for the user to take a picture
    @IBAction func performCameraButtonAction(_ sender: AnyObject)
    {
        // UNCOMMENT TO DEBUG print("THE CAMERA BUTTON HAS BEEN PRESSED")
        showImagePickerController(.camera)
    }
    
    
    func setAttributedStringValue() -> [String : AnyObject]
    {
        let memeTextAttri = [   NSStrokeColorAttributeName: UIColor.black,
                                NSForegroundColorAttributeName: UIColor.white,
                                NSFontAttributeName: UIFont(name: globalFontValue, size: 40)!,
                                NSStrokeWidthAttributeName: -3.0] as [String : Any]
        
        
        return memeTextAttri as [String : AnyObject]

    }
    
    func setPlaceHolderAttributedStringValue(_ placeholderTxt: String) -> NSAttributedString
    {
       let placeHolderASV = NSAttributedString(string: placeholderTxt, attributes: [
                            NSForegroundColorAttributeName:UIColor.white,
                            NSFontAttributeName : UIFont(name: globalFontValue, size: 40)!,
                            NSStrokeColorAttributeName: UIColor.black,
                            NSStrokeWidthAttributeName: -3.0]
                            )
        
        return placeHolderASV

    }
    
    // Sets everything back to the intial state
    func setToInitialState()
    {
        actionButton.isEnabled = false
        memeView.backgroundColor = UIColor.black
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
       
        topMemeTextField.textAlignment = .center
        bottomMemeTextField.textAlignment = .center
        
        
        // Check to see if a camera exists on a device
        if ((UIImagePickerController.availableCaptureModes(for: .rear) != nil) &&
                (UIImagePickerController.availableCaptureModes(for: .front) != nil)){

            cameraButton.isEnabled = true
        }
        else
        {
            cameraButton.isEnabled = false
        }
        
        
    }
    

    // Implement delegate methods of UIImagePickerController delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let userSelectedImageVal = info[UIImagePickerControllerOriginalImage] as! UIImage
        userSelectedImage.image = userSelectedImageVal
        actionButton.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // Clear out the placeholder text when the user begins editing
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if ((textField.placeholder == "TOP") || (textField.placeholder == "BOTTOM"))
        {
            textField.placeholder?.removeAll()
        }
    }
    
    //  If the user is done editing and the textfield is blank, set it to the appropriate place holder text value
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if (textField.text == "")
        {
            if (textField.tag == 1)
            {
                textField.defaultTextAttributes = setAttributedStringValue()
                textField.attributedPlaceholder = setPlaceHolderAttributedStringValue("BOTTOM")
                textField.textAlignment = .center
            }
            else if (textField.tag == 2)
            {
                textField.defaultTextAttributes = setAttributedStringValue()
                textField.attributedPlaceholder = setPlaceHolderAttributedStringValue("TOP")
                textField.textAlignment = .center
            }
            else
            {
                print("INVALID TAG SUPPLIED \(textField.tag)")
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillShow,object:nil)
        NotificationCenter.default.removeObserver(self,name: NSNotification.Name.UIKeyboardWillHide,object:nil)
    }
    
    func keyboardWillShow(_ notification: Notification)
    {
        if bottomMemeTextField.isFirstResponder
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
    
    func keyboardWillHide(_ notification: Notification)
    {
        if bottomMemeTextField.isFirstResponder{
            view.frame.origin.y = 0//+= getKeyboardHeight(notification)
            // UNCOMMENT TO DEBUG print("Keyboard hiding")
            
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        memeToolBar.isHidden = true
        memeNavBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        memeToolBar.isHidden = false
        memeNavBar.isHidden = false
        
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
        //savedMemes.append(memeModelVal)
    
        // Add new meme to the appdelegate to implement a shared model
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.globalMemes.append(memeModelVal)
    
        print("IMAGE SAVED AND ADDED TO ARRAY")
    
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    override var prefersStatusBarHidden : Bool
    {
        return true
    }
    
   
    // Implementing this methods conforms to PickFontProtocol.  It will kick off once a users selects an existing or new font.
    func updateFont(_ newFontValue: String)
    {
        globalFontValue = newFontValue
        print("THE FOLLOWING FONT WAS SELECTED AND NOW UPDATE \(globalFontValue)")
    
        bottomMemeTextField.defaultTextAttributes = setAttributedStringValue()
        bottomMemeTextField.textAlignment = .center
        topMemeTextField.defaultTextAttributes = setAttributedStringValue()
        topMemeTextField.textAlignment = .center
    
    }
}

