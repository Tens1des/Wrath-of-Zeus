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
    let skinNumber: Int
    @ObservedObject var shopManager = ShopManager.shared
    
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
                if !shopManager.isSkinOwned(skinNumber) && shopManager.canBuySkin(skinNumber: skinNumber) {
                    // Покупка скина
                    shopManager.buySkin(skinNumber: skinNumber)
                } else if shopManager.isSkinOwned(skinNumber) && !shopManager.isSkinInUse(skinNumber) {
                    // Выбор скина (начать использовать) - автоматически снимает другие скины
                    shopManager.useSkin(skinNumber: skinNumber)
                }
                // Если скин уже используется - ничего не делаем (кнопка "In Use")
            }) {
                Image(buttonImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
            }
            .disabled(!shopManager.isSkinOwned(skinNumber) && !shopManager.canBuySkin(skinNumber: skinNumber))
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
        if shopManager.isSkinInUse(skinNumber) {
            return "inUse_button"  // Скин используется
        } else if shopManager.isSkinOwned(skinNumber) {
            return "use_button"    // Скин куплен, но не используется
        } else if shopManager.canBuySkin(skinNumber: skinNumber) {
            return "buy_button"    // Можно купить
        } else {
            return "gray_button"   // Недостаточно денег
        }
    }
}
