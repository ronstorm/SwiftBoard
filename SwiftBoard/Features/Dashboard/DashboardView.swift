//  DashboardView.swift
//  SwiftBoard
//
//  Created by Amit Sen on 09/11/2025.
//  © 2025 Coding With Amit. All rights reserved.

import SwiftUI

public struct DashboardView: View {
  @State private var store = Store(
    initialState: DashboardState(),
    reducer: DashboardReducer(),
    dependencies: .live
  )
  
  public init() {}
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      VStack(spacing: 0) {
        // Header
        HStack {
          Text("SwiftBoard")
            .font(DesignTokens.Typography.title2)
            .foregroundColor(DesignTokens.Colors.onBackground)
          
          Spacer()
          
          HStack(spacing: DesignTokens.Spacing.sm) {
            // Profile avatar
            Circle()
              .fill(DesignTokens.Colors.primary)
              .frame(width: 32, height: 32)
              .overlay(
                Image(systemName: "person.fill")
                  .foregroundColor(DesignTokens.Colors.onPrimary)
                  .font(.system(size: 16))
              )
            
            // Settings icon
            Button(action: {}) {
              Image(systemName: "gearshape.fill")
                .foregroundColor(DesignTokens.Colors.onBackground)
                .font(.system(size: 20))
            }
          }
        }
        .padding(.horizontal, DesignTokens.Spacing.lg)
        .padding(.top, DesignTokens.Spacing.sm)
        .padding(.bottom, DesignTokens.Spacing.lg)
        
        // Content
        ScrollView {
          VStack(spacing: DesignTokens.Spacing.lg) {
            ProfileCard(profile: viewStore.state.profile)
            TasksCard(tasks: viewStore.state.tasks)
            ActivityCard(events: viewStore.state.activity)
          }
          .padding(.horizontal, DesignTokens.Spacing.lg)
          .padding(.bottom, DesignTokens.Spacing.xl)
        }
      }
      .background(DesignTokens.Colors.background)
      .onAppear { viewStore.send(.onAppear) }
      .refreshable { viewStore.send(.pullToRefresh) }
      .overlay(alignment: .top) {
        if let message = viewStore.state.errorBanner {
          Text(message)
            .font(DesignTokens.Typography.footnote)
            .foregroundColor(DesignTokens.Colors.onError)
            .padding(8)
            .background(DesignTokens.Colors.error)
            .cornerRadius(8)
            .padding()
            .onTapGesture { viewStore.send(.dismissBanner) }
            .accessibilityLabel("Error: \(message)")
        }
      }
    }
  }
}

public struct ProfileCard: View {
  let profile: ProfileVM?
  
  private var greeting: String {
    let hour = Calendar.current.component(.hour, from: Date())
    switch hour {
    case 5..<12: return "Good morning"
    case 12..<17: return "Good afternoon"
    case 17..<22: return "Good evening"
    default: return "Good night"
    }
  }
  
  public var body: some View {
    HStack(spacing: DesignTokens.Spacing.md) {
      // Large profile avatar
      Circle()
        .fill(DesignTokens.Colors.primary)
        .frame(width: 60, height: 60)
        .overlay(
          Image(systemName: "person.fill")
            .foregroundColor(DesignTokens.Colors.onPrimary)
            .font(.system(size: 24))
        )
      
      VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
        if let p = profile {
          Text("\(greeting), \(p.name)!")
            .font(DesignTokens.Typography.title2)
            .foregroundColor(DesignTokens.Colors.onSurface)
          
          if let last = p.lastLogin {
            Text("Last login: \(formatLastLogin(last))")
              .font(DesignTokens.Typography.footnote)
              .foregroundColor(DesignTokens.Colors.onSurfaceVariant)
          }
        } else {
          Text("\(greeting)!")
            .font(DesignTokens.Typography.title2)
            .foregroundColor(DesignTokens.Colors.onSurface)
          
          Text("No user signed in")
            .font(DesignTokens.Typography.footnote)
            .foregroundColor(DesignTokens.Colors.onSurfaceVariant)
        }
      }
      
      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(DesignTokens.Spacing.lg)
    .background(DesignTokens.Colors.surface)
    .cornerRadius(DesignTokens.Radius.lg)
    .shadow(DesignTokens.Shadow.small)
    .accessibilityElement(children: .combine)
    .accessibilityLabel("Profile card")
  }
  
  private func formatLastLogin(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE 'at' h:mm a"
    return formatter.string(from: date)
  }
}

public struct TasksCard: View {
  let tasks: [Task]
  
