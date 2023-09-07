//
//  SizePreferenceKey.swift
//  ChatGPT
//
//  Created by TouKir on 03/09/2023.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
  typealias Value = CGSize
  static var defaultValue: Value = .zero

  static func reduce(value _: inout Value, nextValue: () -> Value) {
    _ = nextValue()
  }
}
