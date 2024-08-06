//
//  PriorityView.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/4/24.
//

// https://gist.github.com/StewartLynch/03372c873fef568e0a613a968adbae69

import SwiftUI

/// A view of inline images that represents a rating.
/// Tapping on an image will change it from an unfilled to a filled version of the image.
///
/// The following example shows a Ratings view with a maximum rating of 10 red flags, each with a width of 20:
///
///     PriorityView(maxPriority: 10,
///              currentPriority: $currentPriority,
///              width: 20,
///              color: .red,
///              ratingImage: .flag)
///
///
public struct PriorityView: View {
    var maxPriority: Int
    @Binding var currentPriority: Int?
    var width:Int
    var color: UIColor
    var sfSymbol: String
    
    /// Only two required parameters are maxPriority and the binding to currentPriority.  All other parameters have default values
    /// - Parameters:
    ///   - maxPriority: The maximum rating on the scale
    ///   - currentPriority: A binding to the current rating variable
    ///   - width: The width of the image used for the rating  (Default - 20)
    ///   - color: The color of the image ( (Default - systemYellow)
    ///   - sfSymbol: A String representing an SFImage that has a fill variabnt (Default -  "star")
    ///
    public init(maxPriority: Int, currentPriority: Binding<Int?>, width: Int = 25, color: UIColor = .systemOrange, sfSymbol: String = "bell") {
        self.maxPriority = maxPriority
        self._currentPriority = currentPriority
        self.width = width
        self.color = color
        self.sfSymbol = sfSymbol
    }

    public var body: some View {
        HStack {
                Image(systemName: sfSymbol)
                    .resizable()
                    .scaledToFit()
                    .symbolVariant(.slash)
                    .foregroundStyle(Color(color))
                    .onTapGesture {
                        withAnimation{
                            currentPriority = nil
                        }
                    }
                    .opacity(currentPriority == 0 ? 0 : 1)
            ForEach(0...maxPriority, id: \.self) { priority in
               Image(systemName: sfSymbol)
                    .resizable()
                    .scaledToFit()
                    .fillImage(correctImage(for: priority))
                    .foregroundStyle(Color(color))
                    .onTapGesture {
                        withAnimation{
                            currentPriority = priority + 1
                        }
                    }
            }
        }.frame(width: CGFloat(maxPriority * width))
    }
    
    func correctImage(for rating: Int) -> Bool {
        if let currentPriority, rating < currentPriority {
            return true
        } else {
            return false
        }
    }
}

struct FillImage: ViewModifier {
    let fill: Bool
    func body(content: Content) -> some View {
        if fill {
            content
                .symbolVariant(.fill)
        } else {
            content
        }
    }
}

extension View {
    func fillImage(_ fill: Bool) -> some View {
        modifier(FillImage(fill: fill))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var currentPriority: Int? = 0
        
        var body: some View {
            PriorityView(
                maxPriority: 4,
                currentPriority: $currentPriority,
                width: 40,
                color: .systemRed,
                sfSymbol: "bell"
            )
        }
    }
    return PreviewWrapper()
}

