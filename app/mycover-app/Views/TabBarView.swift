import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var ticketsVM: TicketViewModel

    var body: some View {
        TabView {
            // Primera pestaña: Home
            NavigationView {
                Home()
                    .navigationTitle("Home")
                    .environmentObject(ticketsVM)
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            
            /*NavigationView{
                MapView()
                    .navigationTitle("Map")
            }
            .tabItem {
                Image(systemName: "map.fill")
                Text("Map")
            }*/
            
            // Third tab: WalletView
            NavigationView {
                WalletView()
                    .navigationTitle("Wallet")
                    .environmentObject(ticketsVM)
            }
            .tabItem {
                Image(systemName: "ticket.fill")
                Text("My Tickets")
            }
            
            // Tercera pestaña: Profile
            NavigationView {
                ProfileView()
                    .navigationTitle("Profile")
                    .environmentObject(ticketsVM)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .accentColor(.blue) // Cambia el color de acento de los íconos seleccionados
    }
}

#Preview {
    TabBarView()
}
