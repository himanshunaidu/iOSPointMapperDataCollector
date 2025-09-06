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
                    bodyText("Global Settings for the app.")

                    heading("UI Settings")
                        
                    HStack {
                        bodyText("Record Button Position")
                        
                        Spacer()
                        
                        Picker("Select Position", selection: $settingsViewModel.recordButtonPosition) {
                            ForEach(RecordButtonPosition.allCases, id: \.self) { position in
                                Text(position.rawValue).tag(position)
                            }
                        }
                    }
                    
                    Spacer()
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
