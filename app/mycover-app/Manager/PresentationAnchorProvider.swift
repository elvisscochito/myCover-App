//
//  PresentationAnchorProvider.swift
//  mycover-app
//
//  Created by Joel Vargas on 21/12/24.
//

import AuthenticationServices
import UIKit

class PresentationAnchorProvider: NSObject, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first { $0.isKeyWindow } ?? UIWindow()
    }
}

