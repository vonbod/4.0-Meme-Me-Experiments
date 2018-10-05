//
//  ViewController.swift
//  4.0 Meme Me Experiments
//
//  Created by Enno von Bodecker on 29.09.18.
//  Copyright © 2018 EvB. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {

	// Struct that holds the memeData
	struct MemeData {
		let textTop : String?
		let textBottom : String?
		let originalImage : UIImage?
		let memedImage : UIImage?
	}
	
	// MARK: OUTLETS Config
	@IBOutlet weak var imagePickerView: UIImageView!
	@IBOutlet weak var textOne: UITextField!
	@IBOutlet weak var textTwo: UITextField!
	@IBOutlet weak var camaraButton: UIBarButtonItem!
	@IBOutlet weak var topToolbar: UIToolbar!
	@IBOutlet weak var bottomToolbar: UIToolbar!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	
	// MARK: DELEGATE External delegate for textfields
	let memeTextFieldsDelegate = MemeTextFieldsDelegate()
	
	// MARK: OVERRIDE Functions
	override func viewDidLoad() {
		super.viewDidLoad()
		//Configure the nessesary properties of the textFields
		self.configureUI()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		//navigationController?.setToolbarHidden(true, animated: true)
		
		// Check if the device the App is running on has a camara and enable/disable the toolbar Button accordingly
		let hasCamara = UIImagePickerController.isSourceTypeAvailable(.camera)
		self.camaraButton.isEnabled = hasCamara
		self.subscribeToKeyboardNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.unsubscribeFromKeyboardNotifications()
	}
	
	// MARK: Configure UserInterface */
	func configureUI() {
		// Give the textfield their delegate: self if UITextFieldDelegate within ViewController
		self.textOne.delegate = memeTextFieldsDelegate
		self.textTwo.delegate = memeTextFieldsDelegate
		
		// or in Storyboard with the placeholder property.
		self.textOne.text = "Pick a pic..."
		self.textOne.isHidden = false
		self.textTwo.text = "BOTTOM"
		
		// Dictionary for Textformat
		let memeTextAttributes:[NSAttributedString.Key: Any] = [
			NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
			NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
			NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
			NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -2.0]
		
		self.textOne.defaultTextAttributes = memeTextAttributes
		self.textTwo.defaultTextAttributes = memeTextAttributes
		self.textOne.textAlignment = .center
		self.textTwo.textAlignment = .center
		self.textOne.autocapitalizationType = .allCharacters
		
		self.shareButton.isEnabled = false
		/* Comment for tutor:
		The autocapitalizationType setting is not working when
		deploying the project to the iPad. All charachters entered
		are minucular. It does work fine in the simulator though.
		It is also set to ALL Caps in the Storyboard.
		*/
	}

	// imagePickerController: User selected picture
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		// UIImagePickerController.InfoKey.originalImage contains image selected by the picker
		if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			self.imagePickerView.contentMode = .scaleAspectFit //Image scaling
			self.imagePickerView.image = selectedImage
			
			// After chosing the picker can be removed to display the image
			dismissForm()
			self.textOne.text = "TOP"
			self.textTwo.isHidden = false
			// when imagePickerView has an image we can enable the share buttom
			self.shareButton.isEnabled = true
		}
	}
	
	// imagePickerControllerDidCancel: Dismiss Picker, it was canceled by the user
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismissForm()
	}
	
	// To avoid identical code in varios places.
	func dismissForm() {
		self.dismiss(animated: true, completion: nil)
	}

	// MARK: generateMemedImage() & SAVE
	/* Generate the memData that ca be saved */
	func generateMemedImage() -> UIImage {  /* Provide by UDACITY */
		self.bottomToolbar.isHidden = true
		self.topToolbar.isHidden = true
		
		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		self.bottomToolbar.isHidden = false
		self.topToolbar.isHidden = false
		return memedImage
	}
	
	// Save the image
	func saveMeme(memedImage: UIImage) {
		/* I am not sure why I have to create and/or use the struct.  */
		let meme = MemeData(textTop: textOne.text, textBottom: textTwo.text, originalImage: imagePickerView.image, memedImage: memedImage)
		
		// code for actual saving is not implemented
	}
	
	//MARK: Notification subscriptions
	func subscribeToKeyboardNotifications() {
		// Subscribe to KeyboardWillShow Notification
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		// Subscribe to KeyboardWillHide Notification
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		// Unsubscribe to KeyboardWillShow Notification
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		// Unsubscribe to KeyboardWillShow Notification
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		if self.textTwo.isEditing {  /* only shift keyboard for Bottom text */
			self.view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		if self.textTwo.isEditing {  /* only shift keyboard for Bottom text */
			self.view.frame.origin.y += getKeyboardHeight(notification)
		} /* else  if textOne.isEditing {  // How can I set the focus to the Bottom when done with Top?
		textTwo.becomeFirstResponder() /* Set focus to Bottom Text */
		} */
	}
	
	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
		return keyboardSize.cgRectValue.height
	}
	
	// MARK: IBAction for Image from Library
	@IBAction func pickAnImageFromAlbum(_ sender: Any) {  /* Image from Library */
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = .photoLibrary
		present(imagePicker, animated: true, completion: nil)
		/* Note to myself:
			SET NSPhotoLibraryUsageDescription:
			“Privacy - Photo Library Usage Description” in Info.plist
		*/
	}

	@IBAction func pickImageFromCamara(_ sender: Any) {   /* Image from Camera */
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = .camera
		present(imagePicker, animated: true, completion: nil)
		/* Note to myself:
			SET NSCameraUsageDescription:
			“Privacy - Camera Usage Description” in Info.plist
		*/
	}
	
	// Share the meme and save it.
	@IBAction func shareMeme(_ sender: Any) {
		let memedImage = generateMemedImage()
		let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

		// On iPad UIActivityViewController is presented with a popover
		controller.popoverPresentationController?.sourceView = self.view
		//controller.popoverPresentationController?.sourceRect = sender.frame
		
		self.present(controller, animated: true, completion: nil )
		controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> Void in
			if (completed) {
				self.saveMeme(memedImage: memedImage)
				self.dismissForm()
			} else {
				// Reason: Could be canceld
			}
		}
	}
	
	@IBAction func cancelApp(_ sender: Any) {
		self.imagePickerView.image = nil
		self.textOne.text = "Pick a pic..."
		self.textTwo.isHidden = true
		self.configureUI()
	}
}
