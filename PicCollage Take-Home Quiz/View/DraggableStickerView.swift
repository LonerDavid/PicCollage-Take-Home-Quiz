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
  @Binding var selectedStickerID: UUID?
  @GestureState private var dragOffset: CGSize = .zero

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
        .foregroundStyle(placed.sticker.DefaultColor)
        .padding(3)
        .overlay(
          RoundedRectangle(cornerRadius: 3, style: .continuous)
            .stroke(isSelected ? Color("DefaultFrameColor").opacity(0.3) : .clear, lineWidth: 2)
        )

      if isSelected {
        Button {
          if let index = placedStickers.firstIndex(where: { $0.id == placed.id }) {
            placedStickers.remove(at: index)
          }
          if selectedStickerID == placed.id {
            selectedStickerID = nil
          }
        } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundStyle(.red)
            .background(.white)
            .clipShape(Circle())
        }
        .offset(
          x: placed.sticker.DefaultSize.width * 0.13,
          y: placed.sticker.DefaultSize.height * -0.13
        )
        .padding(4)
        .buttonStyle(.plain)
      }
    }
    .offset(
      x: placed.sticker.position.x + dragOffset.width,
      y: placed.sticker.position.y + dragOffset.height
    )
    .onTapGesture {
      selectedStickerID = placed.id
    }
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
