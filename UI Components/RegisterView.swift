//
//  RegisterView.swift
//  TaskTango
//
//  Created by mac on 09/08/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    
    // NEW: State variable for tracking EULA acceptance
    @State private var acceptedTerms = false
    // NEW: State variable to present the EULA view as a sheet
    @State private var showingEULASheet = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var router: AppViewRouter
    @State private var showAlert = false

    var isEmailFormatValid: Bool {
            return email.isValidEmail()
        }
    
    var body: some View {
        NavigationStack {
            // Use a ZStack to layer the background behind the content
            ZStack {
                // 1. Background Image (Lowest Layer)
                Image("image")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                // 2. Content (Top Layer)
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // LOGO included inside ScrollView with shadow fix
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 350) // Optimized size for SE
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.3), radius: 10) // Fixed shadow
                            .padding(.top, -60)
                            .padding(.bottom, -100)
                        
                        // We recreate the "Form" look using VStack and custom styling
                        Group {
                            TextField("Username", text: $username)
                                .textContentType(.username)
                                
                            TextField("Email", text: $email)
                                .textInputAutocapitalization(.never)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                            
                            if !email.isValidEmail() && !email.isEmpty {
                                            Text("Please enter a valid email address (missing '@').")
                                                .foregroundColor(.red)
                                                .font(.caption)
                                                .padding(.horizontal)
                                        }
                               
                            //SecureField
                            SecureField("Password", text: $password)
                                .textContentType(.newPassword)
                            //SecureField
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textContentType(.newPassword)
                            
                            if let error = authManager.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground).opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Buttons Section
                        VStack(spacing: 15) {
                            
                            // NEW: The EULA Checkbox area
                            VStack(alignment: .leading) {
                                Toggle(isOn: $acceptedTerms) {
                                    HStack {
                                        Text("I agree to the")
                                        Button("Terms of Service") {
                                            showingEULASheet = true
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .background(Color(.systemBackground).opacity(0.8))
                            .cornerRadius(10)


                            Button(action: {
                                Task {
                                    await authManager.register(user: RegisterUser(email: email, password: password, username: username))
                                }
                            }) {
                                if authManager.isRegistering {
                                    ProgressView()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                } else {
                                    Text("Register")
                                        .frame(maxWidth: .infinity, alignment: .center)
                                }
                            }
                            .disabled(!isValidForm || !acceptedTerms)
                            .padding()
                            .background((isValidForm && acceptedTerms) ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("Already have an account? Log in.") {
                                dismiss()
                            }
                            .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color(.systemBackground).opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        Spacer(minLength: 30)
                    }
                }
            }
            .sheet(isPresented: $showingEULASheet) {
                EULAView()
            }
            .navigationTitle("Register")
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }

    private var isValidForm: Bool {
        !username.isEmpty && !email.isEmpty && password.count > 5 && password == confirmPassword && isEmailFormatValid
    }
}


