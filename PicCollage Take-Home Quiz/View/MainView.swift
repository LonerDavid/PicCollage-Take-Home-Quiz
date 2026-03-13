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

  var body: some View {
    VStack {
      ZStack {
        ForEach(placedStickers) { placed in
          Image(systemName: placed.sticker.SystemName)
            .resizable()
            .scaledToFit()
            .frame(
              width: placed.sticker.DefaultSize.width,
              height: placed.sticker.DefaultSize.height
            )
            .foregroundStyle(placed.sticker.DefaultColor)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color("DefaultSecondaryBackgroundColor"))
      .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .stroke(Color.primary.opacity(0.3), lineWidth: 1)
      )
      .padding(.horizontal)
      .padding(.vertical, 8)

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
          .alert("Caution!", isPresented: $isShowingDeleteAlert) {
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
              placedStickers.append(PlacedSticker(sticker: sticker))
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
        }
        .padding(.horizontal)
      }
      .frame(maxHeight: 70)
    }
    .background(Color("DefaultBackgroundColor"))
  }
}

extension MainView {
  private struct PlacedSticker: Identifiable {
    let id = UUID()
    let sticker: DefaultSticker
  }
}

#Preview {
  MainView()
}
