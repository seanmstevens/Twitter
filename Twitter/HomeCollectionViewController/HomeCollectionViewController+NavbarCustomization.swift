//
//  HomeCollectionViewController+NavbarCustomization.swift
//  Twitter
//
//  Created by Sean Stevens on 3/17/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

extension HomeCollectionViewController {
    func configureNavbarAppearance() {
        let navbarStandardAppearance = UINavigationBarAppearance()
        let navbarScrollEdgeAppearance = UINavigationBarAppearance()
        let navbar = navigationController?.navigationBar
        
        // Configuration for standard appearance (when content is being scrolled)
        navbarStandardAppearance.configureWithDefaultBackground()
        navbarStandardAppearance.backgroundColor = UIColor(hue: 206/360, saturation: 1.0, brightness: 0.93, alpha: 0.6)
        navbarStandardAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        navbarStandardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navbarStandardAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Configuration for scroll edge appearance (when content has not been scrolled)
        navbarScrollEdgeAppearance.configureWithOpaqueBackground()
        navbarScrollEdgeAppearance.backgroundColor = .twitterBlue
        navbarScrollEdgeAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navbarScrollEdgeAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navbar?.standardAppearance = navbarStandardAppearance
        navbar?.scrollEdgeAppearance = navbarScrollEdgeAppearance
        navbar?.prefersLargeTitles = true
        navbar?.tintColor = UIColor.white
    }
}
