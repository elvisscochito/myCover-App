import UIKit
import Stripe

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configura tu clave pública
        STPAPIClient.shared.publishableKey = "pk_test_51QaX3sIRGpN5HrMKKEFn9DQAxrhStncQHbz7kCRwzJZTe1DAXguhM5fPm7SJtXDt0QJQr4BxSlpOZdrj29fXKYQD00QlbjHW7l" // Usa tu propia publishableKey de Stripe
        return true
    }
}
