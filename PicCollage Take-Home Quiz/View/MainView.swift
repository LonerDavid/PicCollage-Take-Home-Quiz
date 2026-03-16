//
//  MainView.swift
//  PicCollage Take-Home Quiz
//
//  Created by Haruaki on 2026/3/13.
//

import SwiftUI

struct MainView: View {
  @State private var placedStickers: [PlacedSticker] = []
  @State private var isShowingDeleteAlert: Bool = false
  @State private var selectedStickerID: UUID? = nil

  var body: some View {
    VStack {
      ZStack {
        Color.clear
          .contentShape(Rectangle())
          .onTapGesture {
            selectedStickerID = nil
          }

        ForEach(placedStickers) { placed in
          DraggableStickerView(
            placed: placed,
            placedStickers: $placedStickers,
            selectedStickerID: $selectedStickerID
          )
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color("DefaultSecondaryBackgroundColor"))
      .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .stroke(Color.primary.opacity(0.3), lineWidth: 1)
      )
      .padding()

      HStack {
        Text("Stickers")
          .font(.headline)
        Spacer()
        if (placedStickers.isEmpty) {
          Text("Tap a sticker to place")
            .padding(.horizontal, 14)
            .padding(.vertical, 5)
            .foregroundStyle(.white)
            .frame(maxWidth: 160,maxHeight: 25)
            .font(.caption)
            .fontWeight(.semibold)
            .background(
              Capsule()
                .foregroundStyle(.accent)
            )
        } else {
          Button {
            isShowingDeleteAlert = true
          } label: {
            HStack{
              Image(systemName: "trash")
              Text("Delete all stickers")
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .frame(maxWidth: 160,maxHeight: 25)
            .foregroundStyle(.white)
            .font(.caption)
            .fontWeight(.semibold)
            .background(
              Capsule()
                .foregroundStyle(.red)
            )
          }
          .alert("Warning!", isPresented: $isShowingDeleteAlert) {
            Button(role: .cancel) {} label: {
              Text("Cancel")
            }
            Button(role: .destructive) {
              placedStickers.removeAll()
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

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(Array(defaultStickers.enumerated()), id: \.offset) {
            _,
            sticker in
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
                .foregroundStyle(.accent)
                .background(Color("DefaultSecondaryBackgroundColor"))
                .clipShape(
                  RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
            }
            .buttonStyle(.plain)
          }

//          Button {
//            // Add New Stickers (Features in the future)
//
//          } label: {
//            Image(systemName: "plus.circle.dashed")
//              .resizable()
//              .scaledToFit()
//              .frame(width: 40, height: 40)
//              .padding(8)
//              .foregroundStyle(.accent)
//          }
//          .buttonStyle(.borderless)
        }
        .padding(.horizontal)
      }
      .frame(maxHeight: 70)
    }
    .background(Color("DefaultBackgroundColor"))
  }
}

#Preview {
  MainView()
}
