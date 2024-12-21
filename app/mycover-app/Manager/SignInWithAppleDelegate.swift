//
//  SignInWithAppleDelegate.swift
//  mycover-app
//
//  Created by Joel Vargas on 21/12/24.
//

import AuthenticationServices

class SignInWithAppleDelegate: NSObject, ASAuthorizationControllerDelegate {
    let onCompletion: (Result<ASAuthorization, Error>) -> Void

    init(onCompletion: @escaping (Result<ASAuthorization, Error>) -> Void) {
        self.onCompletion = onCompletion
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let email = appleIDCredential.email ?? "No email provided"
            let fullName = appleIDCredential.fullName?.formatted() ?? "No name provided"

            // Guardar en UserDefaults
            UserDefaults.standard.set(email, forKey: "userEmail")
            UserDefaults.standard.set(fullName, forKey: "userFullName")

            print("Email: \(email), Full Name: \(fullName)")
            onCompletion(.success(authorization))
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error during Apple Sign In: \(error.localizedDescription)")
        onCompletion(.failure(error))
    }
}

