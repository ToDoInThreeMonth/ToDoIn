import UIKit


final class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var picker = UIImagePickerController();
    private var alert = UIAlertController(title: "Выберите изображение", message: nil, preferredStyle: .actionSheet)
    private var viewController: UIViewController?
    private var pickImageCallback : ((UIImage) -> ())?;
    
    override init(){
        super.init()
        
        picker.delegate = self
        
        configureActions()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        alert.popoverPresentationController?.sourceView = self.viewController?.view
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private func configureActions() {
        let cameraAction = UIAlertAction(title: "Камера", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Галерея", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
    }
    
    private func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController?.present(picker, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(title: "Внимание", message: "Камера не обнаружена", preferredStyle: .alert)
            viewController?.present(alertVC, animated: true, completion: nil)
        }
    }
    private func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        guard let viewController = viewController else {
            return
        }
        viewController.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            let alert = AlertControllerCreator.getController(title: "Ошибка при выборе фотографии", message: nil, style: UIAlertController.Style.alert, type: AlertControllerCreator.TypeAlert.error)
            alert.popoverPresentationController?.sourceView = self.viewController?.view
            viewController?.present(alert, animated: true, completion: nil)
            return
        }
        pickImageCallback?(image)
    }
}
