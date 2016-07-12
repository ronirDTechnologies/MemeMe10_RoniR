//
//  MemeSentTableViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 6/28/16.
//  Copyright © 2016 Roni Rozenblat. All rights reserved.
//

import UIKit

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
       
        //SentMemeTableView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.Add, target: self, action: #selector(MemeSentTableViewController.createNewMeme))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
