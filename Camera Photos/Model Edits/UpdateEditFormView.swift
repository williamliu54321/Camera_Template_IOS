//
//  UpdateFormView.swift
//  Camera Photos
//
//  Created by William Liu on 2025-05-18.
//

import SwiftUI
import SwiftData
import PhotosUI

struct UpdateEditFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State var vm: UpdateEditFormViewModel
    @State private var imagePicker = ImagePicker()
    @State var showCamera = false
    @State var cameraError: CameraPermission.CameraError?
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $vm.name)
                VStack {
                    if vm.data != nil {
                        Button("Clear image") {
                            vm.clearImage()
                        }
                        .buttonStyle(.bordered)
                    }
                    HStack {
                        Button("Camera", systemImage: "camera") {
                            if let error = CameraPermission.checkPermissions() {
                                cameraError = error
                            }
                            else {
                                showCamera.toggle()
                            }
                        }
                        .alert(isPresented: .constant(cameraError != nil), error: cameraError) { _ in
                            Button("OK") {
                                cameraError = nil
                            }
                        } message: { error in
                            Text(error.recoverySuggestion ?? "Try again later")
                        }
                        .sheet(isPresented: $showCamera) {
                            UIKitCamera(selectedImage: $vm.cameraImage)
                                .ignoresSafeArea()
                        }

                        PhotosPicker(selection: $imagePicker.imageSelection) {
                            Label("Photos", systemImage: "photo")
                        }
                    }
                    .foregroundStyle(.white)
                    .buttonStyle(.borderedProminent)
                    
                    Image(uiImage: vm.image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
            }
            .onAppear {
                imagePicker.setup(vm)
            }
            .onChange(of: vm.cameraImage) {
                if let image = vm.cameraImage {
                    vm.data = image.jpegData(compressionQuality: 0.8)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Handle both updating and adding
                        if vm.isUpdating {
                            if let sample = vm.sample {
                                sample.data = vm.image != Constants.placeholder
                                    ? vm.image.jpegData(compressionQuality: 0.8)
                                    : nil
                                sample.name = vm.name
                            }
                        } else {
                            // This code will run when adding a new item
                            let newSample = SampleModel(name: vm.name)
                            newSample.data = vm.image != Constants.placeholder
                                ? vm.image.jpegData(compressionQuality: 0.8)
                                : nil
                            modelContext.insert(newSample)
                        }
                        dismiss()
                    } label: {
                        Text(vm.isUpdating ? "Update" : "Add")
                    }
                    .disabled(vm.isDisabled)
                }
            }
        }
    }
}
    
#Preview {
    UpdateEditFormView(vm: UpdateEditFormViewModel())
}
