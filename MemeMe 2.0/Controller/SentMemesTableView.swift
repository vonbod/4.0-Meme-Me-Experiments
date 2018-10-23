//
//  EditMemeVC.swift
//  MemeMe 2.0
//
//  Created by Enno von Bodecker
//

import Foundation
import UIKit

// MARK: - ViewController: UIViewController, UITableViewDataSource
class SentMemesTableView: UIViewController, UITableViewDataSource {
	
	//Mark: Outlets
	@IBOutlet weak var editButton: UIBarButtonItem!
	@IBOutlet weak var sentTableView: UITableView!
	
	// MARK: Variables and consants
	let cellReuseIdentifier = "sentMemesCell"
	//let appDelegate = UIApplication.shared.delegate as! AppDelegate
	//var memeData = [MemeData]()
	var memeData: [MemeData] {
		return (UIApplication.shared.delegate as! AppDelegate).memes
	}
	
	//MARK: ViewWillAppear()
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if (self.memeData.count < 1) {
			editButton.isEnabled = false
			//self.navigationController!.pushViewController(detailController, animated: true)
		}
		
		// Reload the tableView after adding Memes
		self.sentTableView.reloadData()
	}
	
	// MARK: Datasources: UITableViewDataSource
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfMemes = self.memeData.count
		return numberOfMemes
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell =  tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier, for: indexPath)
		let individualMeme = self.memeData[(indexPath as NSIndexPath).row]
		
		// Content of the cells in the tableview
		cell.imageView?.image = individualMeme.memedImage
		cell.textLabel?.text = individualMeme.textTop
		cell.detailTextLabel?.text = individualMeme.textBottom
		
		return cell
	}
	
	//MARK: Future Addons: tableView(_ :didSelectRowAt:) method to ViewController
	//func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	//	let memeDetailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetailVC") as! MemeDetailVC
	//  let dictionary = self.meme[(indexPath as NSIndexPath).row]
	//}

	// + Button goes to Create Meme Editor
	@IBAction func createMeme(_ sender: Any) {
		let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorID") as! CreateMemeVC
		self.present(detailController, animated: true, completion: nil)
	}

}
