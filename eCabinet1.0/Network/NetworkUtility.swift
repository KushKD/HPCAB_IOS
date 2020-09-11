//
//  NetworkUtility.swift
//  eCabinet
//
//  Created by HP-DIT on 9/7/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation

class NetworkUtility  {
    
    var appUtilities = UtilitiesApp()
    
    public func getData(GetDataPojo object : GetPojo , completion: @escaping (ResponseObject?) -> () )
    {
        
        var responseObject = ResponseObject()
        let url = URL(string: appUtilities.createUrl(GetDataPojo: object))!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       // request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

        print(object.taskType!)
        let task = URLSession.shared.dataTask(with: request , completionHandler : { data, response, error in
            if let error = error {
                // handle the transport error
                completion(nil)
                
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // handle the server error
                completion(nil)
                
                return
            }
            responseObject.successFailure = "SUCCESS"
            responseObject.respnse = data
            responseObject.responseCode = response.statusCode
            responseObject.dept_id = ""
            completion(responseObject)
           

        })
        task.resume()
    }
    
    
    public func getDataDialog(GetDataPojo object : GetPojo , completion: @escaping (ResponseObject?) -> () )
       {
           
           var responseObject = ResponseObject()
         
           let url = URL(string: appUtilities.createUrl(GetDataPojo: object))!
           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          // request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            DispatchQueue.main.async(execute: {
                ViewControllerUtils().showActivityIndicator(uiView: object.activityIndicator!)
            }) 
           print(object.taskType!)
           let task = URLSession.shared.dataTask(with: request , completionHandler : { data, response, error in
               if let error = error {
                   // handle the transport error
                   
                DispatchQueue.main.async(execute: {
                               ViewControllerUtils().hideActivityIndicator(uiView: object.activityIndicator!)
                           })
                completion(nil)
                   return
               }
               guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                   // handle the server error
                  
                DispatchQueue.main.async(execute: {
                                              ViewControllerUtils().hideActivityIndicator(uiView: object.activityIndicator!)
                                          })
                   return
                 completion(nil)
               }
               responseObject.successFailure = "SUCCESS"
               responseObject.respnse = data
               responseObject.responseCode = response.statusCode
               responseObject.dept_id = ""
             
          DispatchQueue.main.async(execute: {
                                        ViewControllerUtils().hideActivityIndicator(uiView: object.activityIndicator!)
                                    })
              completion(responseObject)
              

           })
           task.resume()
         
       }
    
   
    
}



