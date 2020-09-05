//
//  CardView.swift
//  Feasty
//
//  Created by Bill Li on 8/26/20.
//  Copyright © 2020 Bill Li. All rights reserved.
//
// code used from https://medium.com/better-programming/swiftui-create-a-tinder-style-swipeable-card-view-283e257cb102


import SwiftUI

struct CardView: View {
    @State private var translation: CGSize = .zero
    
    // 1
    private var user: User
    private var onRemove: (_ user: User) -> Void
    
    // 2
    private var thresholdPercentage: CGFloat = 0.5 // when the user has draged 50% the width of the screen in either direction
    
    // 3
    init(user: User, onRemove: @escaping (_ user: User) -> Void) {
        self.user = user
        self.onRemove = onRemove
    }
    
    // 4
    /// What percentage of our own width have we swipped
    /// - Parameters:
    ///   - geometry: The geometry
    ///   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var body: some View {
        GeometryReader { geometry in
                        
            VStack(alignment: .leading) {
                
                Image(self.user.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                .clipped()
                
                HStack {
                        // 5
                        VStack(alignment: .leading, spacing: 6) {
                            Text("\(self.user.firstName) \(self.user.lastName), \(self.user.age)")
                                .font(.title)
                                .bold()
                            Text(self.user.occupation)
                                .font(.subheadline)
                                .bold()
                            Text("\(self.user.mutualFriends) Mutual Friends")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
            // Add padding, corner radius and shadow with blur radius
            // also gesture
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0) // forces offset to only left and right motion
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                // 3
                DragGesture()
                    // 4
                    .onChanged { value in
                        self.translation = value.translation
                    }.onEnded { value in
                        // 6
                        // determine snap distance > 0.5 aka half the width of the screen
                        if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                            self.onRemove(self.user)
                        } else {
                            self.translation = .zero
                        }
                    }
            )
        }
    }
}

// 4
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(user: User(id: 1, firstName: "Mark", lastName: "Bennett", age: 27, mutualFriends: 0, imageName: "person_1", occupation: "Insurance Agent"),
                 onRemove: { _ in
                    // do nothing
            })
            .frame(height: 400)
            .padding()
    }
}

