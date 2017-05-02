//
//  timer.swift
//  iOSFinal
//
//  Created by Kameron Haramoto on 5/1/17.
//  Copyright © 2017 Kameron Haramoto. All rights reserved.
//

import Foundation

class MyTimer {
    var initial: Int
    var current: Int
    var running: Bool
    
    init (initial: Int) {
        self.initial = initial
        self.current = initial
        self.running = false
    }
    
    func start () {
        self.running = true
    }
    
    func stop () {
        self.running = false
    }
    
    func reset () {
        self.current = self.initial
    }
    
    // Decrements timer if running; returns true if time's up
    func decrement () -> Bool {
        if (self.running) {
            current = current - 1
            if (current == 0) {
                self.running = false
                return true
            }
        }
        return false
    }
}
