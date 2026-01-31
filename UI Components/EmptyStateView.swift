//
//  EmptyStateView.swift
//  TaskTango
//
//  Created by mac on 27/08/25.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let systemImageName: String
    let message: String
    let retryAction: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImageName)
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            if let retryAction = retryAction {
                Button("Retry", action: retryAction)
                    .buttonStyle(.bordered)
                    .padding(.top)
            }
        }
        .padding()
    }
}
