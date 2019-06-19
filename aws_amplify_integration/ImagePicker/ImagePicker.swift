//
//  ImagePicker.swift
//  aws_amplify_integration
//
//  Created by Calin Cristian on 19/06/2019.
//  Copyright © 2019 Calin Cristian Ciubotariu. All rights reserved.
//

import UIKit
import Photos

protocol ImagePickerDelegate: class {
    func didSelectImage(_ image: UIImage?, withName imageName: String?)
}

extension ImagePickerDelegate {
    func didSelectImage(_ image: UIImage?, imageName: String? = nil) {
        return didSelectImage(image, withName: imageName)
    }
}

class ImagePicker: NSObject {
    
    private weak var delegate: ImagePickerDelegate?
    private weak var presentationViewController: UIViewController?
    private let pickerController: UIImagePickerController
    
    init(presentationViewController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.delegate = delegate
        self.presentationViewController = presentationViewController
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    private func pickerController(_ controller: UIImagePickerController,
                                  didSelect image: UIImage?,
                                  withName imageName: String? = nil) {
        
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelectImage(image, withName: imageName)
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationViewController?.present(self.pickerController, animated: true)
        }
    }
    
    public func present() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.presentationViewController?.present(alertController, animated: true)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("info --> \(info)")
        
        guard let image = info[.editedImage] as? UIImage else {
            self.pickerController(picker, didSelect: nil)
            return
        }
        
        guard let asset = info[.phAsset] as? PHAsset,
            let fileName = asset.value(forKey: "filename") as? String else {

                self.pickerController(picker, didSelect: image)
                return
        }
        
        self.pickerController(picker, didSelect: image, withName: fileName)
    }
}

extension ImagePicker: UINavigationControllerDelegate { }