  public var body: some View {
    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
      // Header with title and "See All" link
      HStack {
        Text("My Tasks")
          .font(DesignTokens.Typography.title3)
          .foregroundColor(DesignTokens.Colors.onSurface)
        
        Spacer()
        
        Button("See All") {
          // TODO: Navigate to full tasks list
        }
        .font(DesignTokens.Typography.footnote)
        .foregroundColor(DesignTokens.Colors.primary)
      }
      
      // Tasks list
      VStack(spacing: DesignTokens.Spacing.sm) {
        ForEach(tasks.prefix(5), id: \.id) { task in
          HStack(spacing: DesignTokens.Spacing.sm) {
            Button(action: {
              // TODO: Toggle task completion
            }) {
              Image(systemName: task.done ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.done ? DesignTokens.Colors.success : DesignTokens.Colors.outline)
                .font(.system(size: 20))
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(task.title ?? "")
              .font(DesignTokens.Typography.body)
              .foregroundColor(task.done ? DesignTokens.Colors.onSurfaceVariant : DesignTokens.Colors.onSurface)
              .strikethrough(task.done)
            
            Spacer()
          }
          .accessibilityElement(children: .combine)
          .accessibilityLabel("Task: \(task.title ?? ""), \(task.done ? "completed" : "pending")")
        }
        
        if tasks.isEmpty {
          Text("No tasks yet")
            .font(DesignTokens.Typography.body)
            .foregroundColor(DesignTokens.Colors.onSurfaceVariant)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, DesignTokens.Spacing.md)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(DesignTokens.Spacing.lg)
    .background(DesignTokens.Colors.surface)
    .cornerRadius(DesignTokens.Radius.lg)
    .shadow(DesignTokens.Shadow.small)
    .accessibilityLabel("Tasks card")
  }
}

public struct ActivityCard: View {
  let events: [ActivityEvent]
  
  public var body: some View {
    VStack(alignment: .leading, spacing: DesignTokens.Spacing.md) {
      // Header with title and "See All" link
      HStack {
        Text("Recent Activity")
          .font(DesignTokens.Typography.title3)
          .foregroundColor(DesignTokens.Colors.onSurface)
        
        Spacer()
        
        Button("See All") {
          // TODO: Navigate to full activity list
        }
        .font(DesignTokens.Typography.footnote)
        .foregroundColor(DesignTokens.Colors.primary)
      }
      
      // Activity list
      VStack(spacing: DesignTokens.Spacing.sm) {
        ForEach(events.prefix(5), id: \.id) { event in
          HStack(spacing: DesignTokens.Spacing.sm) {
            // Activity icon
            Circle()
              .fill(iconColor(for: event))
              .frame(width: 32, height: 32)
              .overlay(
                Image(systemName: iconName(for: event))
                  .foregroundColor(.white)
                  .font(.system(size: 14, weight: .medium))
              )
            
            VStack(alignment: .leading, spacing: 2) {
              Text(event.title ?? "")
                .font(DesignTokens.Typography.body)
                .foregroundColor(DesignTokens.Colors.onSurface)
                .lineLimit(2)
              
              Text(formatTimestamp(event.createdAt))
                .font(DesignTokens.Typography.footnote)
                .foregroundColor(DesignTokens.Colors.onSurfaceVariant)
            }
            
            Spacer()
          }
          .accessibilityElement(children: .combine)
          .accessibilityLabel("Activity: \(event.title ?? "")")
        }
        
        if events.isEmpty {
          Text("No recent activity")
            .font(DesignTokens.Typography.body)
            .foregroundColor(DesignTokens.Colors.onSurfaceVariant)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, DesignTokens.Spacing.md)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(DesignTokens.Spacing.lg)
    .background(DesignTokens.Colors.surface)
    .cornerRadius(DesignTokens.Radius.lg)
    .shadow(DesignTokens.Shadow.small)
    .accessibilityLabel("Activity card")
  }
  
  private func iconName(for event: ActivityEvent) -> String {
    let title = event.title?.lowercased() ?? ""
    if title.contains("completed") || title.contains("task") {
      return "checkmark"
    } else if title.contains("created") || title.contains("new") {
      return "plus"
    } else if title.contains("comment") || title.contains("message") {
      return "message"
    } else if title.contains("uploaded") || title.contains("document") {
      return "doc"
    } else {
      return "circle"
    }
  }
  
  private func iconColor(for event: ActivityEvent) -> Color {
    let title = event.title?.lowercased() ?? ""
    if title.contains("completed") || title.contains("task") {
      return DesignTokens.Colors.success
    } else if title.contains("created") || title.contains("new") {
      return DesignTokens.Colors.primary
    } else if title.contains("comment") || title.contains("message") {
      return DesignTokens.Colors.outline
    } else if title.contains("uploaded") || title.contains("document") {
      return DesignTokens.Colors.primary
    } else {
      return DesignTokens.Colors.outline
    }
  }
  
  private func formatTimestamp(_ date: Date?) -> String {
    guard let date = date else { return "Unknown time" }
    
    let now = Date()
    let timeInterval = now.timeIntervalSince(date)
    
    if timeInterval < 3600 { // Less than 1 hour
      let minutes = Int(timeInterval / 60)
      return minutes <= 1 ? "Just now" : "\(minutes) minutes ago"
    } else if timeInterval < 86400 { // Less than 1 day
      let hours = Int(timeInterval / 3600)
      return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
    } else if timeInterval < 172800 { // Less than 2 days
      return "Yesterday"
    } else {
      let days = Int(timeInterval / 86400)
      return days == 1 ? "1 day ago" : "\(days) days ago"
    }
  }
}

#Preview {
  DashboardView()
}


