//
//  Constants.swift
//  Camera Photos
//
//  Created by William Liu on 2025-05-18.
//
import UIKit
import SwiftData

@Model
class SampleModel {
   var name: String
   @Attribute(.externalStorage)
   var data: Data?
   var image: UIImage? {
       if let data {
           return UIImage(data: data)
       } else {
           return nil
       }
   }
   
   init(name: String, data: Data? = nil) {
       self.name = name
       self.data = data
   }
}

extension SampleModel {
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: SampleModel.self,
                                            configurations: ModelConfiguration(isStoredInMemoryOnly:true)
                                            )
        let samples: [SampleModel] = [
            .init(name: "Sample 1"),
            .init(name: "Sample 2")
        ]
        
        samples.forEach {
            container.mainContext.insert($0)
        }
        
        return container
    }
    
}


