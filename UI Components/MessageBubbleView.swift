//
//  MessageBubbleView.swift
//  TaskTango
//
//  Created by mac on 16/10/25.
//

import SwiftUI

struct AvatarImageView: View {
    let initial: Character

    var body: some View {
        Text(String(initial))
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .background(Color.gray)
            .clipShape(Circle())
    }
}

struct OnlineStatusIndicator: View {
    var body: some View {
        Circle()
            .fill(Color.green)
            .frame(width: 10, height: 10)
            .overlay(Circle().stroke(Color.white, lineWidth: 1))
    }
}

struct AvatarView: View {
    let sender: User // Assuming 'User' is your sender type

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // Main avatar content
            if let initial = sender.name.first {
                AvatarImageView(initial: initial)
            }

            // Online status indicator
            if sender.isOnline {
                OnlineStatusIndicator()
            }
        }
    }
}

// Make sure your User struct exists



struct MessageContentView: View {
    let message: Message
    let isIncoming: Bool

    var body: some View {
        VStack(alignment: isIncoming ? .leading : .trailing) {
            Text(message.messageText)
                .padding(10)
                .background(isIncoming ? Color.secondary.opacity(0.2) : Color.blue)
                .foregroundColor(isIncoming ? .primary : .white)
                .cornerRadius(15)
                .fixedSize(horizontal: false, vertical: true)
            
            // Optional: Timestamp
            Text(message.timestamp, style: .time)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

struct MessageBubbleView: View {
    let message: Message
    let isIncoming: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            // Align content correctly
            if isIncoming {
                // To display an avatar, you would need to fetch the sender's user data first
                MessageContentView(message: message, isIncoming: isIncoming)
                Spacer() // Pushes incoming message to the left
            } else {
                Spacer() // Pushes outgoing message to the right
                MessageContentView(message: message, isIncoming: isIncoming)
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 5)
    }
}
