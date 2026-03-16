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
  @GestureState private var rotationAmount: Angle = .zero
  @GestureState private var scaleAmount: CGFloat = 1.0

  private let minScale: CGFloat = 0.2
  private let maxScale: CGFloat = 5.0

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
        .scaleEffect(placed.sticker.scale * scaleAmount)
        .padding(3)
        .overlay(
          Group {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
              .stroke(isSelected ? Color("DefaultFrameColor").opacity(0.3) : .clear, lineWidth: 2)
              .scaleEffect(placed.sticker.scale * scaleAmount)
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
                  .resizable()
                  .scaledToFit()
                  .frame(width: 23, height: 23)
                  .foregroundStyle(.red)
                  .background(.white)
                  .clipShape(Circle())
              }
              .offset(
                x: placed.sticker.DefaultSize.width * placed.sticker.scale * Double(scaleAmount) * 0.525,
                y: placed.sticker.DefaultSize.height * placed.sticker.scale * Double(scaleAmount) * -0.525
              )
              .padding(4)
              .buttonStyle(.plain)

              Circle()
                .fill(Color.blue)
                .frame(width: 26, height: 26)
                .overlay(
                  Image(systemName: "arrow.up.right.and.arrow.down.left")
                    .resizable()
                    .scaledToFit()
                    .padding(6)
                    .foregroundStyle(.white)
                )
                .offset(
                  x: placed.sticker.DefaultSize.width * placed.sticker.scale * Double(scaleAmount) * -0.525,
                  y: placed.sticker.DefaultSize.height * placed.sticker.scale * Double(scaleAmount) * 0.525
                )
                .padding(4)
                .gesture(
                  DragGesture()
                  // .updating($rotationAmount) { value, state, _ in
                  //   guard isSelected else { return }
                  //   let rotationDelta = Angle(degrees: Double(value.translation.width) / 2.0)
                  //   state = rotationDelta
                  // }
                    .updating($scaleAmount) { value, state, _ in
                      guard isSelected else { return }
                      let scaleDelta = 1.0 + (value.translation.height / 100.0)
                      state = max(minScale / placed.sticker.scale, min(maxScale / placed.sticker.scale, scaleDelta))
                    }
                    .onEnded { value in
                      guard isSelected,
                            let i = placedStickers.firstIndex(where: { $0.id == placed.id }) else { return }
                      // let rotationDelta = Angle(degrees: Double(value.translation.width) / 2.0)
                      // placedStickers[i].sticker.rotationAngle += rotationDelta
                      let rawScaleDelta = 1.0 + (value.translation.height / 100.0)
                      let newScale = placedStickers[i].sticker.scale * rawScaleDelta
                      placedStickers[i].sticker.scale = min(maxScale, max(minScale, newScale))
                    }
                )
            }
          }
        )
    }
    // .rotationEffect(placed.sticker.rotationAngle + rotationAmount)
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
