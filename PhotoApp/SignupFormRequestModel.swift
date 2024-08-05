//
//  SignupFormRequestModel.swift
//  PhotoApp
//
//  Created by Tyler on 2024-08-03.
//  Copyright © 2024 Sergey Kargopolov. All rights reserved.
//

import Foundation

struct SignupFormRequestModel: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}
