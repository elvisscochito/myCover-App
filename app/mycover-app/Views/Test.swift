import SwiftUI

struct Test: View {
    @StateObject private var ticketViewModel = TicketViewModel()

    var body: some View {
        VStack {
            Text("Hello, World!")
            Button("Go to Home") {
                ticketViewModel.postTickets(
                    description: "Cumple de Benji",
                    staffName: "Testing from xcode"
                )
            }
            .padding()
            
            if let isSuccessful = ticketViewModel.isRequestSuccessful {
                Text(isSuccessful ? "Request was successful! 🎉" : "Request failed 😞")
                    .foregroundColor(isSuccessful ? .green : .red)
            }
        }
        .padding()
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}

#Preview {
    Test()
}
