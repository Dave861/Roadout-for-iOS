//
//  GDMStructs.swift
//  Roadout
//
//  Created by David Retegan on 22.04.2022.
//

import Foundation

struct GDMResponse: Decodable {

    public let destinationAddresses : [String]!
    public let originAddresses : [String]!
    public let rows : [GDMRow]!
    public let status : String!

}
struct GDMElement: Decodable {

    public let distance : GDMVariable!
    public let duration : GDMVariable!
    public let duration_in_traffic : GDMVariable!
    public let status : String!

}
struct GDMRow: Decodable {

    public let elements : [GDMElement]!

}
struct GDMVariable: Decodable {

    public let text : String!
    public let value : Int!

}
