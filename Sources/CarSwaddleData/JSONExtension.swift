//
//  JSONExtension.swift
//  CarSwaddleData
//
//  Created by Kyle Kendall on 11/9/18.
//  Copyright © 2018 CarSwaddle. All rights reserved.
//

import Foundation
import CarSwaddleStore

//extension Dictionary where Key: String, Value: Any {

extension Dictionary where Key == String, Value == Any {
    
    var identifier: String? {
        return self["id"] as? String
    }
    
}
