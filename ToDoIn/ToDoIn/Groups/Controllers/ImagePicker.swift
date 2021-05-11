//
//  ImagePicker.swift
//  ToDoIn
//
//  Created by Philip on 05.05.2021.
//

import Foundation
import UIKit


class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Выберете изображение", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
        let cameraAction = UIAlertAction(title: "Камера", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Галерея", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel){
            UIAlertAction in
        }
        
                picker.delegate = self
                alert.addAction(cameraAction)
                alert.addAction(galleryAction)
                alert.addAction(cancelAction)
            }

            func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
                pickImageCallback = callback;
                self.viewController = viewController;

                alert.popoverPresentationController?.sourceView = self.viewController!.view

                viewController.present(alert, animated: true, completion: nil)
            }
            func openCamera(){
                alert.dismiss(animated: true, completion: nil)
                if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                    picker.sourceType = .camera
                    self.viewController?.present(picker, animated: true, completion: nil)
                } else {
                    let alertWarning = UIAlertView(title:"Внимание", message: "Камера не обнаружена", delegate:nil, cancelButtonTitle:"Ок", otherButtonTitles:"")
                    alertWarning.show()
                }
            }
            func openGallery(){
                alert.dismiss(animated: true, completion: nil)
                picker.sourceType = .photoLibrary
                self.viewController!.present(picker, animated: true, completion: nil)
            }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true, completion: nil)
            guard let image = info[.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            pickImageCallback?(image)
        }



    }
