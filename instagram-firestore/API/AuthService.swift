//
//  AuthService.swift
//  instagram-firestore
//
//  Created by Sydney Turner on 3/19/23.
//

import Firebase
import UIKit


struct AuthCredentials {
    let email: String
    let passowrd: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static func logUserIn(withEmail email: String, password: String, completion: @escaping(AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping((Error?) -> Void)) {
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.passowrd) { result, error in
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] = ["email": credentials.email,
                                           "fullname": credentials.fullname,
                                           "profileImageUrl": imageUrl,
                                           "uid": uid,
                                           "username": credentials.username]
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
            }
        }
    }
}
