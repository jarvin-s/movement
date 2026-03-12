import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    var titleColor: Color = Color(.darkGray)
    var textColor: Color = .primary
    var borderColor: Color = Color(.systemGray4)
    var placeholderColor: Color = Color(.placeholderText)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(titleColor)
                .fontWeight(.semibold)
                .font(.footnote)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 14))
                        .foregroundColor(placeholderColor)
                }

                if isSecureField {
                    SecureField("", text: $text)
                        .font(.system(size: 14))
                        .foregroundColor(textColor)
                } else {
                    TextField("", text: $text)
                        .font(.system(size: 14))
                        .foregroundColor(textColor)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email address", placeholder: "")
    }
}
