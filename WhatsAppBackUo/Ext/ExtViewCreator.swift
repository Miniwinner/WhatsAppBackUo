import Foundation

infix operator -->

func --><T>(left: T,f:(T)-> Void) -> T {
    f(left)
    return left
}
