//
//  Extension.swift
//  VaporWithTestContainers
//
//  Created by Jose Manuel Lezcano Fresno on 29/04/2026.

import Testing

extension Tag {
    @Tag static var testContainers: Self
}


extension Tag {
    enum vapor_with_test_containers {}
}

extension Tag.vapor_with_test_containers {
    @Tag static var testContainers: Tag
}
