//
//  File.swift
//  MessegeApp
//
//  Created by Izuchukwu Dennis on 20.09.2021.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}
//MARK: - Account Management
extension DatabaseManager{
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool)->Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            
            print(snapshot.exists())
            print(snapshot.value as? String)
            if snapshot.exists() {
                
                completion(true)
            } else {
                
                completion(false)
            }
            
        }
        
    }
    
    //    Insert a new user
    public func insertUser(with user: MessageAppUser, completion: @escaping (Bool)-> Void){
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName]) { error, _ in
                guard error == nil else {
                    print("failed to write to dataBase")
                    completion(false)
                    return
                }
                self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                    if var usersCollection = snapshot.value as? [[String: String]]{
                        //                        append to user dictionary
                        
                        let newElement = [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                        
                        usersCollection.append(newElement)
                        
                        self.database.child("users").setValue(usersCollection) { error, _ in
                            guard error == nil else {
                                completion(false)
                                
                                return
                            }
                            
                            completion(true)
                        }
                    } else {
                        //                        create the array
                        let newCollection: [[String: String]] = [
                            [
                                "name": user.firstName + " " + user.lastName,
                                "email": user.safeEmail
                            ]
                        ]
                        
                        self.database.child("users").setValue(newCollection) { error, _ in
                            guard error == nil else {
                                completion(false)
                                
                                return
                            }
                            completion(true)
                        }
                    }
                }
            }
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        }
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
}





struct MessageAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    var profilePictureFilename: String {
        return "\(safeEmail)_profile_picture.png"
    }
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

