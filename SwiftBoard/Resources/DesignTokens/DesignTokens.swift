//
//  DesignTokens.swift
//  SwiftBoard
//
//  Created by Amit Sen on 9/9/25.
//  © 2025 Coding With Amit. All rights reserved.

import SwiftUI

/// Design tokens for consistent spacing, colors, typography, and other design elements
public enum DesignTokens {
  
  // MARK: - Spacing
  
  public enum Spacing {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 24
    public static let xl: CGFloat = 32
    public static let xxl: CGFloat = 48
    public static let xxxl: CGFloat = 64
  }
  
  // MARK: - Border Radius
  
  public enum Radius {
    public static let xs: CGFloat = 4
    public static let sm: CGFloat = 8
    public static let md: CGFloat = 12
    public static let lg: CGFloat = 16
    public static let xl: CGFloat = 24
    public static let full: CGFloat = 999
  }
  
  // MARK: - Typography
  
  public enum Typography {
    public static let largeTitle = Font.largeTitle.weight(.bold)
    public static let title = Font.title.weight(.semibold)
    public static let title2 = Font.title2.weight(.semibold)
    public static let title3 = Font.title3.weight(.medium)
    public static let headline = Font.headline.weight(.semibold)
    public static let body = Font.body
    public static let bodyEmphasized = Font.body.weight(.medium)
    public static let callout = Font.callout
    public static let subheadline = Font.subheadline
    public static let footnote = Font.footnote
    public static let caption = Font.caption
    public static let caption2 = Font.caption2
  }
  
  // MARK: - Colors
  
  public enum Colors {
    // Primary Colors
    public static let primary = Color("Primary")
    public static let primaryVariant = Color("PrimaryVariant")
    public static let secondary = Color("Secondary")
    public static let secondaryVariant = Color("SecondaryVariant")
    
    // Semantic Colors
    public static let success = Color("Success")
    public static let warning = Color("Warning")
    public static let error = Color("Error")
    public static let info = Color("Info")
    
    // Neutral Colors
    public static let background = Color("Background")
    public static let surface = Color("Surface")
    public static let surfaceVariant = Color("SurfaceVariant")
    public static let outline = Color("Outline")
    public static let outlineVariant = Color("OutlineVariant")
    
    // Text Colors
    public static let onBackground = Color("OnBackground")
    public static let onSurface = Color("OnSurface")
    public static let onSurfaceVariant = Color("OnSurfaceVariant")
    public static let onPrimary = Color("OnPrimary")
    public static let onSecondary = Color("OnSecondary")
    public static let onError = Color("OnError")
    
    // System Colors (with semantic meaning)
    public static let systemBackground = Color(.systemBackground)
    public static let systemSecondaryBackground = Color(.secondarySystemBackground)
    public static let systemTertiaryBackground = Color(.tertiarySystemBackground)
    public static let systemGroupedBackground = Color(.systemGroupedBackground)
    public static let systemSecondaryGroupedBackground = Color(.secondarySystemGroupedBackground)
    public static let systemTertiaryGroupedBackground = Color(.tertiarySystemGroupedBackground)
    
    public static let label = Color(.label)
    public static let secondaryLabel = Color(.secondaryLabel)
    public static let tertiaryLabel = Color(.tertiaryLabel)
    public static let quaternaryLabel = Color(.quaternaryLabel)
    
    public static let systemFill = Color(.systemFill)
    public static let secondarySystemFill = Color(.secondarySystemFill)
    public static let tertiarySystemFill = Color(.tertiarySystemFill)
    public static let quaternarySystemFill = Color(.quaternarySystemFill)
  }
  
  // MARK: - Shadows
  
  public enum Shadow {
    public static let small = ShadowStyle(
      color: .black.opacity(0.1),
      radius: 2,
      x: 0,
      y: 1
    )
    
    public static let medium = ShadowStyle(
      color: .black.opacity(0.15),
      radius: 4,
      x: 0,
      y: 2
    )
    
    public static let large = ShadowStyle(
      color: .black.opacity(0.2),
      radius: 8,
      x: 0,
      y: 4
    )
  }
  
  // MARK: - Animation
  
  public enum Animation {
    public static let fast = SwiftUI.Animation.easeInOut(duration: 0.2)
    public static let medium = SwiftUI.Animation.easeInOut(duration: 0.3)
    public static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
    
    public static let spring = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
    public static let bouncy = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.6)
  }
  
  // MARK: - Layout
  
  public enum Layout {
    public static let maxContentWidth: CGFloat = 600
    public static let cardMinHeight: CGFloat = 120
    public static let buttonMinHeight: CGFloat = 44
    public static let textFieldMinHeight: CGFloat = 44
  }
}

// MARK: - Shadow Style

public struct ShadowStyle {
  public let color: Color
  public let radius: CGFloat
  public let x: CGFloat
  public let y: CGFloat
  
  public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
    self.color = color
    self.radius = radius
    self.x = x
    self.y = y
  }
}

// MARK: - View Extensions

public extension View {
  /// Applies a shadow style to the view
  func shadow(_ style: ShadowStyle) -> some View {
    self.shadow(
      color: style.color,
      radius: style.radius,
      x: style.x,
      y: style.y
    )
  }
}
