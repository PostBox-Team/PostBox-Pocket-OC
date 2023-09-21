//
//  Type.swift
//  PostBox
//
//  Created by Polarizz on 12/14/20.
//  Copyright © 2022 postboxteam. All rights reserved.
//

import SwiftUI

struct SettingsSectionHeader: View {
    
    private var text: LocalizedStringKey
    
    init(_ text: LocalizedStringKey) {
        self.text = text
    }
    
    var body: some View {
        LeadingHStack {
            Text(text)
                .font(.system(size: Types.footnote))
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 1)
        .padding(.bottom, -3)
    }
}

struct DropDownSectionHeader: View {
    
    private var text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        LeadingHStack {
            Text(text)
                .font(.system(size: Types.callout))
                .padding(.trailing, 5)
            
            Image(systemName: "chevron.down")
                .font(.caption.weight(.medium))
            
        }
        .foregroundColor(.secondary)
    }
}

struct SectionHeader: View {
    
    private var text: LocalizedStringKey
    private var listHeader: Bool
    
    init(_ text: LocalizedStringKey, listHeader: Bool?=false) {
        self.text = text
        self.listHeader = listHeader!
    }
    
    var body: some View {
        LeadingHStack {
            Text(text)
                .font(.system(size: Types.callout))
                .foregroundColor(.secondary)
        }
        .if(listHeader) { view in
            view
                .padding(.horizontal, UIConstants.margin)
                .padding(.top, 20)
                .padding(.bottom, 10)
        }
    }
}

struct SectionHeaderNoLocalization: View {
    
    private var text: String
    private var listHeader: Bool
    
    init(_ text: String, listHeader: Bool?=false) {
        self.text = text
        self.listHeader = listHeader!
    }
    
    var body: some View {
        LeadingHStack {
            Text(text)
                .font(.system(size: Types.callout))
                .foregroundColor(.secondary)
        }
        .if(listHeader) { view in
            view
                .padding(.horizontal, UIConstants.margin)
                .padding(.top, 20)
                .padding(.bottom, 10)
        }
    }
}

struct SectionHeaderRedacted: View {
    var body: some View {
        LeadingHStack {
            Text("Popular")
                .font(.system(size: Types.callout))
                .lineLimit(1)
                .foregroundColor(.white.opacity(0))
                .background(Color(.quaternarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
        }
    }
}
