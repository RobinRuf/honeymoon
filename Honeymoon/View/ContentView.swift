//
//  ContentView.swift
//  Honeymoon
//
//  Created by Robin Ruf on 25.03.21.
//

import SwiftUI

struct ContentView: View {
    
    @State var showBookingAlert: Bool = false
    @State var showGuideView: Bool = false
    @State var showInfoView: Bool = false
    @GestureState private var dragState = DragState.inactiv
    private var dragAreaThreshold: CGFloat = 65.0
    @State var lastCardIndex: Int = 1
    
    // MARK: - CARD VIEWS
    @State var cardViews: [CardView] = {
        var views = [CardView]()
        for index in 0..<2 {
            views.append(CardView(honeymoon: honeymoonData[index]))
        }
        return views
    }()
    
    // MARK: - MOVE CARDS
    private func moveCards() {
        cardViews.removeFirst()
        
        self.lastCardIndex += 1
        
        let honeymoon = honeymoonData[lastCardIndex % honeymoonData.count]
        
        let newCardView = CardView(honeymoon: honeymoon)
        
        cardViews.append(newCardView)
    }
    
    // MARK: - TOP CARD
    private func isTopCrad(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }
        return index == 0
    }
    
    // MARK: - DRAG STATE
    enum DragState {
        case inactiv
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactiv, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .dragging:
                return true
            case .pressing, .inactiv:
                return false
            }
        }
        
        var isPressing: Bool {
            switch self {
            case .pressing, .dragging:
                return true
            case .inactiv:
                return false
            }
        }
    }
    
    var body: some View {
        VStack {
            // MARK: - HEADER
            HeaderView(showGuideView: $showGuideView, showInfoView: $showInfoView)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
            
            Spacer()
            
            // MARK: - CARDS
            ZStack {
                ForEach(cardViews) { cardView in
                    cardView
                        .zIndex(self.isTopCrad(cardView: cardView) ? 1 : 0)
                        // Overlay Image
                        .overlay(
                            ZStack {
                                // X-Mark Symbol
                                Image(systemName: "x.circle")
                                    .modifier(SymbolModifier())
                                    .opacity(self.dragState.translation.width < -self.dragAreaThreshold && self.isTopCrad(cardView: cardView) ? 1.0 : 0.0)
                                
                                // Heart Symbol
                                Image(systemName: "heart.circle")
                                    .modifier(SymbolModifier())
                                    .opacity(self.dragState.translation.width > self.dragAreaThreshold && self.isTopCrad(cardView: cardView) ? 1.0 : 0.0)
                            }
                        )
                        .offset(x: self.isTopCrad(cardView: cardView) ? self.dragState.translation.width : 0, y: self.isTopCrad(cardView: cardView) ? self.dragState.translation.height : 0)
                        .scaleEffect(self.dragState.isDragging && self.isTopCrad(cardView: cardView) ? 0.9 : 1.0)
                        .rotationEffect(Angle(degrees: self.isTopCrad(cardView: cardView) ? Double(self.dragState.translation.width / 12) : 0))
                        .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                        .sequenced(before: DragGesture())
                        .updating(self.$dragState, body: { (value, state, transaction) in
                            switch value {
                            case .first(true):
                                state = .pressing
                            case .second(true, let drag):
                                state = .dragging(translation: drag?.translation ?? .zero)
                            default:
                                break
                            }
                        })
                                    .onEnded({ (value) in
                                        guard case .second(true, let drag?) = value else {
                                            return
                                        }
                                        
                                        if drag.translation.width < -self.dragAreaThreshold || drag.translation.width > self.dragAreaThreshold {
                                            self.moveCards()
                                        }
                                    })
                    )
                }
            }
            .padding(.horizontal)
            
            
            Spacer()
            
            // MARK: - FOOTER
            FooterView(showBookingAlert: $showBookingAlert)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
        }
        .alert(isPresented: $showBookingAlert, content: {
            Alert(title: Text("SUCCESS"), message: Text("Wishing a lovely and most precious of the times together for the amazing couple."), dismissButton: .default(Text("Happy Honeymoon")))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
