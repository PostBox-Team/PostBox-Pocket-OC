//
//  SettingsCardToggle.swift
//  PostBox
//
//  Created by Polarizz on 11/10/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsCardToggle: View {
    
    private var onToggle: ((Bool) -> Void)?
    private var title: LocalizedStringKey
    private var desc: LocalizedStringKey?
    private var key: String?
    private var short: String
    private var disabled: Bool
    
    private var boolList: String?
    private var boolListKey: String { boolList ?? "" }
    
    var listValue: Bool {
        if  let key = key,
            let list = Defaults.dictionary(forKey: key) as? [String: Bool] {
            return list[key] ?? true
        }
        
        return isOn
    }
    
    init(title: LocalizedStringKey, desc: LocalizedStringKey?=nil, key: String?=nil, boolList: String?=nil, short: String, disabled: Bool, onToggle: ((Bool) -> Void)?=nil) {
        self.title = title
        self.desc = desc
        self.short = short
        self.disabled = disabled
        self.boolList = boolList
        self.onToggle = onToggle

        guard let key = key, key.count > 0 else {
            self._isOn = State(initialValue: false)
            return
        }

        self.key = key
        
        if let list = Defaults.dictionary(forKey: boolList ?? "") as? [String: Bool] {
            self._isOn = State(initialValue: list[key] ?? true)
        } else {
            self._isOn = State(initialValue: Defaults.bool(forKey: key))
        }
    }
    
    @State var isOn: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: Types.callout))
                    .fontWeight(.medium)
                    .foregroundColor(disabled ? Color(.tertiaryLabel) : .primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let desc = desc {
                    Text(desc)
                        .font(.system(size: Types.subheadline))
                        .fontWeight(.regular)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 3)
                }
            }
            .padding(.trailing, 9)

            Spacer()
            
            Group {
                if disabled {
                    Image("xmark.app.fill")
                        .font(.system(size: Types.title2))
                        .foregroundColor(Color(.tertiaryLabel))
                } else {
                    ToggleCheckButton(isOn: $isOn) {
                        Haptics.shared.play(.light)
                        withAnimation(.spring(response: 0.27, dampingFraction: 0.7)) { isOn.toggle() }
                        
                        if let key = key {
                            if var list = Defaults.dictionary(forKey: boolListKey) as? [String: Bool] {
                                list[key] = isOn
                                Defaults.set(list, forKey: boolListKey)
                            } else {
                                Defaults.set(isOn, forKey: key)
                            }
                        }
                        
                        DispatchQueue.main.async { self.onToggle?(isOn) }
                    }
                }
            }
        }
    }
}
