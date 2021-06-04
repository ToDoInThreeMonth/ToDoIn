import UIKit
import FirebaseStorage

final class ImagesManager {
    
    static private let imageCache = NSCache<NSString, UIImage>()
    
    static func loadPhotoToStorage(id: String, photo: UIImage?, completion: @escaping (Result<URL, СustomError>) -> Void) {
        let ref = Storage.storage().reference().child(id)
        guard let photo = photo, let imageData = photo.jpegData(compressionQuality: 0.3) else {
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        ref.putData(imageData, metadata: metadata) { (metadata, error) in
            if error != nil {
                completion(.failure(СustomError.error))
            } else {
                ref.downloadURL { (url, error) in
                    guard let url = url else {
                        completion(.failure(СustomError.error))
                        return
                    }
                    completion(.success(url))
                    imageCache.setObject(photo, forKey: url.absoluteString as NSString)
                }
            }
        }
    }
    
    static func loadPhotoFromStorage(url: String, completion: @escaping (Result<UIImage, СustomError>) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        let ref = Storage.storage().reference(forURL: url)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { (data, error) in
            if error != nil {
                completion(.failure(СustomError.error))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(СustomError.unexpected))
                return
            }
            imageCache.setObject(image, forKey: url as NSString)
            completion(.success(image))
        }
    }
}
