//
//  JSONParsert.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-26.
//  Copyright © 2017 mybeautyxpert. All rights reserved.
//

import UIKit

// MARK: - Network Helpers

typealias CompletionHandler<T> = ((Result<T>) -> ())


public func mainQueue(_ block: @escaping () -> ()) {
    DispatchQueue.main.async(execute: block)
}

public func backgroundQueue(_ block: @escaping () -> ()) {
    DispatchQueue.global(qos: .userInitiated).async {
        block()
    }
}

public func sizeOfImage(at url: URL) -> CGSize {
    var size = CGSize.zero
    if let source = CGImageSourceCreateWithURL(url as CFURL, nil) {
        let options = [kCGImageSourceShouldCache as String: false]
        var properties = CGImageSourceCopyPropertiesAtIndex(source, 0, options as CFDictionary) as! [String: Any]
        let width = properties["PixelWidth"] as! CGFloat
        let height = properties["PixelHeight"] as! CGFloat
        size = CGSize(width: width, height: height)
    }
    return size
}



//function takes a double optional and removes one level of optional-nesting.
func flatten<A>(x: A??) -> A? {
    if let y = x { return y }
    return nil
}

//The custom operator >>>= takes an optional of type A to the left, and a function that takes an A as a parameter and returns an optional B to the right. Basically, it says "apply."
infix operator >>>=
@discardableResult
public func >>>= <A, B> (optional: A?, f: (A) -> B?) -> B? {
    return flatten(x: optional.map(f))
}

//The custom operator => takes an object of type A to the left, and returns an optional B to the right. Basically, it casts from A to B?"
infix operator =>
@discardableResult
public func => <A, B> (a: A, b: B.Type) -> B? {
    return a as? B
}

// we can extract data from JSON structures in a type-safe manner. These are the building blocks of what I'm trying to do here.
extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    
    public func dictionaryKeys() -> [String] {
        return (Array(self.keys) as? [String] ?? [])
    }
    
    public func number(key: Key) -> NSNumber? {
        return self[key] >>>= { $0 as? NSNumber }
    }
    
    public func int(key: Key) -> Int? {
        return self.number(key: key).map { $0.intValue }
    }
    
    public func int(key: Key, or value: Int) -> Int {
        return self.int(key: key) ?? value
    }
    
    public func float(key: Key) -> Float? {
        return self.number(key: key).map { $0.floatValue }
    }
    
    public func float(key: Key, or value: Float) -> Float {
        return self.float(key: key) ?? value
    }
    
    public func double(key: Key) -> Double? {
        return self.number(key: key).map { $0.doubleValue }
    }
    
    public func double(key: Key, or value: Double) -> Double {
        return self.double(key: key) ?? value
    }
    
    public func string(key: Key) -> String? {
        return self[key] >>>= { $0 as? String }
    }
    
    public func string(key: Key, or value: String) -> String {
        return self.string(key: key) ?? value
    }
    
    public func bool(key: Key) -> Bool? {
        return self.number(key: key).map { $0.boolValue }
    }
    
    public func bool(key: Key, or value: Bool) -> Bool {
        return self.bool(key: key) ?? value
    }
    
    public func url(key: Key) -> URL? {
        return self.string(key: key) >>>= { URL(string: $0) }
    }
    
    public func uuid(key: Key) -> UUID? {
        return self.string(key: key) >>>= { UUID(uuidString: $0) }
    }
    
    public func date(key: Key, formatter: DateFormatter) -> Date? {
        return self.string(key: key) >>>= { formatter.date(from: $0) }
    }
    
    func dictionary(key: Key) -> JSONDict? {
        return self[key] >>>= { $0 as? JSONDict }
    }
    
    func dictionary<T: JSONDecodable>(key: Key) -> T? {
        return self.dictionary(key: key) >>>= { $0.flatMap(T.init) }
    }
    
    func array<T>(key: Key) -> [T]? {
        return self[key] >>>= { $0 as? [T] }
    }
    
    func array(key: Key) -> [JSONDict]? {
        return self[key] >>>= { $0 as? [JSONDict] }
    }
    
    func array<T: JSONDecodable>(key: Key) -> [T]? {
        return self.array(key: key) >>>= { $0.flatMap(T.init) }
    }
    
    func category(key: Key) -> BXCategory? {
        return self.string(key: key) >>>= { BXCategory(rawValue: $0) }
    }
}


extension Dictionary {
    
    static func += (left: inout [Key: Value], right: [Key: Value]) {
        for (key, value) in right {
            left[key] = value
        }
    }
}





