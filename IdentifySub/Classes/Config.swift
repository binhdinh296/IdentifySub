//
//  Config.swift
//  ISubscriber
//
//  Created by NamViet on 8/2/18.
//

import Foundation


public struct CONFIG {
    static let  secret = "nvGa%!"
    static let  url = "http://nvgate.vn/analytics/clientApp?utm_source=vtvapp&utm_medium=detect&checksum="
    static let  urlDetect = "http://nvgate.vn/analytics/receiveClientDetect"
    static let  userAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_4_1 like Mac OS X) AppleWebKit/604.1.34 (KHTML, like Gecko) CriOS/67.0.3396.87 Mobile/15G77 Safari/604.1"
}

public struct PARAM {
    static let utmSource = "utm_source"
    static let utmMedium = "utm_medium"
    static let checksum = "checksum"
    static let mobile = "mobile"
    static let cookie = "cookie"
    static let userAgent = "User-Agent"
}
struct VALUE {
    static let utmSource = "vtvapp"
    static let utmMedium = "detect"
    static let checksum = "checksum"
    static let utmMedium2 = "clientdetect"
}
