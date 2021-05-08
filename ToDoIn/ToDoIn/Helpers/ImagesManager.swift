import UIKit
import FirebaseStorage

final class ImagesManager {
    
    static func uploadPhoto(id: String, photo: UIImage?, completion: @escaping (Result<URL, СustomError>) -> Void) {
        let ref = Storage.storage().reference().child("groupsAvatars").child(id)
        
        guard let imageData = photo?.jpegData(compressionQuality: 0.3) else { return }
        
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
                }
            }
        }
    }
    
    static func loadPhoto(url: String, completion: @escaping (Result<UIImage, СustomError>) -> Void) {
        let ref = Storage.storage().reference(forURL: url)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { (data, error) in
            if error != nil {
                print(error!)
                completion(.failure(СustomError.error))
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("error")
                completion(.failure(СustomError.unexpected))
                return
            }
            print("ok")
            completion(.success(image))
        }
    }
}
