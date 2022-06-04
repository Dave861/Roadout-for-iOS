//
//  HelpCenterProblems.swift
//  Roadout
//
//  Created by David Retegan on 28.05.2022.
//

import Foundation

class HelpCenterProblem {
    
    var title: String
    var solution: String
    var image: String
    var tag: String
    var phoneNumber: String
    var email: String
    var cardType: ProblemCardTypes
    var sectionImage = "-"
    
    public init(title: String, solution: String, image: String, tag: String, phoneNumber: String, email: String, cardType: ProblemCardTypes) {
        self.title = title
        self.image = image
        self.tag = tag
        self.phoneNumber = phoneNumber
        self.cardType = cardType
        self.email = email
        self.solution = solution.replacingOccurrences(of: "PHONE-NUMBER", with: phoneNumber)
        self.solution = self.solution.replacingOccurrences(of: "EMAIL", with: email)
    }
    
    private func convertSpotIDToReadable(spotID: String) -> String {
        return "Spot " + EntityManager.sharedInstance.decodeSpotID(spotID)[2] + " - Section " + EntityManager.sharedInstance.decodeSpotID(spotID)[1] + " - " + EntityManager.sharedInstance.decodeSpotID(spotID)[0]
    }
    
    func fillOutSpotInformation() {
        self.solution = self.solution.replacingOccurrences(of: "SPOT-ID", with: convertSpotIDToReadable(spotID: selectedSpotID))
        self.sectionImage = "Cluj." + EntityManager.sharedInstance.decodeSpotID(selectedSpotID)[0].replacingOccurrences(of: " ", with: "") + ".SectionMarked"
    }
     
}

enum ProblemCardTypes {
    case fullColor
    case noColor
    case colorUp
    case colorDown
}

class ProblemManager {
    
    static let sharedInstance = ProblemManager()
    
    let problem1 = HelpCenterProblem(title: "Someone or something is blocking my spot", solution: "We are really sorry for the inconvenience, first of all start by making sure it is indeed your spot, check within your chosen Maps app that you are in the correct section, then look around to see if there are any other Roadout Barriers up there and check if those aren’t actually your spot. Finally, if you are sure that it is indeed your spot that is being blocked, take a photo of the spot being blocked, along with our barrier and do not hesitate to contact the parking location administration at the number PHONE-NUMBER. Just make sure the photos are clear and there is a clear picture of our device with all the text on it visible. If it is concluded that your spot was indeed blocked, the person blocking you will be fined and we will fully refund your reservation. The Roadout Team is really sorry for this inconvenience and hope the unfortunate experience today won’t stop you from using our product again another time, if the issue is not resolved within 72 business hours please email us at EMAIL with the subject ‘My spot was blocked’ and the images you took, we will make sure your money are refunded.", image: "ProblemImage1", tag: "PROBLEM", phoneNumber: "0761-273-456", email: "problems@roadout.ro", cardType: .colorUp)
    
    let problem2 = HelpCenterProblem(title: "Time isn’t over but someone occupied my spot", solution: "The Roadout Team is incredibly sorry for this unfortunate situation, this shouldn’t have happened normally. Please start by making sure it is indeed your spot, check within your chosen Maps app that you are in the correct section, then look around to see if there are any other Roadout Barriers up there and check if those aren’t actually your spot. Finally, if you are sure that it is indeed your spot that is being occupied please take photos of the spot and email us at EMAIL with the subject ‘Someone occupied my spot’, attach the before mentioned images along with your name, user name, email, spot you reserved (Park Location - Section - Spot Number) and approximate date at which you made the reservation. We are really sorry for the inconvenient experience today and hope it won’t stop you from using our product again another time, if it is concluded your spot was really occupied, we will fully refund you within 72 business hours.", image: "ProblemImage2", tag: "PROBLEM", phoneNumber: "", email: "problems@roadout.ro", cardType: .noColor)
    
    let problem3 = HelpCenterProblem(title: "I can’t find my spot", solution: "First of all, don’t worry, we will guide you through the process of locating a spot and at the end you will, in 99% of situations, have found your spot. You have reserved SPOT-ID, below is an image with the sections in this parking location, cross check with your chosen Maps app that you are in the correct section, then look around for any Roadout barriers, chances are, if you see a locked barrier, it is yours. Alternatively, if your phone supports it, you can Open in AR and see in the real world an overlay pointing you to the spot. There is also on every Roadout Barrier marked its respective spot number, you can use that to identify your spot if you aren’t in a time crunch. We are constantly working to improve our service, if you have any feedback for us please reach at EMAIL.", image: "ProblemImage3", tag: "HELP", phoneNumber: "", email: "feedback@roadout.ro", cardType: .fullColor)
    
    let problem4 = HelpCenterProblem(title: "Barrier was down but I didn’t unlock it", solution: "This shouldn’t have happened normally, before taking any action please verify if it is actually your spot. Check within your chosen Maps app that you are in the correct section, then look around to see if there are any other Roadout Barriers up there and check if those aren’t actually your spot. After you conclude it really is your spot that had the barrier down before time was supposed to run out, check your email to see on which devices you are logged in and see if there was any suspicious activity on your account. In case there was no suspicious activity, please take a picture of the device with the barrier down and email it to EMAIL with the subject ‘Barrier down before time’ along with the exact time you took the picture at, our team will resolve the case within 72 business hours and if there was a problem on our behalf you will be refunded half the reservation. Thank you for your patience and we hope this situation today won’t stop from using Roadout again at a later date, we are constantly learning and improving and hope to have been useful today.", image: "ProblemImage4", tag: "SUPPORT", phoneNumber: "", email: "problems@roadout.ro", cardType: .colorDown)
    
    
}
