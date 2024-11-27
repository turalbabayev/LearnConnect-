//
//  UserManager.swift
//  LearnConnect
//
//  Created by Tural Babayev on 24.11.2024.
//

import Foundation

final class UserManager {
    // Singleton örneği
    static let shared = UserManager()
    let db: FMDatabase?

    private init() {
        let destionationPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let databaseURL = URL(fileURLWithPath: destionationPath).appendingPathComponent("learnConnect.db")
        db = FMDatabase(path: databaseURL.path)
    }
    
    func saveUser(_ user: User, completion: @escaping (Bool) -> Void) {
        db?.open()
        
        do {
            // Kullanıcı ekleme SQL sorgusu
            let query = """
            INSERT INTO Users (Id, fullname, phone, email, profile_photo, birthday, gender, university)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """
            
            try db!.executeUpdate(query, values: [
                user.id,
                user.fullname,
                user.phone ?? "",
                user.email,
                user.profilePhoto ?? "",
                user.birthday ?? "",
                user.gender ?? "",
                user.university ?? ""
            ])
            
            completion(true)
        } catch {
            print("Error saving user: \(error.localizedDescription)")
            completion(false)
        }
        
        db?.close()
    }
    
    func updateUser(_ user: User, completion: @escaping (Bool) -> Void) {
        db?.open()
        
        do {
            // Kullanıcı güncelleme sorgusu
            let query = """
            UPDATE Users
            SET fullname = ?, phone = ?, profile_photo = ?, birthday = ?, gender = ?, university = ?
            WHERE Id = ?
            """
            
            try db!.executeUpdate(query, values: [
                user.fullname,
                user.phone ?? "",
                user.profilePhoto ?? "",
                user.birthday ?? "",
                user.gender ?? "",
                user.university ?? "",
                user.id
            ])
            
            completion(true)
        } catch {
            completion(false)
        }
        
        db?.close()
    }
    
    func getUser(byId id: String, completion: @escaping (User?) -> Void) {
        db?.open()
        
        do {
            let query = "SELECT * FROM Users WHERE Id = ?"
            let rs = try db!.executeQuery(query, values: [id])
            
            if rs.next() {
                let user = User(
                    id: rs.string(forColumn: "id")!,
                    fullname: rs.string(forColumn: "fullname")!,
                    email: rs.string(forColumn: "email")!, 
                    phone: rs.string(forColumn: "phone"),
                    birthday: rs.string(forColumn: "birthday"), 
                    gender: rs.string(forColumn: "gender"),
                    university: rs.string(forColumn: "university"),
                    profilePhoto: rs.string(forColumn: "profile_photo")
                )
                completion(user)
            } else {
                print("User not found with ID: \(id)")
                completion(nil)
            }
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            completion(nil)
        }
        
        db?.close()
    }

}
