import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

class StoreKitManager: ObservableObject {
    @Published var storeProducts: [Product] = []
    @Published var purchasedCourses: [Product] = []

    var updateListenerTask: Task<Void, Error>? = nil
    var logHandler: ((String) -> Void)? // Log handler para capturar mensajes

    private let productDict: [String: String]

    init() {
        if let plistPath = Bundle.main.path(forResource: "ProductList", ofType: "plist"),
           let plist = FileManager.default.contents(atPath: plistPath) {
            productDict = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String]) ?? [:]
        } else {
            productDict = [:]
        }

        log("Inicializando StoreKitManager con productos: \(productDict)")
        updateListenerTask = listenForTransactions()

        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    self.log("Transacción actualizada: \(transaction.productID)")
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    self.log("Error en la transacción: \(error.localizedDescription)")
                }
            }
        }
    }

    @MainActor
    func requestProducts() async {
        do {
            storeProducts = try await Product.products(for: productDict.values)
            log("Productos obtenidos: \(storeProducts.map { $0.id })")
        } catch {
            log("Error al obtener productos: \(error.localizedDescription)")
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let signedType):
            return signedType
        case .unverified:
            throw StoreError.failedVerification
        }
    }

    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedCourses: [Product] = []

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if let course = storeProducts.first(where: { $0.id == transaction.productID }) {
                    purchasedCourses.append(course)
                    log("Producto comprado: \(course.id)")
                }
            } catch {
                log("Error verificando transacción: \(error.localizedDescription)")
            }
        }

        self.purchasedCourses = purchasedCourses
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        log("Intentando comprar el producto: \(product.id)")
        let result = try await product.purchase()

        switch result {
        case .success(let verificationResult):
            let transaction = try checkVerified(verificationResult)
            log("Compra exitosa para producto: \(transaction.productID)")
            await updateCustomerProductStatus()
            await transaction.finish()
            return transaction
        case .userCancelled:
            log("Compra cancelada por el usuario para producto: \(product.id)")
            return nil
        case .pending:
            log("Compra pendiente para producto: \(product.id)")
            return nil
        default:
            log("Resultado desconocido en compra para producto: \(product.id)")
            return nil
        }
    }

    func log(_ message: String) {
        print("[StoreKitManager] \(message)")
        logHandler?(message)
    }
}
