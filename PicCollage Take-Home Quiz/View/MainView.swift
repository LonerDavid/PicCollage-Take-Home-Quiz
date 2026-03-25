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
  @GestureState private var canvasDragTranslation: CGSize = .zero
  @GestureState private var canvasRotate: Angle = .zero
  @GestureState private var canvasMagnify: CGFloat = 1.0

  private let stickerMinScale: CGFloat = 0.2
  private let stickerMaxScale: CGFloat = 5.0

  var body:some View {
    VStack {

      //Canvas
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
            liveMagnification: selectedStickerID == placed.id ? canvasMagnify : 1.0
          )
        }

        //Sticker Toolbar
        if selectedStickerID != nil {
          let stickerToolbar = HStack {
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
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
            }
            .buttonStyle(.plain)
          }

          Group {
            if #available(iOS 26.0, *) {
              stickerToolbar
                .glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
            } else {
              stickerToolbar
                .background(Material.bar)
                .overlay(
                  Capsule(style: .continuous)
                    .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                )
                .clipShape(Capsule())
            }
          }
          .frame(maxWidth: 200, maxHeight: 40)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
          .padding()
        }

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
      .background(Color("DefaultSecondaryBackgroundColor"))
      .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//      .overlay(
//        RoundedRectangle(cornerRadius: 10, style: .continuous)
//          .stroke(Color.primary.opacity(0.3), lineWidth: 1)
//      )
      .padding()

      //Indicator & Titles
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

      //Sticker picker
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
                .foregroundStyle(sticker.DefaultColor)
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

extension MainView {
  private var selectedStickerColorBinding: Binding<Color> {
    Binding(
      get: {
        guard let id = selectedStickerID,
              let idx = placedStickers.firstIndex(where: { $0.id == id }) else {
          return .gray
        }
        let sticker = placedStickers[idx].sticker
        return sticker.selectedColor ?? sticker.DefaultColor
      },
      set: { newColor in
        guard let id = selectedStickerID,
              let idx = placedStickers.firstIndex(where: { $0.id == id }) else { return }
        placedStickers[idx].sticker.selectedColor = newColor
      }
    )
  }
}

#Preview {
  MainView()
}
