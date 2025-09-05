//
//  UpgradeComponents.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

// MARK: - Компонент улучшения силы выстрела
struct ShotPowerUpgrade: View {
    @State private var level: Int = 1
    @State private var upgradeCost: Int = 400
    @State private var userCoins: Int = 500 // Примерное количество монет пользователя
    
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
                    
                    Text("Lv.\(level)")
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
            
            // Кнопка улучшения (без текста)
            Button(action: {
                // Логика улучшения
                if userCoins >= upgradeCost {
                    userCoins -= upgradeCost
                    level += 1
                    upgradeCost += 100 // Увеличиваем стоимость
                }
            }) {
                Image(userCoins >= upgradeCost ? "buy_button" : "gray_button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 35)
            }
            .disabled(userCoins < upgradeCost)
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

// MARK: - Компонент улучшения перезарядки
struct ReloadUpgrade: View {
    @State private var level: Int = 1
    @State private var upgradeCost: Int = 400
    @State private var userCoins: Int = 500 // Примерное количество монет пользователя
    
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
                    
                    Text("Lv.\(level)")
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
            Text("Reload")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
            
            Spacer()
            
            // Кнопка улучшения (без текста)
            Button(action: {
                // Логика улучшения
                if userCoins >= upgradeCost {
                    userCoins -= upgradeCost
                    level += 1
                    upgradeCost += 100 // Увеличиваем стоимость
                }
            }) {
                Image(userCoins >= upgradeCost ? "buy_button" : "gray_button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 35)
            }
            .disabled(userCoins < upgradeCost)
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

// MARK: - Компонент улучшения количества отскоков
struct BounceQuantityUpgrade: View {
    @State private var level: Int = 1
    @State private var upgradeCost: Int = 400
    @State private var userCoins: Int = 500 // Примерное количество монет пользователя
    
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
                    
                    Text("Lv.\(level)")
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
            Text("Bounce Quant.")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 2)
            
            Spacer()
            
            // Кнопка улучшения (без текста)
            Button(action: {
                // Логика улучшения
                if userCoins >= upgradeCost {
                    userCoins -= upgradeCost
                    level += 1
                    upgradeCost += 100 // Увеличиваем стоимость
                }
            }) {
                Image(userCoins >= upgradeCost ? "buy_button" : "gray_button")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 35)
            }
            .disabled(userCoins < upgradeCost)
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
