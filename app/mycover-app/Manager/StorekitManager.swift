import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

@MainActor
class StoreKitManager: ObservableObject {
    @Published var storeProducts: [Product] = []
    @Published var purchasedCourses: [Product] = []
    @Published var purchaseState: PurchaseState = .idle

    enum PurchaseState {
        case idle
        case purchasing
        case purchased
        case failed(error: Error?)
    }

    var updateListenerTask: Task<Void, Error>? = nil

    private let productIdentifiers: Set<String> = ["com.cover.boleto.basico"]

    init() {
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
        return Task { [weak self] in
            guard let self = self else { return }
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProductStatus() // This ensures you're updating on the main actor
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification: \(error.localizedDescription)")
                }
            }
        }
    }

    @MainActor
    func requestProducts() async {
        do {
            storeProducts = try await Product.products(for: productIdentifiers)
        } catch {
            print("Failed to retrieve products: \(error)")
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let signedType):
            return signedType
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
                }
            } catch {
                print("Transaction failed verification")
            }
        }
        self.purchasedCourses = purchasedCourses
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        self.purchaseState = .purchasing
        let result = try await product.purchase()

        switch result {
        case .success(let verificationResult):
            let transaction = try checkVerified(verificationResult)
            await updateCustomerProductStatus()
            await transaction.finish()
            self.purchaseState = .purchased
            return transaction
        case .userCancelled, .pending:
            self.purchaseState = .idle
            return nil
        default:
            self.purchaseState = .failed(error: nil)
            return nil
        }
    }

    func isPurchased(_ product: Product) async throws -> Bool {
        return purchasedCourses.contains(product)
    }
}
