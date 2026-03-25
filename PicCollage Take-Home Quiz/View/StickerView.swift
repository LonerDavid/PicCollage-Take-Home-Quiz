//
//  DraggableStickerView.swift
//  PicCollage Take-Home Quiz
//
//  Created by Haruaki on 2026/3/13.
//

import SwiftUI

struct StickerView: View {
  let placed: PlacedSticker
  @Binding var placedStickers: [PlacedSticker]
  @Binding var selectedStickerID: UUID?
  var liveDragTranslation: CGSize = .zero
  var liveRotation: Angle = .zero
  var liveMagnification: CGFloat = 1.0

  var body: some View {
    let isSelected = selectedStickerID == placed.id

    ZStack(alignment: .topTrailing) {
      Image(systemName: placed.sticker.SystemName)
        .resizable()
        .scaledToFit()
        .frame(
          width: placed.sticker.DefaultSize.width,
          height: placed.sticker.DefaultSize.height
        )
        .foregroundStyle(placed.sticker.selectedColor ?? placed.sticker.DefaultColor)
        .scaleEffect(placed.sticker.scale * liveMagnification)
        .padding(3)
        .overlay(
          Group {
            RoundedRectangle(cornerRadius: 5, style: .continuous)
              .stroke(isSelected ? Color("DefaultFrameColor").opacity(0.3) : .clear, lineWidth: 2)
              .scaleEffect(placed.sticker.scale * liveMagnification)
          }
        )
    }
    .rotationEffect(placed.sticker.rotationAngle + liveRotation)
    .offset(
      x: placed.sticker.position.x + liveDragTranslation.width,
      y: placed.sticker.position.y + liveDragTranslation.height
    )
    .onTapGesture {
      selectedStickerID = placed.id
    }
  }
}

#Preview {
  MainView()
}
