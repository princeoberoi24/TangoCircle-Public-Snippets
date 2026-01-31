//
//  LoginView.swift
//  TaskTango
//
//  Created by mac on 09/08/25.
//


import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @State private var showForgotPassword: Bool = false
    @State private var emailForReset: String = ""
    
    init(authManager: AuthManager, router: AppViewRouter) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(authManager: authManager, router: router))
    }
    
    var body: some View {
        ZStack {
            Image("image")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding(.bottom, -60)
                    .padding(.top, -90)

                Text("Welcome Back")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                VStack(spacing: 15) {
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                    
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            showForgotPassword.toggle()
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                    }
                    .padding(.top, -10)
                    
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button("Login") {
                            viewModel.login()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                    }
                    
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Don't have an account? Sign up.")
                    }
                    .padding(.top)
                }
                .padding()
                .background(Color(.systemBackground).opacity(0.85))
                .cornerRadius(12)
                .padding()
                
                Spacer()
            }
        }
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView(
                isPresented: $showForgotPassword,
                emailForReset: $emailForReset,
                viewModel: viewModel
            )
        }
        .alert("Password Reset", isPresented: $viewModel.showResetAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.resetAlertMessage)
        }
    }
}
