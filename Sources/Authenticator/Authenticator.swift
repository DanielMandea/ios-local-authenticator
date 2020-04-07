//
//  Authenticator.swift
//  Authenticator
//
//  Created by Daniel Mandea on 05/04/2020.
//  Copyright © 2020 DanielMandea. All rights reserved.
//
import Foundation
import UIKit
import LocalAuthentication

private let keyEnabled = "Autrhenticator.enabled"
private let keyReason = "Autrhenticator.reason"

public class Authenticator {
    
    // MARK: - Private 
    
    private static let context = LAContext()
    
    // MARK: - Public
    
    public static var enabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: keyEnabled) 
        }
        set {
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                UserDefaults.standard.set(newValue, forKey: keyEnabled)
            } else {
                UserDefaults.standard.set(false, forKey: keyEnabled)
            }
        }
    }
    
    public static var reason: String {
        get {
            UserDefaults.standard.string(forKey: keyReason) ?? "Use for local authentication"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyReason)
        }
    }
    
    // MARK: Init
    
    private init() {}
    
    // MARKK: - Evaluate
    
    public static func evaluate(completion: @escaping (AuthenticationState) -> Void) {
        BiometricsEvaluator(context: context, reason: reason).evaluate(completion: completion)
    }
}
