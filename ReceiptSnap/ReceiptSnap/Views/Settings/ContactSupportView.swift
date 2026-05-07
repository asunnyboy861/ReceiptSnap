import SwiftUI

struct ContactSupportView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var topic = "General"
    @State private var message = ""
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss

    private let topics = ["General", "Bug Report", "Feature Request", "Subscription Issue", "Account Issue"]

    var body: some View {
        Form {
            Section("Topic") {
                Picker("Topic", selection: $topic) {
                    ForEach(topics, id: \.self) { t in
                        Text(t).tag(t)
                    }
                }
            }

            Section("Contact Info") {
                TextField("Name (optional)", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
            }

            Section("Message") {
                TextEditor(text: $message)
                    .frame(minHeight: 120)
            }

            Section {
                Button(action: submitFeedback) {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(email.isEmpty || message.isEmpty || isSubmitting)
            }
        }
        .navigationTitle("Contact Support")
        .alert("Feedback", isPresented: $showAlert) {
            Button("OK") {
                if alertMessage.contains("success") {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }

    private func submitFeedback() {
        isSubmitting = true

        let feedbackURL = "https://feedback-board.iocompile67692.workers.dev"
        guard let url = URL(string: feedbackURL) else {
            alertMessage = "Invalid feedback URL"
            showAlert = true
            isSubmitting = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "topic": topic,
            "name": name,
            "email": email,
            "message": message,
            "app": "ReceiptSnap"
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                if let error = error {
                    alertMessage = "Failed to send: \(error.localizedDescription)"
                } else {
                    alertMessage = "Message sent successfully! We'll get back to you soon."
                }
                showAlert = true
            }
        }.resume()
    }
}
