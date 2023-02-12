//
//  Blog.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/11.
//

import UIKit


enum Blog: CaseIterable {
  case aLookBackOnJanuary
  case unsplashCensus2023
  case howToCaptureAuthenticEmotion
  case meetTheUnsplashTeamNicoleSimmen
  case reachingNewPerspectivesInDronePhotography
  case oneYearWith3DRenders
  case aLookBackOnOctober
  case aLookBackOnSeptember
  case aLookBackOnAugust
  case aLookBackOnJuly
  case documentingLifesMomentsOnCamera
  case meetSusanWilkinson
  case aLookBackOnJune
  case meetTheUnsplashTeamTimeCarbone
  case meetAmyShamblen

  // MARK: - Properties

  var image: UIImage? {
    switch self {
    case .aLookBackOnJanuary:
      return .init(named: "a_lookback_on_january.jpeg")
    case .unsplashCensus2023:
      return .init(named: "unsplash_census_2023.jpeg")
    case .howToCaptureAuthenticEmotion:
      return .init(named: "how_to_capture_authentic_emotion.jpeg")
    case .meetTheUnsplashTeamNicoleSimmen:
      return .init(named: "meet_the_unsplash_team_nicole.jpeg")
    case .reachingNewPerspectivesInDronePhotography:
      return .init(named: "reaching_new_perspectives_in_drone_photography.png")
    case .oneYearWith3DRenders:
      return .init(named: "one_year_with_3d_renders.jpeg")
    case .aLookBackOnOctober:
      return .init(named: "a_look_back_on_october.jpeg")
    case .aLookBackOnSeptember:
      return .init(named: "a_look_back_on_september.jpeg")
    case .aLookBackOnAugust:
      return .init(named: "a_look_back_on_august.jpeg")
    case .aLookBackOnJuly:
      return .init(named: "a_look_back_on_july.jpeg")
    case .documentingLifesMomentsOnCamera:
      return .init(named: "documenting_lifes_moments_on_camera.jpeg")
    case .meetSusanWilkinson:
      return .init(named: "meet_susan_wilkinson.jpeg")
    case .aLookBackOnJune:
      return .init(named: "a_look_back_on_june.jpeg")
    case .meetTheUnsplashTeamTimeCarbone:
      return .init(named: "meet_the_unsplash_team_tim.jpeg")
    case .meetAmyShamblen:
      return .init(named: "meet_amy_shamblen.jpeg")
    }
  }

  var title: String {
    switch self {
    case .aLookBackOnJanuary:
      return "A look back on January"
    case .unsplashCensus2023:
      return "Unsplash Census 2023"
    case .howToCaptureAuthenticEmotion:
      return "How to Capture Authentic Emotion"
    case .meetTheUnsplashTeamNicoleSimmen:
      return "Meet the Unsplash team: Nicole Simmen"
    case .reachingNewPerspectivesInDronePhotography:
      return "Reaching new perspectives in drone photography"
    case .oneYearWith3DRenders:
      return "One year with 3D renders"
    case .aLookBackOnOctober:
      return "A look back on October"
    case .aLookBackOnSeptember:
      return "A look back on September"
    case .aLookBackOnAugust:
      return "A look back on August"
    case .aLookBackOnJuly:
      return "A look back on July"
    case .documentingLifesMomentsOnCamera:
      return "Documenting life’s moments on camera"
    case .meetSusanWilkinson:
      return "Meet Susan Wilkinson"
    case .aLookBackOnJune:
      return "A look back on June"
    case .meetTheUnsplashTeamTimeCarbone:
      return "Meet the Unsplash Team: Tim Carbone"
    case .meetAmyShamblen:
      return "Meet Amy Shamblen"
    }
  }

  var writer: String {
    switch self {
    case .aLookBackOnJanuary:
      return "Natalie Brennan"
    case .unsplashCensus2023:
      return "Natalie Brennan"
    case .howToCaptureAuthenticEmotion:
      return "Alex"
    case .meetTheUnsplashTeamNicoleSimmen:
      return "Natalie Brennan"
    case .reachingNewPerspectivesInDronePhotography:
      return "Alex Begin"
    case .oneYearWith3DRenders:
      return "Alex Begin"
    case .aLookBackOnOctober:
      return "Natalie Brennan"
    case .aLookBackOnSeptember:
      return "Natalie Brennan"
    case .aLookBackOnAugust:
      return "Natalie Brennan"
    case .aLookBackOnJuly:
      return "Natalie Brennan"
    case .documentingLifesMomentsOnCamera:
      return "Alex Begin"
    case .meetSusanWilkinson:
      return "Alex Begin"
    case .aLookBackOnJune:
      return "Natalie Brennan"
    case .meetTheUnsplashTeamTimeCarbone:
      return "Alex Begin"
    case .meetAmyShamblen:
      return "Alex Begin"
    }
  }

  var url: URL {
    switch self {
    case .aLookBackOnJanuary:
      return .init(string: "https://unsplash.com/blog/a-lookback-on-january/")!
    case .unsplashCensus2023:
      return .init(string: "https://unsplash.com/blog/2023-census/")!
    case .howToCaptureAuthenticEmotion:
      return .init(string: "https://unsplash.com/blog/how-to-capture-authentic-emotion/")!
    case .meetTheUnsplashTeamNicoleSimmen:
      return .init(string: "https://unsplash.com/blog/meet-the-unplash-team-nicole/")!
    case .reachingNewPerspectivesInDronePhotography:
      return .init(string: "https://unsplash.com/blog/reaching-new-perspectives-in-drone-photography/")!
    case .oneYearWith3DRenders:
      return .init(string: "https://unsplash.com/blog/one-year-with-3d/")!
    case .aLookBackOnOctober:
      return .init(string: "https://unsplash.com/blog/look-back-on-october/")!
    case .aLookBackOnSeptember:
      return .init(string: "https://unsplash.com/blog/a-look-back-on-september/")!
    case .aLookBackOnAugust:
      return .init(string: "https://unsplash.com/blog/a-look-back-on-august/")!
    case .aLookBackOnJuly:
      return .init(string: "https://unsplash.com/blog/a-look-back-on-july/")!
    case .documentingLifesMomentsOnCamera:
      return .init(string: "https://unsplash.com/blog/documenting-lifes-moments-on-camera/")!
    case .meetSusanWilkinson:
      return .init(string: "https://unsplash.com/blog/meet-susan-wilkinson/")!
    case .aLookBackOnJune:
      return .init(string: "https://unsplash.com/blog/a-look-back-on-june/")!
    case .meetTheUnsplashTeamTimeCarbone:
      return .init(string: "https://unsplash.com/blog/meet-the-unsplash-team-tim/")!
    case .meetAmyShamblen:
      return .init(string: "https://unsplash.com/blog/meet-amy-shamblen/")!
    }
  }
}
