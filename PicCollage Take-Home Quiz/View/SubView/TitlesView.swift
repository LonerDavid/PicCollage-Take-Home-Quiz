//
//  IndicatorAndTitlesView.swift
//  PicCollage Take-Home Quiz
//
//  Created by GPT on 2026/3/25.
//

import SwiftUI

struct TitlesView: View {
  @Binding var placedStickers: [PlacedSticker]
  @Binding var selectedStickerID: UUID?

  @State private var isShowingDeleteAlert: Bool = false

  var body: some View {
    HStack {
      Text("Stickers")
        .font(.headline)

      Spacer()

      if placedStickers.isEmpty {
        if #available(iOS 26.0, *) {
          Text("Tap a sticker to place")
            .padding(.horizontal, 14)
            .padding(.vertical, 5)
            .foregroundStyle(.white)
            .frame(maxWidth: 160, maxHeight: 25)
            .font(.caption)
            .fontWeight(.semibold)
            .background(
              Capsule()
                .foregroundStyle(.accent)
            )
            .glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
        } else {
          Text("Tap a sticker to place")
            .padding(.horizontal, 14)
            .padding(.vertical, 5)
            .foregroundStyle(.white)
            .frame(maxWidth: 160, maxHeight: 25)
            .font(.caption)
            .fontWeight(.semibold)
            .background(
              Capsule()
                .foregroundStyle(.accent)
            )
        }
      } else {
        Button {
          isShowingDeleteAlert = true
        } label: {
          Group {
            if #available(iOS 26.0, *) {
              HStack {
                Image(systemName: "trash")
                Text("Delete all stickers")
              }
              .padding(.horizontal, 10)
              .padding(.vertical, 5)
              .frame(maxWidth: 160, maxHeight: 25)
              .foregroundStyle(.white)
              .font(.caption)
              .fontWeight(.semibold)
              .background(
                Capsule()
                  .foregroundStyle(.red)
              )
              .glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
            } else {
              HStack {
                Image(systemName: "trash")
                Text("Delete all stickers")
              }
              .padding(.horizontal, 10)
              .padding(.vertical, 5)
              .frame(maxWidth: 160, maxHeight: 25)
              .foregroundStyle(.white)
              .font(.caption)
              .fontWeight(.semibold)
              .background(
                Capsule()
                  .foregroundStyle(.red)
              )
            }
          }
        }
        .alert("Warning!", isPresented: $isShowingDeleteAlert) {
          Button(role: .cancel) {} label: {
            Text("Cancel")
          }
          Button(role: .destructive) {
            placedStickers.removeAll()
            selectedStickerID = nil
          } label: {
            Text("Remove")
          }
        } message: {
          Text("All stickers will be removed")
        }
      }
    }
    .padding(.horizontal)
    .padding(.bottom)
  }
}

#Preview {
  let sticker = DefaultSticker(
    SystemName: "star.fill",
    DefaultColor: .blue,
    DefaultSize: CGSize(width: 100, height: 100)
  )
  let placed = PlacedSticker(sticker: sticker)

  TitlesView(
    placedStickers: .constant([placed]),
    selectedStickerID: .constant(placed.id)
  )
}

