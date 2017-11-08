//
//  NameSpace.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import Foundation

public struct NameSpace<Base> {
    public let base: Base
    fileprivate init(_ base: Base) {
        self.base = base
    }
}

public protocol NameSpaceCompatible {
    associatedtype CompatibleType
    static var io: NameSpace<CompatibleType>.Type { get set }
    var io: NameSpace<CompatibleType> { get set }
}

extension NameSpaceCompatible {
    public static var io: NameSpace<Self>.Type {
        get {
            return NameSpace<Self>.self
        }
        set {
        }
    }

    public var io: NameSpace<Self> {
        get {
            return NameSpace(self)
        }
        set {
        }
    }
}
