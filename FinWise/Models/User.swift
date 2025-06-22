//
//  User.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    var uid: String
    var fullName: String
    var email: String
    var mobileNumber: String?
    var dateOfBirth: String?
    var profileImageURL: String?
    var createdAt: Date
    var updatedAt: Date
    var biometricEnabled: Bool
    var hasCompletedOnboarding: Bool
    
    init(uid: String, fullName: String, email: String, mobileNumber: String? = nil, dateOfBirth: String? = nil) {
        self.uid = uid
        self.fullName = fullName
        self.email = email
        self.mobileNumber = mobileNumber
        self.dateOfBirth = dateOfBirth
        self.profileImageURL = nil
        self.createdAt = Date()
        self.updatedAt = Date()
        self.biometricEnabled = false
        self.hasCompletedOnboarding = false
    }
    
    // Convert to dictionary for Firestore
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "fullName": fullName,
            "email": email,
            "mobileNumber": mobileNumber ?? "",
            "dateOfBirth": dateOfBirth ?? "",
            "profileImageURL": profileImageURL ?? "",
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt),
            "biometricEnabled": biometricEnabled,
            "hasCompletedOnboarding": hasCompletedOnboarding
        ]
    }
} 