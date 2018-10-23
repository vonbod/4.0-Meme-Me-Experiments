//
//  MemeTextFieldsDelegate.swift
//  4.0 Meme Me Experiments
//
//  Created by Enno von Bodecker on 03.10.18.
//  Copyright © 2018 EvB. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldsDelegate : NSObject, UITextFieldDelegate {
	// Prepare textField for new entry
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.text = ""
		textField.placeholder = ""
		textField.becomeFirstResponder()  /* Keyboard: Works with and without this line */
	}
	
	// Hide keyboard when done editing
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder() /* NOT SURE: KeyboardDismiss works with/out this line of code */
		
		return true
	}
}
