//
//  AsynchronousOperation.swift
//  GitHub-Sample
//
//  Created by Alan Temirov on 30.03.2022.
//

import Foundation

class AsynchronousOperation: Operation {
    
    // MARK: - Internal properties
    
    enum State: String {
        case ready
        case executing
        case finished
        
        var key: String { "is\(rawValue.capitalized)" }
    }
    
    var state = State.ready {
        willSet {
            self.willChangeValue(forKey: newValue.key)
            self.willChangeValue(forKey: self.state.key)
        } didSet {
            self.didChangeValue(forKey: oldValue.key)
            self.didChangeValue(forKey: self.state.key)
        }
    }
    
    final override var isAsynchronous: Bool { true }
    override var isReady: Bool { super.isReady && self.state == .ready }
    override var isExecuting: Bool { self.state == .executing }
    override var isFinished: Bool { self.state == .finished }
    
    // MARK: - Overriden
    
    override func cancel() { state = .finished }
    
    final override func start() {
        guard !isCancelled else {
            self.state = .finished
            return
        }
        
        self.main()
        self.state = .executing
    }
}
