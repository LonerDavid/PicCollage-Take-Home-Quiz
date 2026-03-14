//
//  DefaultStickers.swift
//  PicCollage Take-Home Quiz
//
//  Created by Haruaki on 2026/3/13.
//

import SwiftUI

struct DefaultSticker {
  var SystemName: String
  var DefaultColor: Color
  var DefaultSize: CGSize
  var position: CGPoint = .zero
}

let defaultStickers: [DefaultSticker] = [
  DefaultSticker(SystemName: "star.fill", DefaultColor: .blue, DefaultSize: CGSize(width: 100, height: 100)),
  DefaultSticker(SystemName: "heart.fill", DefaultColor: .red, DefaultSize: CGSize(width: 100, height: 100)),
  DefaultSticker(SystemName: "moon.fill", DefaultColor: .indigo, DefaultSize: CGSize(width: 100, height: 100)),
  DefaultSticker(SystemName: "sun.max.fill", DefaultColor: .yellow, DefaultSize: CGSize(width: 100, height: 100)),
  DefaultSticker(SystemName: "flame.fill", DefaultColor: .red, DefaultSize: CGSize(width: 100, height: 100)),
  DefaultSticker(SystemName: "bolt.fill", DefaultColor: .yellow, DefaultSize: CGSize(width: 100, height: 100)),
  DefaultSticker(SystemName: "leaf.fill", DefaultColor: .green, DefaultSize: CGSize(width: 100, height: 100)),
  DefaultSticker(SystemName: "drop.fill", DefaultColor: .blue, DefaultSize: CGSize(width: 100, height: 100)),
  DefaultSticker(SystemName: "sparkles", DefaultColor: .cyan, DefaultSize: CGSize(width: 100, height: 100)),
  DefaultSticker(SystemName: "camera.fill", DefaultColor: .gray, DefaultSize: CGSize(width: 100, height: 100)),
]
