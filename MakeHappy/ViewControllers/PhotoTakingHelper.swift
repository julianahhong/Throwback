//
//  PhotoTakingHelper.swift
//  MakeHappy
//
//  Created by Juliana Hong on 7/30/15.
//  Copyright (c) 2015 Juliana Hong. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper : NSObject {
    
    /** View controller on which AlertViewController and UIImagePickerController are presented */
    weak var viewController: UIViewController!
    var callback: PhotoTakingHelperCallback
    
    var imagePickerController: UIImagePickerController?
    
    let picker = UIImagePickerController()
    
    init(viewController: UIViewController, callback: PhotoTakingHelperCallback) {
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
        
    }
    

    func showPhotoSourceSelection() -> Void {
        // Allow user to choose between photo library and camera
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Only show camera option if rear camera is available
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear)) {
            let cameraAction = UIAlertAction(title: "Photo from Camera", style: .Default) { (action) in
                
                self.showImagePickerController(.Camera)
            }
            
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo from Library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        
        alertController.addAction(photoLibraryAction)
        
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) -> Void {
        
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController!.delegate = self
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }


}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        viewController.dismissViewControllerAnimated(false, completion: nil)
        callback(image)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
