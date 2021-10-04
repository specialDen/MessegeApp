//
//  StorageManager.swift
//  MessegeApp
//
//  Created by Izuchukwu Dennis on 02.10.2021.
//

import Foundation
import FirebaseStorage
import SwiftUI


final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    public func uploadPrifilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion){
        
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else {
//                failed
                print("Failed to upload data to firebase for picture")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("Failled to get download url")
                    completion(.failure(StorageError.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("url download successfull with url: \(urlString)")
                completion(.success(urlString))
            }
        })
    }
    
    public enum StorageError: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadUrl(for path: String, completion: @escaping(Result<URL, Error>) -> Void ){
        let reference = storage.child(path)
        reference.downloadURL { url, error in
            guard let url = url, error == nil else{
                completion(.failure(StorageError.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
        }
    }
}

