//
//  File.swift
//  
//
//  Created by Daniel Mandea on 05/04/2020.
//

import Foundation
import LocalAuthentication

public protocol Evaluator {
    func evaluate(completion: @escaping (AuthenticationState) -> Void)
}
