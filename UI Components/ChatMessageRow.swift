//
//  ChatMessageRow.swift
//  TaskTango
//
//  Created by mac on 02/08/25.
//


import SwiftUI

struct ChatMessageRow: View {
    let message: ChatMessage
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            // Spacer to push messages to the right for the current user
            if isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                HStack(spacing: 8) { // WRAP THE USERNAME AND BADGE IN THIS HSTACK
                    // Sender's username
                    Text(message.sender.username)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    // ADD THIS CODE: Pro badge logic
                    if message.sender.isPremium {
                        Image(systemName: "crown.fill") // The yellow crown icon
                            .padding(4)
                            .background(Color.black) // Change the background to black
                            .cornerRadius(4)
                            .foregroundStyle(Color.yellow) 
                    }
                }
                
                // Message content
                Text(message.content)
                    .padding(10)
                    .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .clipShape(ChatBubble(isFromCurrentUser: isCurrentUser))
            }
            
            // Spacer to push messages to the left for other users
            if !isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
