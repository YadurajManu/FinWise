//  FirestoreService.swift
//  FinWise
//
//  Created by Yaduraj Singh on 22/06/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreService: ObservableObject {
    private let db = Firestore.firestore()
    
    // MARK: - User Operations
    
    /// Create a new user document in Firestore
    func createUser(_ user: User) async throws {
        let userRef = db.collection("users").document(user.uid)
        try await userRef.setData(user.toDictionary())
        print("User document created successfully for UID: \(user.uid)")
    }
    
    /// Get user data from Firestore
    func getUser(uid: String) async throws -> User? {
        let userRef = db.collection("users").document(uid)
        let document = try await userRef.getDocument()
        
        if document.exists {
            return try document.data(as: User.self)
        }
        return nil
    }
    
    /// Update user data in Firestore
    func updateUser(uid: String, data: [String: Any]) async throws {
        let userRef = db.collection("users").document(uid)
        var updateData = data
        updateData["updatedAt"] = Timestamp(date: Date())
        
        try await userRef.updateData(updateData)
        print("User document updated successfully for UID: \(uid)")
    }
    
    /// Update biometric settings
    func updateBiometricSettings(uid: String, enabled: Bool, hasCompletedOnboarding: Bool) async throws {
        let updateData: [String: Any] = [
            "biometricEnabled": enabled,
            "hasCompletedOnboarding": hasCompletedOnboarding,
            "updatedAt": Timestamp(date: Date())
        ]
        try await updateUser(uid: uid, data: updateData)
    }
    
    /// Check if user exists in Firestore
    func userExists(uid: String) async throws -> Bool {
        let userRef = db.collection("users").document(uid)
        let document = try await userRef.getDocument()
        return document.exists
    }
    
    /// Delete user data from Firestore
    func deleteUser(uid: String) async throws {
        let userRef = db.collection("users").document(uid)
        try await userRef.delete()
        print("User document deleted successfully for UID: \(uid)")
    }
} 