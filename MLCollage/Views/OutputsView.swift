//
//  OutputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI
import UniformTypeIdentifiers

class viewController: UIViewController {
    private let size: CGFloat = 200
    
    private let myView: UIView = {
        let myView = UIView()
        myView.backgroundColor = .systemPurple
        return myView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(myView)
        myView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        myView.center = view.center
    }
}

struct OutputsView: View {
    @Binding var model: OutputModel
    @State var showingExporter = false
    @State var minSize: Double = 100.0
    @State var progress: CGFloat = 0.0

    var body: some View {
        GeometryReader { size in
            NavigationView {
                VStack {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: minSize))],
                            spacing: 20
                        ) {
                            ForEach(model.collages) { collage in
                                ThumbnailView(collage: collage)
                            }
                        }
                    }
                    .navigationTitle("Output")
                    HStack {
                        Text("Preview Size")
                        Button("test") {
                            minSize = minSize - 10
                        }
                        Slider(value: $minSize, in: 30.0...size.size.width / 2.0)
                    }
                    if model.canExport {
                        Button("export") {
                            showingExporter.toggle()
                        }.fileExporter(
                            isPresented: $showingExporter,
                            document: TrainingDataFile(collages: model.collages),
                            defaultFilename: "foo"
                        ) { _ in
                            
                        }
                        .padding()
                    } else {
                        if let progress = model.progress {
                            ProgressView(value: progress)
                        }
                    }
                }.task {
                    model.updateIfNeeded()
                }.onTapGesture {
                    minSize = minSize - 10
                }
                .padding()
            }
        }
    }
}

#Preview {
    //replace this with actual output photos
    @Previewable @State var model = OutputModel.mock
    OutputsView(model: $model)
}
