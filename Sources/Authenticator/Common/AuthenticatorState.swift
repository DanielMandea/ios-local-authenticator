//
//  AuthenticatorState.swift
//  Authenticator
//
//  Created by Daniel Mandea on 05/04/2020.
//  Copyright © 2020 DanielMandea. All rights reserved.
//

import Foundation

/// The available states of being logged in or not.
public enum AuthenticationState {
    case loggedin(type: AuthenticationType = .biometrics)
    case failed(message: String)
}
