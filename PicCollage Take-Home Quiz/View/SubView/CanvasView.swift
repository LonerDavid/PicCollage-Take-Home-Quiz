//
//  CanvasView.swift
//  PicCollage Take-Home Quiz
//
//  Created by GPT on 2026/3/25.
//

import SwiftUI

struct CanvasView: View {
  @Binding var placedStickers: [PlacedSticker]
  @Binding var selectedStickerID: UUID?

  let selectedStickerColorBinding: Binding<Color>
  let stickerMinScale: CGFloat
  let stickerMaxScale: CGFloat

  @GestureState private var canvasDragTranslation: CGSize = .zero
  @GestureState private var canvasRotate: Angle = .zero
  @GestureState private var canvasMagnify: CGFloat = 1.0

  var body: some View {
    ZStack {
      Color.clear
        .contentShape(Rectangle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
          selectedStickerID = nil
        }

      ForEach(placedStickers) { placed in
        StickerView(
          placed: placed,
          placedStickers: $placedStickers,
          selectedStickerID: $selectedStickerID,
          liveDragTranslation: selectedStickerID == placed.id ? canvasDragTranslation : .zero,
          liveRotation: selectedStickerID == placed.id ? canvasRotate : .zero,
          liveMagnification: selectedStickerID == placed.id ? canvasMagnify : 1.0,
          isCanvasTransforming: selectedStickerID == placed.id
            && (canvasRotate != .zero || abs(canvasMagnify - 1.0) > 0.001)
        )
      }

      StickerToolbarView(
        placedStickers: $placedStickers,
        selectedStickerID: $selectedStickerID,
        selectedStickerColorBinding: selectedStickerColorBinding
      )
    }
    .simultaneousGesture(
      SimultaneousGesture(
        RotateGesture()
          .updating($canvasRotate) { value, state, _ in
            state = value.rotation
          }
          .onEnded { value in
            guard let id = selectedStickerID,
                  let i = placedStickers.firstIndex(where: { $0.id == id }) else { return }
            placedStickers[i].sticker.rotationAngle += value.rotation
          },
        MagnifyGesture()
          .updating($canvasMagnify) { value, state, _ in
            state = value.magnification
          }
          .onEnded { value in
            guard let id = selectedStickerID,
                  let i = placedStickers.firstIndex(where: { $0.id == id }) else { return }
            let next = placedStickers[i].sticker.scale * value.magnification
            placedStickers[i].sticker.scale = min(stickerMaxScale, max(stickerMinScale, next))
          }
      ),
      isEnabled: selectedStickerID != nil
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(Color("DefaultSecondaryBackgroundColor"))
    )
    .padding()
  }
}

#Preview {
  let sticker = DefaultSticker(
    SystemName: "star.fill",
    DefaultColor: .blue,
    DefaultSize: CGSize(width: 100, height: 100)
  )
  let placed = PlacedSticker(sticker: sticker)

  CanvasView(
    placedStickers: .constant([placed]),
    selectedStickerID: .constant(placed.id),
    selectedStickerColorBinding: .constant(sticker.DefaultColor),
    stickerMinScale: 0.2,
    stickerMaxScale: 5.0
  )
}

