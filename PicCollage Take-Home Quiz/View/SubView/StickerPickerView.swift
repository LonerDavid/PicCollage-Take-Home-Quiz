//
//  StickerPickerView.swift
//  PicCollage Take-Home Quiz
//
//  Created by GPT on 2026/3/25.
//

import SwiftUI

struct StickerPickerView: View {
  @Binding var placedStickers: [PlacedSticker]

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 12) {
        ForEach(Array(defaultStickers.enumerated()), id: \.offset) { _, sticker in
          Button {
            var stickerWithPosition = sticker
            stickerWithPosition.position = CGPoint(x: 0, y: 0)
            placedStickers.append(PlacedSticker(sticker: stickerWithPosition))
          } label: {
            Image(systemName: sticker.SystemName)
              .resizable()
              .scaledToFit()
              .frame(width: 50, height: 50)
              .padding(8)
              .foregroundStyle(sticker.DefaultColor)
              .background(Color("DefaultSecondaryBackgroundColor"))
              .clipShape(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
              )
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.horizontal)
    }
  }
}

#Preview {
  StickerPickerView(placedStickers: .constant([]))
}

