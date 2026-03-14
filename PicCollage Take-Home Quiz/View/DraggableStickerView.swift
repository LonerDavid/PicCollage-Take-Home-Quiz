//
//  DraggableStickerView.swift
//  PicCollage Take-Home Quiz
//
//  Created by Haruaki on 2026/3/13.
//

import SwiftUI

struct DraggableStickerView: View {
  let placed: PlacedSticker
  @Binding var placedStickers: [PlacedSticker]
  @GestureState private var dragOffset: CGSize = .zero

  var body: some View {
    Image(systemName: placed.sticker.SystemName)
      .resizable()
      .scaledToFit()
      .frame(
        width: placed.sticker.DefaultSize.width,
        height: placed.sticker.DefaultSize.height
      )
      .foregroundStyle(placed.sticker.DefaultColor)
      .offset(
        x: placed.sticker.position.x + dragOffset.width,
        y: placed.sticker.position.y + dragOffset.height
      )
      .gesture(
        DragGesture()
          .updating($dragOffset) { value, state, _ in
            state = value.translation
          }
          .onEnded { value in
            guard let i = placedStickers.firstIndex(where: { $0.id == placed.id }) else { return }
            placedStickers[i].sticker.position.x += value.translation.width
            placedStickers[i].sticker.position.y += value.translation.height
          }
      )
  }
}

#Preview {
  MainView()
}
