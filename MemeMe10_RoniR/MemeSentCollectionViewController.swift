//
//  MemeSentCollectionViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 7/25/16.
//  Copyright © 2016 Roni Rozenblat. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemeCollViewCell"

class MemeSentCollectionViewController: UICollectionViewController {
    
    @IBOutlet var MemeCollectionVC: UICollectionView!
    @IBOutlet var MemeCollectionViewFlowlayout: UICollectionViewFlowLayout!
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).globalMemes
    }
    override func viewWillAppear(_ animated: Bool) {
        MemeCollectionVC.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the flow layout 
        let space:CGFloat = 3.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (view.frame.size.height - (2 * space)) / 3.0
        
        MemeCollectionViewFlowlayout.minimumInteritemSpacing = space
        MemeCollectionViewFlowlayout.minimumLineSpacing = space
        MemeCollectionViewFlowlayout.itemSize = CGSize(width: dimensionWidth, height:dimensionHeight )
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(MemeSentCollectionViewController.createNewMeme))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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


   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeSentCollectionViewCell
    
        // Configure the cell
        
        cell.ImageViewMemeCollectionViewCell.image = memes[indexPath.row].memedImage
        
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCollectionViewDetail"{
            let destination = segue.destination as? MemeDetailViewController
            if let memeImageIndex = collectionView?.indexPath(for: sender as! MemeSentCollectionViewCell){
                destination!.combMemeImage = memes[memeImageIndex.row].memedImage}
        }
    }

    
}
