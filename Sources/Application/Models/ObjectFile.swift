//
//  ObjectFile.swift
//  ARServer
//
//  Created by Denis Zubkov on 11.02.2020.
//

import Foundation
import LoggerAPI
import SwiftKuery
import SwiftKueryORM

struct ObjectFile: Codable {
    var filename: String?
    var fileData: Data?
    var thumbnailData: Data?
}
