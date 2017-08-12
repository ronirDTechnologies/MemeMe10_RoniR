//
//  MemeSentTableViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 6/28/16.
//  Copyright © 2016 Roni Rozenblat. All rights reserved.
//

import UIKit
import Foundation

class MemeSentTableViewController: UITableViewController {
    @IBOutlet var SentMemeTableView: UITableView!
    

    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).globalMemes
    }
   
    override func viewWillAppear(_ animated: Bool) {
        SentMemeTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(MemeSentTableViewController.createNewMeme))
        
        
    }

    func createNewMeme()
    {
        print("CLICKED CREATE NEW MEME")
        // Get the storyboard and ResultViewController
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "MemeEditor")as! MemeEditorViewController
        
        // Communicate the match
        
        present(resultVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    

    override func numberOfSections(in tableView: UITableView) -> Int {
               return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("HERE IS THE NEW MEME COUNT ==> \(memes.count)")
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMeme", for: indexPath) as! SentMemeTableViewCell

        // Configure the cell...
        let memeAtPath = memes[indexPath.row] as Meme!
        cell.sentMemeTableCellImage?.image = memeAtPath?.memedImage
        cell.sentMemeTableCellLabel.text = (memeAtPath?.topText)! + "...." + (memeAtPath?.bottomText)!
        
        

        return cell
    }
    
   

    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            (UIApplication.shared.delegate as! AppDelegate).globalMemes.remove(at: indexPath.row)
                        
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
     
        }
    }
 

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMemeTableDetail",
        let destination = segue.destination as? MemeDetailViewController,
            let memeImageIndex = tableView.indexPathForSelectedRow?.row{
        
            destination.combMemeImage = memes[memeImageIndex].memedImage
            destination.topTextString = memes[memeImageIndex].topText
            destination.bottomTextString = memes[memeImageIndex].bottomText
            destination.origImage = memes[memeImageIndex].originalImage
            destination.memeObj = memes[memeImageIndex]
            
            // 08-12-2017: Per code review, hide tab bar on push to detail meme view
            destination.hidesBottomBarWhenPushed = true
        }
    }
  

}
