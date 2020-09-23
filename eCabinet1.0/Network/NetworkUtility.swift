//
//  NetworkUtility.swift
//  eCabinet
//
//  Created by HP-DIT on 9/7/20.
//  Copyright © 2020 HP-DIT. All rights reserved.
//

import Foundation
import UIKit

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
    
    
    
    
    
    
    public func postDataDialog(PostObject object : PostObject, URL_ url: String ,methord methodName: String, uiview indicator: UIView, completion: @escaping (ResponseObject?) -> () )
          {
              
               var responseObject = ResponseObject()
                //declare parameter as a dictionary which contains string as key and value combination.
                let parameters = ["UserId": object.userid!,
                                      "CabinetMemoID": object.cabinetMemoId! ,
                                      "DeptId": object.deptId!,
                                      "RoleID": object.roleid! ,
                                      "Token": object.token!,
                                      "remarks": object.remarks!,
                                      "OTP": object.otp!,
                                      "MobileNO": object.phone! ] as [String : Any]
                    
                   

                    var x : String = url
                    x.append("/")
                    x.append(methodName)
            
           
                 

                   

                   
            
              let url = URL(string: x)!
             var request = URLRequest(url: url)
               request.httpMethod = "POST"
              request.addValue("application/json", forHTTPHeaderField: "Content-Type")
              request.addValue("application/json", forHTTPHeaderField: "Accept")
            do {
                 request.httpBody = try JSONSerialization.data(withJSONObject: parameters ,options: .prettyPrinted)
                   
             } catch let error {
                 print(error.localizedDescription)
               
             }
               DispatchQueue.main.async(execute: {
                   ViewControllerUtils().showActivityIndicator(uiView: indicator)
               })
            
              let task = URLSession.shared.dataTask(with: request , completionHandler : { data, response, error in
                  if let error = error {
                      // handle the transport error
                      
                   DispatchQueue.main.async(execute: {
                                  ViewControllerUtils().hideActivityIndicator(uiView: indicator)
                              })
                   completion(nil)
                      return
                  }
                var stringdata = ""
                  guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                      // handle the server error
                    if let data = data,  let dataString = String(data: data, encoding: .utf8) {
                                                       print("Response data string:\n \(dataString)")
                        stringdata = dataString
                    }
                   DispatchQueue.main.async(execute: {
                                                 ViewControllerUtils().hideActivityIndicator(uiView: indicator)
                                             })
                      return
                    completion(nil)
                  }
                  responseObject.successFailure = "SUCCESS"
                  responseObject.respnse = data
                  responseObject.responseCode = response.statusCode
                  responseObject.dept_id = ""
                responseObject.stringData = stringdata
                
             DispatchQueue.main.async(execute: {
                                           ViewControllerUtils().hideActivityIndicator(uiView: indicator)
                                       })
                 completion(responseObject)
                 

              })
              task.resume()
            
          }
    
    
    
    
    
    
    
    
    func postDataDialogx(PostObject object : PostObject, URL_ url: String ,methord methodName: String, uiview indicator: UIView, completion: @escaping (ResponseObject?) -> () ) {

        
        
       
      
        var responseObject = ResponseObject()
        
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = ["UserId": object.userid!,
                          "CabinetMemoID": object.cabinetMemoId! ,
                          "DeptId": object.deptId!,
                          "RoleID": object.roleid! ,
                          "Token": object.token!,
                          "remarks": object.remarks!,
                          "OTP": object.otp!,
                          "MobileNO": object.phone! ] as [String : Any]
        
       

        var x : String = url
        x.append("/")
        x.append(methodName)
        let url = URL(string: x)!
        
       
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters ,options: .prettyPrinted)
           
           
        } catch let error {
            print(error.localizedDescription)
          
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        DispatchQueue.main.async(execute: {
//                       ViewControllerUtils().showActivityIndicator(uiView: indicator)
//                   })
      
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
            if let error = error {
                // handle the transport error
                 print("Error took place \(error)")
//             DispatchQueue.main.async(execute: {
//                            ViewControllerUtils().hideActivityIndicator(uiView: indicator)
//                        })
                 responseObject.stringData = "error"
                  responseObject.successFailure = "FALIURE"
                  responseObject.responseCode = 400
             completion(responseObject)
                return
            }
            
            
            
            
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                // handle the server error
               
//             DispatchQueue.main.async(execute: {
//                                           ViewControllerUtils().hideActivityIndicator(uiView: indicator)
//                                       })
                  if let data = data, let dataString = String(data: data, encoding: .utf8) {
                                    print("Response data string:\n \(dataString)")
                                   responseObject.stringData = dataString
                                    responseObject.successFailure = "SUCCESS"
                                    responseObject.responseCode = 200
                                              
                                                //  return
                                }
                 completion(responseObject)
                 return
            }
          
           
              
//                if let error = error {
//                    print("Error took place \(error)")
//                   // completion(nil, error)
//                    return
//                }
//
//
//                if let data = data, let dataString = String(data: data, encoding: .utf8) {
//                    print("Response data string:\n \(dataString)")
//                    // completion(data, error)
//                }
        }

        task.resume()
    }
    
   
    
}



