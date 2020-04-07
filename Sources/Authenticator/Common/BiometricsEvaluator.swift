//
//  BiometricsEvaluator.swift
//  Authenticator
//
//  Created by Daniel Mandea on 05/04/2020.
//  Copyright © 2020 DanielMandea. All rights reserved.
//

import Foundation
import LocalAuthentication

class BiometricsEvaluator: Evaluator {
    
    // MARK: - Private
    
    private let context: LAContext
    private let reason: String
    
    // MARK: - Init
    
    init(context: LAContext, reason: String) {
        self.context = context
        self.reason = reason
    }
    
    // MARK: - Evaluation
    
    func evaluate(completion: @escaping (AuthenticationState) -> Void) {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (succes, authError) in
                if succes { completion(.loggedin(type: .biometrics)) } else if let code = (authError as NSError?)?.code {
                    let status = BiometricsEvaluator.evaluateAuthenticationPolicyMessageForLA(errorCode: code)
                    completion(.failed(message: status))
                } else {
                    completion(.failed(message: "Unknown Error"))
                }
            }
        } else if let code = error?.code {
            let status = BiometricsEvaluator.evaluatePolicyFailure(errorCode: code)
            completion(.failed(message: status))
        } else {
            completion(.failed(message: "Unknown Error"))
        }
    }
    
    static func evaluatePolicyFailure(errorCode: Int) -> String {
          var message = ""
          if #available(iOS 11.0, macOS 10.13, *) {
              switch errorCode {
                  case LAError.biometryNotAvailable.rawValue:
                      message = "Authentication could not start because the device does not support biometric authentication."
                  case LAError.biometryLockout.rawValue:
                      message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                  case LAError.biometryNotEnrolled.rawValue:
                      message = "Authentication could not start because the user has not enrolled in biometric authentication."
                  default:
                      message = "Did not find error code on LAError object"
              }
          } else {
              switch errorCode {
                  case LAError.touchIDLockout.rawValue:
                      message = "Too many failed attempts."
                  case LAError.touchIDNotAvailable.rawValue:
                      message = "TouchID is not available on the device"
                  case LAError.touchIDNotEnrolled.rawValue:
                      message = "TouchID is not enrolled on the device"
                  default:
                      message = "Did not find error code on LAError object"
              }
          }
          return message;
      }
      
      static func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
          var message = ""
          switch errorCode {
          case LAError.authenticationFailed.rawValue:
              message = "The user failed to provide valid credentials"
          case LAError.appCancel.rawValue:
              message = "Authentication was cancelled by application"
          case LAError.invalidContext.rawValue:
              message = "The context is invalid"
          case LAError.notInteractive.rawValue:
              message = "Not interactive"
          case LAError.passcodeNotSet.rawValue:
              message = "Passcode is not set on the device"
          case LAError.systemCancel.rawValue:
              message = "Authentication was cancelled by the system"
          case LAError.userCancel.rawValue:
              message = "The user did cancel"
          case LAError.userFallback.rawValue:
              message = "The user chose to use the fallback"
          default:
              message = evaluatePolicyFailure(errorCode: errorCode)
          }
          
          return message
      }
}
