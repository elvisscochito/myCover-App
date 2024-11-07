//
//  SignIn.swift
//  mycover-app
//
//  Created by Joel Vargas on 06/11/24.
//

import SwiftUI

struct SignInView: View {
    @State private var isSignIn: Bool = false
    @State private var username = ""
    @State private var password = ""
    // @State private var error: Error?
    
    var body: some View {
        if isSignIn {
            TabBarView()
        } else {
            VStack {
                Text("Sign In")
                    .font(.title.bold())
                    .padding()
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(red: 27 / 255, green: 27 / 255, blue: 27 / 255))
                    .cornerRadius(10)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(red: 27 / 255, green: 27 / 255, blue: 27 / 255))
                    .cornerRadius(10)
                
                Button(action: {
                    authUser(username: username, password: password)
                }){
                    Text("Log In")
                        .padding(10)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    
                }
            }.preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/) // por si acaso xd (despues lo arreglamos)
        }
    }
    
    func authUser(username: String, password: String) {
        if username.lowercased() == "admin" && password.lowercased() == "root" {
            isSignIn = true
        } else {
            isSignIn = false
        }
        
    }
}

#Preview {
    SignInView()
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}
