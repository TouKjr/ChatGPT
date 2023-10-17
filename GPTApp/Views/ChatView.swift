import SwiftUI
import RealmSwift

struct ChatView: View {

    @EnvironmentObject private var vm: ChatViewModel

    var body: some View {
        ZStack{
            VStack {
                ChatWindow()
                HStack{
                    UserTextField()
                    VStack{
                        sendButton
                        clearButton
                    }
                }
                .frame(height: 120)
                .padding(.bottom, 30)
            }
            if vm.answerGeneratingHUD {
                HUDProgressView(placeholder: "GPT is thinking...")
                    .ignoresSafeArea(.all)
            }
        }
        .alert(isPresented: $vm.showAlert) {
            Alert(title: Text("Warning"), message: Text("Clear the history of this chat?"), primaryButton: .destructive(Text("Delete")) {
                vm.clearChat()
            }, secondaryButton: .cancel())
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ChatView()
                .preferredColorScheme(.light)
                .environmentObject(ChatViewModel())
            ChatView()
                .preferredColorScheme(.dark)
                .environmentObject(ChatViewModel())
        }
    }
}

extension ChatView {

    private var sendButton: some View{
        Button {
            vm.endEditing()
            vm.sendMessage()
        } label: {
            ChatButtonTemplate(buttonText: "Send")
        }
    }

    private var clearButton: some View{
        Button {
            vm.endEditing()
            vm.showAlert = true
        } label: {
            ChatButtonTemplate(buttonText: "Clear")
        }
    }

}