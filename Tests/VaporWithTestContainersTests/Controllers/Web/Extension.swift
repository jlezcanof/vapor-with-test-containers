//
//  Extension.swift
//  VaporWithTestContainers
//
//  Created by Jose Manuel Lezcano Fresno on 29/04/2026.

import Testing

extension Tag {
    @Tag static var testContainers: Self//docker
    @Tag static var appleContainers: Self

}


extension Tag {
    enum vapor_with_test_containers {}
}

extension Tag.vapor_with_test_containers {
    @Tag static var testContainers: Tag
    @Tag static var appleContainers: Tag

}
