//
//  ShopManager.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI
import Combine

class ShopManager: ObservableObject {
    static let shared = ShopManager()
    
    // Монеты пользователя
    @Published var totalCoins: Int = 0
    
    // Навыки
    @Published var shotPowerLevel: Int = 1
    @Published var reloadSpeedLevel: Int = 1
    
    // Скины (owned, inUse) - только один может быть inUse
    @Published var skin1Owned: Bool = true  // Classic - по умолчанию
    @Published var skin1InUse: Bool = true
    @Published var skin2Owned: Bool = false
    @Published var skin2InUse: Bool = false
    @Published var skin3Owned: Bool = false
    @Published var skin3InUse: Bool = false
    @Published var skin4Owned: Bool = false
    @Published var skin4InUse: Bool = false
    
    // Цены
    private let skillPrice: Int = 400
    private let skinPrice: Int = 400
    
    private init() {
        loadData()
    }
    
    // MARK: - Навыки
    
    func canBuySkill() -> Bool {
        return totalCoins >= skillPrice
    }
    
    func buyShotPower() {
        guard canBuySkill() else { return }
        totalCoins -= skillPrice
        shotPowerLevel += 1
        saveData()
    }
    
    func buyReloadSpeed() {
        guard canBuySkill() else { return }
        totalCoins -= skillPrice
        reloadSpeedLevel += 1
        saveData()
    }
    
    // MARK: - Скины
    
    func canBuySkin(skinNumber: Int) -> Bool {
        return totalCoins >= skinPrice && !isSkinOwned(skinNumber)
    }
    
    func buySkin(skinNumber: Int) {
        guard canBuySkin(skinNumber: skinNumber) else { return }
        totalCoins -= skinPrice
        setSkinOwned(skinNumber, owned: true)
        saveData()
    }
    
    func useSkin(skinNumber: Int) {
        // Снимаем ВСЕ скины с использования
        skin1InUse = false
        skin2InUse = false
        skin3InUse = false
        skin4InUse = false
        
        // Активируем только выбранный скин
        setSkinInUse(skinNumber, inUse: true)
        saveData()
    }
    
    func isSkinOwned(_ skinNumber: Int) -> Bool {
        switch skinNumber {
        case 1: return skin1Owned
        case 2: return skin2Owned
        case 3: return skin3Owned
        case 4: return skin4Owned
        default: return false
        }
    }
    
    func isSkinInUse(_ skinNumber: Int) -> Bool {
        switch skinNumber {
        case 1: return skin1InUse
        case 2: return skin2InUse
        case 3: return skin3InUse
        case 4: return skin4InUse
        default: return false
        }
    }
    
    private func setSkinOwned(_ skinNumber: Int, owned: Bool) {
        switch skinNumber {
        case 1: skin1Owned = owned
        case 2: skin2Owned = owned
        case 3: skin3Owned = owned
        case 4: skin4Owned = owned
        default: break
        }
    }
    
    private func setSkinInUse(_ skinNumber: Int, inUse: Bool) {
        switch skinNumber {
        case 1: skin1InUse = inUse
        case 2: skin2InUse = inUse
        case 3: skin3InUse = inUse
        case 4: skin4InUse = inUse
        default: break
        }
    }
    
    // MARK: - Получение активного скина молнии
    
    func getActiveLightningSkin() -> String {
        if skin1InUse { return "molniya_objc" }      // Classic
        if skin2InUse { return "skin1_moln" }        // Skin 1
        if skin3InUse { return "skin2_moln" }        // Skin 2
        if skin4InUse { return "skin3_moln" }        // Skin 3
        return "molniya_objc" // По умолчанию
    }
    
    // MARK: - Сохранение и загрузка
    
    private func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(totalCoins, forKey: "totalCoins")
        defaults.set(shotPowerLevel, forKey: "shotPowerLevel")
        defaults.set(reloadSpeedLevel, forKey: "reloadSpeedLevel")
        defaults.set(skin1Owned, forKey: "skin1Owned")
        defaults.set(skin1InUse, forKey: "skin1InUse")
        defaults.set(skin2Owned, forKey: "skin2Owned")
        defaults.set(skin2InUse, forKey: "skin2InUse")
        defaults.set(skin3Owned, forKey: "skin3Owned")
        defaults.set(skin3InUse, forKey: "skin3InUse")
        defaults.set(skin4Owned, forKey: "skin4Owned")
        defaults.set(skin4InUse, forKey: "skin4InUse")
    }
    
    private func loadData() {
        let defaults = UserDefaults.standard
        totalCoins = defaults.integer(forKey: "totalCoins")
        shotPowerLevel = defaults.integer(forKey: "shotPowerLevel")
        if shotPowerLevel == 0 { shotPowerLevel = 1 } // По умолчанию
        
        reloadSpeedLevel = defaults.integer(forKey: "reloadSpeedLevel")
        if reloadSpeedLevel == 0 { reloadSpeedLevel = 1 } // По умолчанию
        
        skin1Owned = defaults.bool(forKey: "skin1Owned")
        if !skin1Owned { skin1Owned = true } // Classic по умолчанию
        
        skin1InUse = defaults.bool(forKey: "skin1InUse")
        if !skin1InUse && skin1Owned { skin1InUse = true } // Classic по умолчанию
        
        skin2Owned = defaults.bool(forKey: "skin2Owned")
        skin2InUse = defaults.bool(forKey: "skin2InUse")
        skin3Owned = defaults.bool(forKey: "skin3Owned")
        skin3InUse = defaults.bool(forKey: "skin3InUse")
        skin4Owned = defaults.bool(forKey: "skin4Owned")
        skin4InUse = defaults.bool(forKey: "skin4InUse")
    }
}
