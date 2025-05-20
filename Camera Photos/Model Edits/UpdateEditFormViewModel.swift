//
//  UpdateEditFormViewModel.swift
//  Camera Photos
//
//  Created by William Liu on 2025-05-18.
//

import UIKit

@Observable
class UpdateEditFormViewModel {
    var name: String = ""
    var data: Data?
    
    var sample: SampleModel?
    var cameraImage: UIImage?
    
    var image: UIImage {
        if let data = data,  // Changed imageData to data
           let convertedImage = UIImage(data: data) {
            return convertedImage
        } else {
            return Constants.placeholder!
        }
    }
    
    init() {
        // Empty initializer for creating new photos
    }
    
    init(sample: SampleModel) {
        self.sample = sample
        self.name = sample.name
        self.data = sample.data
    }
    
    @MainActor
    func clearImage() {
        data = nil
    }
    
    var isUpdating: Bool {
        sample != nil
    }
    
    var isDisabled: Bool {
        name.isEmpty
    }
}
