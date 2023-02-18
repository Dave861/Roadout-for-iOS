//
//  GDMStructs.swift
//  Roadout
//
//  Created by David Retegan on 22.04.2022.
//

import Foundation

struct GDMResponse: Decodable {

    let destinationAddresses: [String]!
    let originAddresses: [String]!
    let rows: [GDMRow]!
    let status: String!
}

struct GDMElement: Decodable {

    let distance: GDMVariable!
    let duration: GDMVariable!
    let duration_in_traffic: GDMVariable!
    let status: String!
}

struct GDMRow: Decodable {

    let elements: [GDMElement]!
}

struct GDMVariable: Decodable {

    let text: String!
    let value: Int!
}
