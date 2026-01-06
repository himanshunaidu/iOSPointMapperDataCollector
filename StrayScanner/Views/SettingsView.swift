//
//  InformationView.swift
//  StrayScanner
//
//  Created by Kenneth Blomqvist on 2/28/21.
//  Copyright © 2021 Stray Robots. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    
    let paddingLeftRight: CGFloat = 15
    let paddingTextTop: CGFloat = 10
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            ScrollView {
            VStack(alignment: .leading) {
                Text("Settings").font(.title)
                    .fontWeight(.bold)
                Group {

                    heading("UI Settings")
                        
                    HStack {
                        bodyText("Controls Position")
                        
                        Spacer()
                        
                        Picker("Select Position", selection: $settingsViewModel.controlsPosition) {
                            ForEach(ControlsPosition.allCases, id: \.self) { position in
                                Text(position.rawValue).tag(position)
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                Group {
                    
                    heading("Recording Settings")
                    
                    HStack {
                        bodyText("Enable Mesh Support")
                        
                        Spacer()
                        
                        Toggle("", isOn: $settingsViewModel.meshSupport)
                            .labelsHidden()
                    }
                    
                    /// Warning Label
                    if settingsViewModel.meshSupport {
                        bodyText("""
                            Mesh support increases battery usage.
                            Recording will be limited to 10 seconds.
                            """)
                            .foregroundColor(Color.red)
                            .font(.caption2)
                    }
                }
            }.padding(.all, paddingLeftRight)
            }
            .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
        }
    }
    
    private func heading(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.bold)
            .padding(.top, 20)
    }
    
    private func bodyText(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .multilineTextAlignment(.leading)
            .lineSpacing(1.25)
            .padding(.top, paddingTextTop)
    }
    
    private func link(text: String, destination: String) -> some View {
        Text(text)
            .font(.body)
            .foregroundColor(Color.blue)
            .padding(.top, paddingTextTop)
            .onTapGesture {
                let url = URL.init(string: destination)
                guard let destinationUrl = url else { return }
                UIApplication.shared.open(destinationUrl)
            }
    }
}
