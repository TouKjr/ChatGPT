//
//  ScrollViewSizeTests.swift
//  ChatGPT
//
//  Created by TouKir on 03/09/2023.
//

import SwiftUI

struct ContentView: View {
  let spaceName = "scroll"

  @State var scrollViewSize: CGSize = .zero

  var body: some View {
    ScrollView {
      ChildSizeReader(size: $scrollViewSize) {
        VStack {
          ForEach(0..<100) { i in
            Text("\(i)")
          }
        }
        .background(
          GeometryReader { proxy in
            Color.clear.preference(
              key: ViewOffsetKey.self,
              value: -1 * proxy.frame(in: .named(spaceName)).origin.y
            )
          }
        )
        .onPreferenceChange(
          ViewOffsetKey.self,
          perform: { value in
            print("offset: \(value)") // offset: 1270.3333333333333 when User has reached the bottom
            print("height: \(scrollViewSize.height)") // height: 2033.3333333333333

            if value == scrollViewSize.height {
              print("User has reached the bottom of the ScrollView.")
            } else {
              print("not reached.")
            }
          }
        )
      }
    }
    .coordinateSpace(name: spaceName)
    .onChange(
      of: scrollViewSize,
      perform: { value in
        print(value)
      }
    )
  }
}

