//
//  LottieView.swift
//  NoGankMac
//
//  Created by Alan Yan on 2020-08-21.
//

import SwiftUI
import Lottie
struct LottieViewRepeated: NSViewRepresentable {
    typealias NSViewType = NSView
    var filename: String
    var loopMode: LottieLoopMode
    var speed: CGFloat = 1

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        let animationView = AnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = speed
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        for subview in nsView.subviews {
            if let animationView = subview as? AnimationView {
                animationView.stop()
                animationView.animation = Animation.named(filename)
                animationView.play()
            }
        }
    }
}


struct LottieViewKeyframed: NSViewRepresentable {
    typealias NSViewType = NSView
    var filename: String
    var loopingSectionFrames: (AnimationFrameTime, AnimationFrameTime)
    var isConcludedLoopingFrames: (AnimationFrameTime, AnimationFrameTime)
    @Binding var isUp: Bool
    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        let animationView = AnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        for subview in nsView.subviews {
            if let animationView = subview as? AnimationView {
                animationView.stop()
                animationView.play(fromFrame: isUp ? loopingSectionFrames.0 : loopingSectionFrames.1, toFrame: isUp ? loopingSectionFrames.1 : loopingSectionFrames.0, loopMode: .none) { (_) in
//                    if !isUp {
//                        animationView.play(fromFrame: isConcludedLoopingFrames.0, toFrame: isConcludedLoopingFrames.1, loopMode: .autoReverse, completion: nil)
//                    }
                }
            }
        }
    }
}

