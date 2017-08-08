//
//  MemeModel.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 5/15/16.
//  Copyright © 2016 Roni Rozenblat. All rights reserved.
//

import Foundation
import UIKit
/*
 * Meme Model representing an entire user Meme
 * @topText - Will hold the text that appears at the top of the Meme
 * @bottomText - Will hold the text that appears at the bottom of the Meme
 * @orginalImage - Will hold the original image that was either selected from the photo library or
 *                 taken by the device.
 * @memedImage - Will hold the combined image and topText and bottomText of Meme.
 */
struct Meme{
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}
