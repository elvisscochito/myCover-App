import SwiftUI

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
