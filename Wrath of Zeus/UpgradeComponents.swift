//
//  UpgradeComponents.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

// MARK: - Компонент улучшения силы выстрела (добавляет заряд)
struct ShotPowerUpgrade: View {
    @ObservedObject var shopManager = ShopManager.shared
    @State private var level: Int = 1
    private let upgradeCost: Int = 400
    
    var body: some View {
        VStack(spacing: 8) {
            // Уровень в правом верхнем углу
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.yellow)
                        .frame(width: 40, height: 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    
                    Text("Lv.\(shopManager.shotPowerLevel)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            
            // Иконка из Assets (увеличенная)
            Image("skill1_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
            
            // Название улучшения
            Text("Shot Power")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
            
            Spacer()
            
            // Кнопка улучшения
            Button(action: {
                shopManager.buyShotPower()
            }) {
                Image(shopManager.canBuySkill() ? "buy_button" : "gray_button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 35)
            }
            .disabled(!shopManager.canBuySkill())
        }
        .padding(16)
        .frame(width: 120, height: 200)
        .background(
            Image("skill_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Компонент улучшения перезарядки (ускоряет на 0.5с)
struct ReloadUpgrade: View {
    @ObservedObject var shopManager = ShopManager.shared
    private let upgradeCost: Int = 400
    
    var body: some View {
        VStack(spacing: 8) {
            // Уровень в правом верхнем углу
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.yellow)
                        .frame(width: 40, height: 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    
                    Text("Lv.\(shopManager.reloadSpeedLevel)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            
            // Иконка из Assets (увеличенная)
            Image("skill2_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
            
            // Название улучшения
            Text("Reload Speed")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
            
            Spacer()
            
            // Кнопка улучшения
            Button(action: {
                shopManager.buyReloadSpeed()
            }) {
                Image(shopManager.canBuySkill() ? "buy_button" : "gray_button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 35)
            }
            .disabled(!shopManager.canBuySkill())
        }
        .padding(16)
        .frame(width: 120, height: 200)
        .background(
            Image("skill_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Компонент улучшения количества отскоков (убираем, так как не нужен)
struct BounceQuantityUpgrade: View {
    @ObservedObject var shopManager = ShopManager.shared
    
    var body: some View {
        VStack(spacing: 8) {
            // Уровень в правом верхнем углу
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray)
                        .frame(width: 40, height: 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 2)
                        )
                    
                    Text("Lv.1")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            
            // Иконка из Assets (увеличенная)
            Image("skill3_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70, height: 70)
            
            // Название улучшения
            Text("Coming Soon")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
            
            Spacer()
            
            // Кнопка улучшения (заблокирована)
            Button(action: {
                // Заблокировано
            }) {
                Image("gray_button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 35)
            }
            .disabled(true)
        }
        .padding(16)
        .frame(width: 120, height: 200)
        .background(
            Image("skill_bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
