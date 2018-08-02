//
//  Config.swift
//  ISubscriber
//
//  Created by NamViet on 8/2/18.
//

import Foundation


public struct CONFIG {
    static let mailURL = "http://nvgate.vn/analytics/clientApp?utm_source=vtvapp&utm_medium=detect&checksum=XXXXXX"
    static let  secret = "nvGa%!"
}

public struct PARAM {
    static let utmSource = "utm_source"
    static let utmMedium = "utm_medium"
    static let checksum = "checksum"
    static let mobile = "mobile"
}
struct VALUE {
    static let utmSource = "vtvapp"
    static let utmMedium = "detect"
    static let checksum = "checksum"
    static let utmMedium2 = "clientdetect"
}
