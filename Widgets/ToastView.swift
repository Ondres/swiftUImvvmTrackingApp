import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.green.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding(.top, 60)
            .frame(maxWidth: .infinity)
    }
}
