//
//  Services.swift
//  ISubscriber
//
//  Created by NamViet on 8/2/18.
//

import UIKit

class Services: NSObject {
    static let shared = Services()
    var step : Int = 1
    var mobile:String = "0987093265"
    func detectSubscriber(){
        //Step 1 checksum=md5(utm_source+SECRET+utm_medium);
        let checksum = MySDKCrypto.md5Hash(VALUE.utmSource + CONFIG.secret + VALUE.utmMedium)
        let urlStep1 = "http://nvgate.vn/analytics/clientApp?utm_source=vtvapp&utm_medium=detect&checksum=\(String(describing: checksum))"
        
        requestUrl(link: urlStep1)
    }
    /*    CheckSum MD5  */
    func requestUrl(link:String){
        let myUrl = NSURL(string: link);
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            if error != nil{
                print("error=\(String(describing: error))")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    // Get value by key
                    if self.step == 1 {
                        //Step 2
                        self.step = self.step + 1
                        let errorString = convertedJsonIntoDict["error"] as? String
                        let dic = convertedJsonIntoDict["data"] as? NSDictionary
                        let urlStep2 = dic?.value(forKey: "detect_url") as! String
                        if errorString == "DETECT_URL" {
                            self.requestUrl(link: urlStep2)
                        }
                    }else{
                        // Step 3
                        let checksum = MySDKCrypto.md5Hash(VALUE.utmSource + CONFIG.secret + VALUE.utmMedium2)
                        let urlStep3 = "http://nvgate.vn/analytics/receiveClientDetect?utm_source=vtvapp&utm_medium=clientdetect&mobile=\(self.mobile)&checksum=\(String(describing: checksum))"
                        self.requestUrl(link: urlStep3)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
}
