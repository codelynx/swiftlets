import Foundation

public protocol Swiftlet {
    func handle(_ request: Request) -> Response
}