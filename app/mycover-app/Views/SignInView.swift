import SwiftUI
import AuthenticationServices


struct AppleSignInIconButton: View {
    var onCompletion: (Result<ASAuthorization, Error>) -> Void
    @State private var signInDelegate: SignInWithAppleDelegate? = nil
    @State private var presentationProvider: PresentationAnchorProvider? = nil

    var body: some View {
        Button(action: {
            startSignInWithAppleFlow()
        }) {
            Image(systemName: "applelogo") // SF Symbol del ícono de Apple
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40) // Ajusta el tamaño del ícono
                .foregroundColor(.white) // Color del ícono
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15) // Cambia el cornerRadius para ajustar la redondez
                        .fill(Color.black) // Color de fondo
                )
        }
    }

    private func startSignInWithAppleFlow() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let signInDelegate = SignInWithAppleDelegate(onCompletion: onCompletion)
        let presentationProvider = PresentationAnchorProvider()
        self.signInDelegate = signInDelegate // Mantener una referencia fuerte
        self.presentationProvider = presentationProvider // Mantener una referencia fuerte

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = signInDelegate
        controller.presentationContextProvider = presentationProvider
        controller.performRequests()
    }

    private class SignInWithAppleDelegate: NSObject, ASAuthorizationControllerDelegate {
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

    private class PresentationAnchorProvider: NSObject, ASAuthorizationControllerPresentationContextProviding {
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.windows.first { $0.isKeyWindow } ?? UIWindow()
        }
    }
}


struct SignInView: View {
    @State private var isSignIn: Bool = false
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject var viewModel: TicketViewModel // Usamos el ViewModel

    var body: some View {
        if isSignIn || viewModel.isLoggedIn {
                TabBarView() // Mostrar la vista principal si el usuario está logueado
        } else {
            VStack(spacing: 20) {
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
                }) {
                    Text("Log In")
                        .padding(10)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Divider()
                    .frame(width: 240, height: 1)
                    .background(Color.gray) // Puedes personalizar el color de la línea
                    .padding(.vertical, 10)
                
                HStack(spacing: 5){
                    
                    
                    Button(action: {
                        print("Facebook")
                    }) {
                        Image("Facebook") // SF Symbol del ícono de Apple
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40) // Ajusta el tamaño del ícono
                            .foregroundColor(.white) // Color del ícono
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 15) // Cambia el cornerRadius para ajustar la redondez
                                    .fill(Color.black) // Color de fondo
                            ) // Fondo circular negro
                    }
                    
                    AppleSignInIconButton { result in
                        switch result {
                        case .success(let authorization):
                            print("Inicio de sesión exitoso: \(authorization)")
                            isSignIn = true
                            
                        case .failure(let error):
                            print("Error al iniciar sesión: \(error.localizedDescription)")
                            alertMessage = "Error al iniciar sesión: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        print("Google")
                    }) {
                        Image("Google") // SF Symbol del ícono de Apple
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40) // Ajusta el tamaño del ícono
                            .foregroundColor(.white) // Color del ícono
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 15) // Cambia el cornerRadius para ajustar la redondez
                                    .fill(Color.black) // Color de fondo
                            ) // Fondo circular negro
                    }
                    
                }
                
               
                
                
            

                
                
            }
            .preferredColorScheme(.dark) // Modo oscuro
            .padding()
            
        }
    }

    func authUser(username: String, password: String) {
        if username.lowercased() == "admin" && password.lowercased() == "root" {
            // Registrar login exitoso en el ViewModel
            viewModel.registerLogin()
            isSignIn = true
        } else {
            // Mostrar error
            alertMessage = "Usuario o contraseña incorrectos."
            showAlert = true
        }
    }
}

#Preview {
    SignInView()
        .environmentObject(TicketViewModel())
    
}
