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
    

    var memes: [MemeModel] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).globalMemes
    }
   
    override func viewWillAppear(animated: Bool) {
        SentMemeTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.Add, target: self, action: #selector(MemeSentTableViewController.createNewMeme))
        
        
    }

    func createNewMeme()
    {
        print("CLICKED CREATE NEW MEME")
        // Get the storyboard and ResultViewController
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditor")as! MemeEditorViewController
        
        // Communicate the match
        
        presentViewController(resultVC, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
               return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("HERE IS THE NEW MEME COUNT ==> \(memes.count)")
        return memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sentMeme", forIndexPath: indexPath) as! SentMemeTableViewCell

        // Configure the cell...
        let memeAtPath = memes[indexPath.row] as MemeModel!
        cell.sentMemeTableCellImage?.image = memeAtPath.memedImage
        cell.sentMemeTableCellLabel.text = memeAtPath.topText + "...." + memeAtPath.bottomText
        
        

        return cell
    }
    
   

    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            (UIApplication.sharedApplication().delegate as! AppDelegate).globalMemes.removeAtIndex(indexPath.row)
                        
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
     
        }
    }
 

   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMemeTableDetail",
        let destination = segue.destinationViewController as? MemeDetailViewController,
            let memeImageIndex = tableView.indexPathForSelectedRow?.row{
        
            destination.combMemeImage = memes[memeImageIndex].memedImage
            destination.topTextString = memes[memeImageIndex].topText
            destination.bottomTextString = memes[memeImageIndex].bottomText
            destination.origImage = memes[memeImageIndex].originalImage
            destination.memeObj = memes[memeImageIndex]
        }
    }
  

}
