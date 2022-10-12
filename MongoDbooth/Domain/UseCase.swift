// (C) Diego Freniche 2022 - MIT License

import Foundation


/// A Use Case in our system. It can be anything the user needs to do: Login, Logout, etc. We just have one method (``execute(inParameter:)``) that takes ``InType`` and returns ``OutType``
public protocol UseCase {
    associatedtype InType
    associatedtype OutType

    func execute(inParameter: InType?) async -> OutType
}
