//
//  StickerToolbarView.swift
//  PicCollage Take-Home Quiz
//
//  Created by GPT on 2026/3/25.
//

import SwiftUI

struct StickerToolbarView: View {
  @Binding var placedStickers: [PlacedSticker]
  @Binding var selectedStickerID: UUID?
  let selectedStickerColorBinding: Binding<Color>

  var body: some View {
    if selectedStickerID != nil {
      let toolbar = HStack {
        ColorPicker("Pick a color!", selection: selectedStickerColorBinding, supportsOpacity: true)
          .labelsHidden()
          .padding(8)

        Button {
          guard let id = selectedStickerID,
                let idx = placedStickers.firstIndex(where: { $0.id == id }) else { return }
          placedStickers.remove(at: idx)
          selectedStickerID = nil
        } label: {
          Image(systemName: "trash")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.red)
            .padding(10)
        }
        .buttonStyle(.plain)
      }

      Group {
        if #available(iOS 26.0, *) {
          toolbar.glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
        } else {
          toolbar
            .background(Material.bar)
            .overlay(
              Capsule(style: .continuous)
                .stroke(Color.primary.opacity(0.3), lineWidth: 1)
            )
            .clipShape(Capsule())
        }
      }
      .frame(maxWidth: 200, maxHeight: 50)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .padding()
    }
  }
}

#Preview {
  let sticker = DefaultSticker(
    SystemName: "star.fill",
    DefaultColor: .blue,
    DefaultSize: CGSize(width: 100, height: 100)
  )
  let placed = PlacedSticker(sticker: sticker)

  StickerToolbarView(
    placedStickers: .constant([placed]),
    selectedStickerID: .constant(placed.id),
    selectedStickerColorBinding: .constant(sticker.DefaultColor)
  )
}

