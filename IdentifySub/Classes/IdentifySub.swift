//
//  Services.swift
//  ISubscriber
//
//  Created by NamViet on 8/2/18.
//

import UIKit

public class IdentifySub: NSObject {
    
    public static let shared = IdentifySub()
    var step : Int = 1
    var cookie :String = "msisdn"
    
    public func detectSubscriber(){
        //Step 1
        let checksum = MySDKCrypto.md5Hash(VALUE.utmSource + CONFIG.secret + VALUE.utmMedium)
        let urlStep1 = CONFIG.url + checksum!
        requestUrl(link: urlStep1,isPost: false,postString: nil)
    }
    
    /*    CheckSum MD5  */
    func requestUrl(link:String ,isPost:Bool,postString:String?){
        let myUrl = NSURL(string: link);
        let cookies=HTTPCookieStorage.shared.cookies(for: myUrl! as URL)
        let headers=HTTPCookie.requestHeaderFields(with: cookies!)
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.allHTTPHeaderFields=headers
        request.setValue(CONFIG.userAgent, forHTTPHeaderField: PARAM.userAgent)
        request.httpMethod = isPost ? "POST" : "GET"
        if isPost {
            request.httpBody = postString?.data(using: .utf8)
        }
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil{
                print("error=\(String(describing: error))")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response!.url!, mainDocumentURL: nil)
                
                for cookie in cookies {
                    var cookieProperties = [HTTPCookiePropertyKey: AnyObject]()
                    cookieProperties[HTTPCookiePropertyKey.name] = cookie.name as AnyObject
                    cookieProperties[HTTPCookiePropertyKey.value] = cookie.value as AnyObject
                    cookieProperties[HTTPCookiePropertyKey.domain] = cookie.domain as AnyObject
                    cookieProperties[HTTPCookiePropertyKey.path] = cookie.path as AnyObject
                    cookieProperties[HTTPCookiePropertyKey.version] = NSNumber(value: cookie.version)
                    cookieProperties[HTTPCookiePropertyKey.expires] = NSDate().addingTimeInterval(31536000)
                    let newCookie = HTTPCookie(properties: cookieProperties)
                    HTTPCookieStorage.shared.setCookie(newCookie!)
                    if cookie.name == self.cookie {
                        let stringCookie = cookies.map(String.init).joined(separator: ", ")
                        let urlSource = PARAM.utmSource  + "=" + VALUE.utmSource + "&"
                        let urlDetect = PARAM.utmMedium + "=" + VALUE.utmMedium2 + "&"
                        let mobile = PARAM.mobile + "=" + cookie.value + "&"
                        let checksum = PARAM.checksum + "=" + MySDKCrypto.md5Hash(VALUE.utmSource + CONFIG.secret + VALUE.utmMedium2) + "&"
                        let sum = urlSource + urlDetect + mobile + checksum + PARAM.cookie + "=" + stringCookie
                        self.requestUrl(link: CONFIG.urlDetect, isPost: true, postString: sum)
                        break
                    }
                    //print("name: \(cookie.name) value: \(cookie.value)")
                }
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("responseString = \(String(describing: responseString))")
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    //print(convertedJsonIntoDict)
                    if self.step == 1 {
                        //Step 2
                        self.step = self.step + 1
                        let errorString = convertedJsonIntoDict["error"] as? String
                        let dic = convertedJsonIntoDict["data"] as? NSDictionary
                        let urlStep2 = dic?.value(forKey: "detect_url") as! String
                        self.cookie = dic?.value(forKey: PARAM.cookie) as! String
                        if errorString == "DETECT_URL" {
                            self.requestUrl(link: urlStep2,isPost: false,postString: nil)
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}
