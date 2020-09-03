//
//  Singleton.swift
//  MyCloset
//
//  Created by SEONGJUN on 2020/01/31.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import Foundation
import UIKit

class DataManager {
    
    static let shared = DataManager()
    private init() {}
    
    var acc: Dictionary<String, UIImage> = [:]
    var bag: Dictionary<String, UIImage> = [:]
    var bottom: Dictionary<String, UIImage> = [:]
    var cap: Dictionary<String, UIImage> = [:]
    var outer: Dictionary<String, UIImage> = [:]
    var shoes: Dictionary<String, UIImage> = [:]
    var socks: Dictionary<String, UIImage> = [:]
    var top: Dictionary<String, UIImage> = [:]
    
    var selectedImageSet: [String:UIImage] = [:]
    
    var codiImages: [String:UIImage] = [:]
}

