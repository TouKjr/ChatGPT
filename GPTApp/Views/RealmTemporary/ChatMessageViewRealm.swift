import SwiftUI
import RealmSwift

struct ChatMessageViewRealm: View {
    
    @ObservedRealmObject var chatMessageRealmGroup: ChatMessageRealmGroup
    
    /// The button to be displayed on the top left.
    var leadingBarButton: AnyView?
    
    var body: some View {
        NavigationView {
            VStack {
                // The list shows the items in the realm.
                List {
                    ForEach(chatMessageRealmGroup.chatMessagesRealm) { message in
                        ChatMessageRow(chatMessageRealm: message)
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Items", displayMode: .large)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct ChatMessageViewRealm_Previews: PreviewProvider {
    static var previews: some View {
        let realm = ChatMessageRealmGroup.previewRealm
        let chatMessageRealmGroup = realm.objects(ChatMessageRealmGroup.self)
        ChatMessageViewRealm(chatMessageRealmGroup: chatMessageRealmGroup.first!)
    }
}
