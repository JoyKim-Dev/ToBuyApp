//
//  Observable.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/11/24.
//

import Foundation

class Observable<T> {
    
    var closure: ((T) -> Void)?
 
    var value: T {
        didSet {
            print("didset")
            closure?(value)
        }
    }
    
    init(_ value: T) {
        print("init")
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        print(#function)
        closure(value)
        self.closure = closure
    }
}
