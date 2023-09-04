//
//  ViewOffsetKey.swift
//  ChatGPT
//
//  Created by TouKir on 03/09/2023.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
  typealias Value = CGFloat
  static var defaultValue = CGFloat.zero
  static func reduce(value: inout Value, nextValue: () -> Value) {
    value += nextValue()
  }
}
