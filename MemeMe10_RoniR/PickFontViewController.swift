//
//  PickFontViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 5/23/16.
//  Copyright © 2016 Roni Rozenblat. All rights reserved.
//

import UIKit
protocol PickFontProtocol: class{
    func updateFont(_ newFontValue:String)
}



class PickFontViewController: UITableViewController   {
    
    
    var m_currentFont: String?
    var m_newFont: String?
    var globalFontValues = ["Impact","Copperplate","MarkerFelt-Thin","GillSans","Georgia"]
    var checkRowIndex: IndexPath?
    weak var delegate: PickFontProtocol?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return globalFontValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontPickerCell", for: indexPath)
        
        // Set the text of the cell
        cell.textLabel?.text = globalFontValues[indexPath.row]
        
        // Set the font of the cell to show the user what the font will look like
        cell.textLabel?.font = UIFont(name: globalFontValues[indexPath.row], size: 20)
        
        // Check to see what the current font was set to and mark it appropriatley
        if m_currentFont == globalFontValues[indexPath.row]
        {
            cell.accessoryType = .checkmark
            
            // Mark which row has been checked
            checkRowIndex = indexPath
        }
        else
        {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         if let cell = tableView.cellForRow(at: indexPath)
         {
            // If the cell is not the currently selected cell, then check it, change the global font and dimiss the view controller
            if cell.accessoryType == .none
            {
                cell.accessoryType = .checkmark
                tableView.deselectRow(at: checkRowIndex!, animated: true)
                if let priorCheckedCell = tableView.cellForRow(at: checkRowIndex!)
                {
                    priorCheckedCell.accessoryType = .none
                }
                checkRowIndex = indexPath
                m_newFont = globalFontValues[indexPath.row]
                
                delegate?.updateFont(m_newFont!)
                dismiss(animated: true, completion: nil)
            }
            // Otherwise just keep the current font and dimiss the view controller.
            else
            {
                delegate?.updateFont(m_currentFont!)
                dismiss(animated: true, completion: nil)
            }
        }
        
        
        
    }
    // Hide status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    
    
    
    
}
