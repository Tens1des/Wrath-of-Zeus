//
//  ShopView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

struct ShopView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Состояния активных скинов
    @State private var classicInUse: Bool = true
    @State private var fireInUse: Bool = false
    @State private var iceInUse: Bool = false
    @State private var lightningInUse: Bool = false
    @State private var darkInUse: Bool = false
    
    var body: some View {
        ZStack {
            // Фоновое изображение магазина
            Image("shop_Bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            // Контент магазина
            VStack {
                
                
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
                                    SkinItem(skinName: "Classic", skinIcon: "skin1_icon", skinPrice: 200, isOwned: true, isInUse: $classicInUse)
                                    SkinItem(skinName: "Fire", skinIcon: "skin2_icon", skinPrice: 500, isInUse: $fireInUse)
                                    SkinItem(skinName: "Ice", skinIcon: "skin3_icon", skinPrice: 300, isInUse: $iceInUse)
                                    SkinItem(skinName: "Lightning", skinIcon: "skin4_icon", skinPrice: 400, isInUse: $lightningInUse)
                                    SkinItem(skinName: "Dark", skinIcon: "skin5_icon", skinPrice: 600, isInUse: $darkInUse)
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
             
                .padding(.bottom, 20)
            }
        }
        .onChange(of: classicInUse) { newValue in
            if newValue {
                fireInUse = false
                iceInUse = false
                lightningInUse = false
                darkInUse = false
            }
        }
        .onChange(of: fireInUse) { newValue in
            if newValue {
                classicInUse = false
                iceInUse = false
                lightningInUse = false
                darkInUse = false
            }
        }
        .onChange(of: iceInUse) { newValue in
            if newValue {
                classicInUse = false
                fireInUse = false
                lightningInUse = false
                darkInUse = false
            }
        }
        .onChange(of: lightningInUse) { newValue in
            if newValue {
                classicInUse = false
                fireInUse = false
                iceInUse = false
                darkInUse = false
            }
        }
        .onChange(of: darkInUse) { newValue in
            if newValue {
                classicInUse = false
                fireInUse = false
                iceInUse = false
                lightningInUse = false
            }
        }
    }
}

#Preview {
    ShopView()
}
