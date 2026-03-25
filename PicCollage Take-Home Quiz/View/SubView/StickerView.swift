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
  @GestureState private var dragOffset: CGSize = .zero
  var liveDragTranslation: CGSize = .zero
  var liveRotation: Angle = .zero
  var liveMagnification: CGFloat = 1.0
  var isCanvasTransforming: Bool = false


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
      x: placed.sticker.position.x + liveDragTranslation.width + dragOffset.width,
      y: placed.sticker.position.y + liveDragTranslation.height + dragOffset.height
    )
    .onTapGesture {
      selectedStickerID = placed.id
    }
    .gesture(
      DragGesture(minimumDistance: 5)
        .onChanged { _ in
          // Gate sticker dragging during canvas rotate/magnify to avoid
          // gesture competition where the sticker can appear to disappear.
          if !isSelected || isCanvasTransforming { return }
        }
        .updating($dragOffset) { value, state, _ in
          guard isSelected, !isCanvasTransforming else {
            state = .zero
            return
          }
          state = value.translation
        }
        .onEnded { value in
          guard isSelected, !isCanvasTransforming else { return }
          guard let i = placedStickers.firstIndex(where: { $0.id == placed.id }) else { return }
          placedStickers[i].sticker.position.x += value.translation.width
          placedStickers[i].sticker.position.y += value.translation.height
        }
    )
  }
}

#Preview {
  let sticker = DefaultSticker(
    SystemName: "star.fill",
    DefaultColor: .blue,
    DefaultSize: CGSize(width: 100, height: 100)
  )
  let placed = PlacedSticker(sticker: sticker)

  StickerView(
    placed: placed,
    placedStickers: .constant([placed]),
    selectedStickerID: .constant(placed.id),
    liveDragTranslation: .zero,
    liveRotation: .zero,
    liveMagnification: 1.0,
    isCanvasTransforming: false
  )
}
