import SwiftUI
import SwiftData

// First, define the separate SampleView
struct SampleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var formType: ModelFormType?
    let sample: SampleModel
    
    var body: some View {
        VStack {
            Text(sample.name)
                .font(.largeTitle)
            
            Image(uiImage: getImage(from: sample.image))
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
            
            HStack {
                Button("Edit") {
                    formType = .update(sample)
                }
                .sheet(item: $formType) { formType in
                    formType
                }
                
                Button("Delete", role: .destructive) {
                    modelContext.delete(sample)
                    try? modelContext.save()
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sample View")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func getImage(from optionalImage: UIImage?) -> UIImage {
         // This ensures we always return a valid UIImage, never nil
         return optionalImage ?? UIImage(systemName: "photo") ?? UIImage()
     }
}

// Now your main PhotosListView
struct PhotosListView: View {
    @Query(sort: \SampleModel.name) var samples: [SampleModel]
    @Environment(\.modelContext) private var modelContext
    @State private var formType: ModelFormType?
    
    // Helper function to get a valid image
    private func getImage(from optionalImage: UIImage?) -> UIImage {
        // This ensures we always return a valid UIImage, never nil
        return optionalImage ?? UIImage(systemName: "photo") ?? UIImage()
    }
    
    var body: some View {
        NavigationStack {
            List {
                if samples.isEmpty {
                    ContentUnavailableView("Add your first photo", systemImage: "photo")
                } else {
                    ForEach(samples) { sample in
                        NavigationLink(value: sample) {
                            HStack {
                                Image(uiImage: getImage(from: sample.image))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(12)
                                    .clipped()
                                    .padding(.trailing)
                                Text(sample.name)
                                    .font(.title)
                            }
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                modelContext.delete(sample)
                                try? modelContext.save()
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Picker or Camera")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        formType = .new
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .sheet(item: $formType) { formType in
                        formType
                    }
                }
            }
            .navigationDestination(for: SampleModel.self) { model in
                // Now using the separate SampleView here
                SampleView(sample: model)
            }
        }
    }
}

#Preview {
    PhotosListView()
        .modelContainer(SampleModel.preview)
}

// You also need a preview for SampleView
#Preview {
    NavigationStack {
        let container = SampleModel.preview
        let fetchDescriptor = FetchDescriptor<SampleModel>()
        let sample = try! container.mainContext.fetch(fetchDescriptor)[0]
        return SampleView(sample: sample)
    }
    .modelContainer(SampleModel.preview)
}
