//
//  ViewController.swift
//  Meme
//
//  Created by Ashutosh Kumar Sai on 12/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //outlets
    //Outlets for Navigation Bar
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    //Outlets for Tollbar
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var gal: UIBarButtonItem!
    //Outlets for Image View
    @IBOutlet weak var imageView: UIImageView!
    //Outlets for texts
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    //Outlets for navbar and topbar
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        modifyText(textField: topText, text: "TOP")
        modifyText(textField: bottomText, text: "BOTTOM")
    }
    //We use this function to modify the text
    func modifyText (textField : UITextField, text: String)
    {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.text = text
        
    }
    
    //we use viewWillAppear for keyboard thing
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        if imageView.image == nil {
            share.isEnabled = false
        } else {
            share.isEnabled = true
        }

        subscribeToKeyboardNotifications()
    }
    
    //we use viewWillDisappeaer for Keyboard thing 
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         unsubscribeFromKeyboardNotifications()
    }
    
    //textAttribute file that we will use in viewDidload
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 32)!,
        NSStrokeWidthAttributeName: -3.0]
    
    //imagePicker controller that we will use to pick image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        }
   //We use this method when we cancel the picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //IBAction for the camera NOTE- We yse sourceType here which is the sole diffrence between this and gal
    @IBAction func cameraAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    //IBAction for gal icon
    @IBAction func galAction(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    //This method is used to reset all the values and image
    @IBAction func cancelAction(_ sender: Any) {
        imageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    //All the methods related to Keyboard 
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:))    , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:))    , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //To dismiss keyboard after editing is done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //function to save Meme 
    func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imageView.image!, memedImage: memedImage)
        
        print("save() is called")

        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    //function to genrate meme
    
    func generateMemedImage() -> UIImage {
        
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    //share method
    
    @IBAction func shareAction(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.save()
            self.dismiss(animated: true, completion: nil)
        }
        present(activityController, animated: true, completion: nil)
    }
    
    //method to use in order to get rid of default entries 
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
            if (topText.text == "TOP") {
                topText.text = ""
            }
            if (bottomText.text == "BOTTOM")
            {
                bottomText.text = ""
            }
        
    
     
}
}


