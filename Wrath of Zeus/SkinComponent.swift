//
//  SkinComponent.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

// MARK: - Компонент скина
struct SkinItem: View {
    let skinName: String
    let skinIcon: String
    let skinPrice: Int
    @State private var isOwned: Bool
    @Binding var isInUse: Bool
    @State private var userCoins: Int = 500
    
    // Инициализатор с параметрами по умолчанию
    init(skinName: String, skinIcon: String, skinPrice: Int, isOwned: Bool = false, isInUse: Binding<Bool>) {
        self.skinName = skinName
        self.skinIcon = skinIcon
        self.skinPrice = skinPrice
        self._isOwned = State(initialValue: isOwned)
        self._isInUse = isInUse
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Иконка скина
            Image(skinIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            // Название скина
            Text(skinName)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // Кнопка в зависимости от состояния
            Button(action: {
                if !isOwned && userCoins >= skinPrice {
                    // Покупка скина
                    userCoins -= skinPrice
                    isOwned = true
                } else if isOwned && !isInUse {
                    // Выбор скина (начать использовать)
                    isInUse = true
                } else if isOwned && isInUse {
                    // Снять скина с использования
                    isInUse = false
                }
            }) {
                Image(buttonImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
            }
            .disabled(!isOwned && userCoins < skinPrice)
        }
        .padding(12)
        .frame(width: 120, height: 200)
        .background(
            Image("skill_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // Выбор изображения кнопки в зависимости от состояния
    private var buttonImageName: String {
        if isInUse {
            return "inUse_button"  // Скин используется
        } else if isOwned {
            return "use_button"    // Скин куплен, но не используется
        } else if userCoins >= skinPrice {
            return "buy_button"    // Можно купить
        } else {
            return "gray_button"   // Недостаточно денег
        }
    }
}
