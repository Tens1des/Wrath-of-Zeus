//
//  ShopView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

struct ShopView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var shopManager = ShopManager.shared
    
    var body: some View {
        ZStack {
            // Фоновое изображение магазина
            Image("shop_Bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            // Контент магазина
            VStack {
                // Убираем панель с монетами
                
                // ScrollView с панелями
                ScrollView {
                    VStack(spacing: 20) {
                        // Панель навыков с улучшениями
                        ZStack {
                            // Фоновая панель навыков
                            Image("skill_panel")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                            
                            // Улучшения поверх панели
                            HStack(spacing: 20) {
                                ShotPowerUpgrade()
                                ReloadUpgrade()
                                BounceQuantityUpgrade()
                            }
                            .padding(.top, 40) // Отступ сверху для размещения на панели
                        }
                        
                        // Панель скинов с горизонтальным скроллом
                        ZStack {
                            // Фоновая панель скинов
                            Image("skins_panel")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                            
                            // Горизонтальный скролл со скинами поверх панели
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    SkinItem(skinName: "Classic", skinIcon: "skin1_icon", skinNumber: 1)
                                    SkinItem(skinName: "Fire", skinIcon: "skin2_icon", skinNumber: 2)
                                    SkinItem(skinName: "Ice", skinIcon: "skin3_icon", skinNumber: 3)
                                    SkinItem(skinName: "Lightning", skinIcon: "skin4_icon", skinNumber: 4)
                                }
                                .padding(.leading, 60) // Отступ слева для первого элемента
                                .padding(.trailing, 60) // Отступ справа для последнего элемента
                            }
                            .padding(.top, 30) // Отступ сверху для размещения на панели
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 100)
                }
                .frame(maxHeight: 600)
                .clipped()
                
                // Кнопка закрытия
                Button(action: {
                    dismiss()
                }) {
                    Image("close_button")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ShopView()
}
