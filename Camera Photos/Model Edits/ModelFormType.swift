//
//  ModelFormType.swift
//  Camera Photos
//
//  Created by William Liu on 2025-05-19.
//
import SwiftUI

enum ModelFormType: Identifiable, View {
    case new
    case update(SampleModel)
    var id: String {
        String(describing: self)
    }
    var body: some View {
        switch self {
        case .new:
            UpdateEditFormView(vm: UpdateEditFormViewModel())
        case .update(let sample):
            UpdateEditFormView(vm: UpdateEditFormViewModel(sample: sample))
        }
    }
}
