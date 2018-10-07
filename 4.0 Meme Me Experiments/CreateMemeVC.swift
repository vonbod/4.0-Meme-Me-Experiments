//
//  ViewController.swift
//  4.0 Meme Me Experiments
//
//  Created by Enno von Bodecker on 29.09.18.
//  Copyright © 2018 EvB. All rights reserved.
//

import UIKit

/* Review comments:
I am not sure what is menat by "create the struct on a dedicated file"  as far as I understand,
If created outside the class scope it should be visible for other clases to use, am I right?
*/
struct MemeData {   // Struct that holds the memeData
	let textTop : String?
	let textBottom : String?
	let originalImage : UIImage?
	let memedImage : UIImage?
}

class CreateMemeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	
	// TextField Properties(styles): Dictionary for Textformat
	let memeTextAttributes:[NSAttributedString.Key: Any] = [
		NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
		NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
		NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -2.0]

	// MARK: OUTLETS Config
	@IBOutlet weak var imagePickerView: UIImageView!
	@IBOutlet weak var textOne: UITextField!
	@IBOutlet weak var textTwo: UITextField!
	@IBOutlet weak var camaraButton: UIBarButtonItem!
	@IBOutlet weak var topToolbar: UIToolbar!
	@IBOutlet weak var bottomToolbar: UIToolbar!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	
	// Not needed anymore since UITextField Delegate has been moved to this class and is not external anymore.
	// MARK: DELEGATE External delegate for textfields
	//let memeTextFieldsDelegate = MemeTextFieldsDelegate()
	
	// MARK: OVERRIDE Functions
	override func viewDidLoad() {
		super.viewDidLoad()
		//Configure the nessesary properties of the textFields
		self.configureUI()
		
		// Check if the device the App is running on has a camara and enable/disable the toolbar Button accordingly
		let hasCamara = UIImagePickerController.isSourceTypeAvailable(.camera)
		self.camaraButton.isEnabled = hasCamara
	}
	
	//MARK: ViewWillAppear()
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.subscribeToKeyboardNotifications()
	}
	
	//Mark: ViewWillDisappear()
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.unsubscribeFromKeyboardNotifications()
	}
	
	//MARK: UITextFieldDelegate Methods
	// Prepare textField for new entry
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.text = ""
		textField.placeholder = ""
		textField.becomeFirstResponder()  /* Keyboard: Works with and without this line */
		if textField == textTwo {
			// Udacity class didn't mention the textfield placeholder property. Instead of implementing the textFieldDidBeginEditing use the
			// placeholder property and that method code is not necessary.
			// --> I know and I used that property but I think setting it manually is cleaner that using the placeholder.
			
			// When leaving textTwo with tab, the App looses track of screenpositions.
			// Need to catch the tab-key pressed evetn here and just make textTwo resign as a first responder
		}
	}
	
	// What happens when you press Enter:
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == textOne {
			textOne.resignFirstResponder()
			textTwo.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}
		return true
	}
	/* note for the tutor:
	How do I catch the Tab key event pressed? Explanation: When using a hardware keyboard on the simulator
	I have a tab key which the iOS Keyboard doesn't have. Now, if you exit the Bottom Textfield with tab, the
	App seems to lose track of screenpositions and the sliding the view up/down goes wrong. I would like to
	catch the Tabkexpressed event and prevent caos from happening. There seems to be no method that concerns
	itself with this problem though, on stackoverflow I cann see that this is a common problem. Any hints on
	how I can solve this?
	*/
	
	
	// MARK: Configure UserInterface */
	func configureUI() {
		// Give the textfield their delegate: self if UITextFieldDelegate within ViewController
		
		// or in Storyboard with the placeholder property.
		self.textOne.text = "TOP"
		self.textTwo.text = "BOTTOM"
		self.textOne.isHidden = false
		self.textTwo.isHidden = false
		
		// Call method to set styles for textFields
		setTextFieldProperties(toTextField: textOne)
		setTextFieldProperties(toTextField: textTwo)
		
		self.shareButton.isEnabled = false
	}

	// Layout styles for the textfields used in the Meme
	func setTextFieldProperties(toTextField textField: UITextField) {
		textField.defaultTextAttributes = memeTextAttributes
		textField.textAlignment = .center
		textField.autocapitalizationType = .allCharacters
		textField.delegate = self
		
		/* Comment to tutor: textField.autocapitalizationType = .allCharacters doesn't work on iPpad, why? */
	}
	
	// imagePickerController: User selected picture
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		// UIImagePickerController.InfoKey.originalImage contains image selected by the picker
		if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			self.imagePickerView.contentMode = .scaleAspectFit //Image scaling
			self.imagePickerView.image = selectedImage
			
			// After chosing the picker can be removed to display the image
			dismissForm()
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

		// hide the toolbars so we don't see them in the picture
		self.hideToolBars(toHide: true)
		
		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		// unhide the toolbars to use the App
		self.hideToolBars(toHide: false)

		return memedImage
	}
	
	// Hide the Tool and Navigation bars
	func hideToolBars(toHide hide: Bool) {
		if hide {
			self.topToolbar.isHidden = true
			self.bottomToolbar.isHidden = true
		} else {
			self.topToolbar.isHidden = false
			self .bottomToolbar.isHidden = false
		}
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
		openImagePicker(.photoLibrary)
		/* Note to myself:
			SET NSPhotoLibraryUsageDescription:
			“Privacy - Photo Library Usage Description” in Info.plist
		*/
	}

	@IBAction func pickImageFromCamara(_ sender: Any) {   /* Image from Camera */
		openImagePicker(.camera)
		/* Note to myself:
			SET NSCameraUsageDescription:
			“Privacy - Camera Usage Description” in Info.plist
		*/
	}
	
	//MARK: openImagePicker from different sources: .camera, .library
	func openImagePicker(_ type: UIImagePickerController.SourceType){
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = type
		present(imagePicker, animated: true, completion: nil)
	}
	
	
	// Share the meme and save it.
	@IBAction func shareMeme(_ sender: Any) {
		let memedImage = generateMemedImage()
		let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)

		// On iPad UIActivityViewController is presented with a popover
		controller.popoverPresentationController?.sourceView = self.view
		//controller.popoverPresentationController?.sourceRect = topToolbar.barPosition
		
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
		self.configureUI()
	}
}
