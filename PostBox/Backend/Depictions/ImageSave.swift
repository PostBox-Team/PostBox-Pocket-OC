//
//  ImageSave.swift
//  PostBox
//
//  Created by b0kch01 on 6/13/21.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import UIKit

/// https://www.hackingwithswift.com/books/ios-swiftui/how-to-save-images-to-the-users-photo-library
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
