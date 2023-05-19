//
//  Coordinator.swift
//  MovieDB_App
//
//  Created by Rafal Korzynski on 17/05/2023.
//


protocol Coordinator {
    func start()
    func navigate(to destination: Destination, animated: Bool, completion: @escaping () -> Void)
}

extension Coordinator {
    
    func navigate(to destination: Destination) {
        navigate(to: destination, animated: true) { }
    }
}
