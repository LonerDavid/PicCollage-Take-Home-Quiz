//
//  MainView.swift
//  PicCollage Take-Home Quiz
//
//  Created by Haruaki on 2026/3/13.
//

import SwiftUI

struct MainView: View {
  @State private var placedStickers: [PlacedSticker] = []
  @State private var selectedStickerID: UUID? = nil

  private let stickerMinScale: CGFloat = 0.2
  private let stickerMaxScale: CGFloat = 5.0

  var body:some View {
    VStack {
      CanvasView(
        placedStickers: $placedStickers,
        selectedStickerID: $selectedStickerID,
        selectedStickerColorBinding: selectedStickerColorBinding,
        stickerMinScale: stickerMinScale,
        stickerMaxScale: stickerMaxScale
      )

      TitlesView(
        placedStickers: $placedStickers,
        selectedStickerID: $selectedStickerID
      )

      StickerPickerView(
        placedStickers: $placedStickers
      )
    }
    .background(Color("DefaultBackgroundColor"))
  }
}

extension MainView {
  private var selectedStickerColorBinding: Binding<Color> {
    Binding(
      get: {
        guard let id = selectedStickerID,
              let idx = placedStickers.firstIndex(where: { $0.id == id }) else {
          return .gray
        }
        let sticker = placedStickers[idx].sticker
        return sticker.selectedColor ?? sticker.DefaultColor
      },
      set: { newColor in
        guard let id = selectedStickerID,
              let idx = placedStickers.firstIndex(where: { $0.id == id }) else { return }
        placedStickers[idx].sticker.selectedColor = newColor
      }
    )
  }
}

#Preview {
  MainView()
}
