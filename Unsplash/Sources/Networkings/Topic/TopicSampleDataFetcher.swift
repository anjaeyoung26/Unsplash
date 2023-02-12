//
//  TopicSampleDataFetcher.swift
//  Unsplash
//
//  Created by 안재영 on 2023/01/02.
//

import Foundation
import Moya


final class TopicSampleDataFetcher: SampleDataFetcher {

  // MARK: - Methods

  static func fetch(target: TopicAPI) -> Data {
    switch target {
    case .list:
      return """
      [
        {
          "id": "bo8jQKTaE0Y",
          "slug": "wallpapers",
          "title": "Wallpapers",
          "description": "From epic drone shots to inspiring moments in nature, find free HD wallpapers worthy of your mobile and desktop screens. Finally.",
          "published_at": "2020-04-17T02:31:04Z",
          "updated_at": "2020-09-22T07:37:55-04:00",
          "starts_at": "2020-04-15T00:00:00Z",
          "ends_at": null,
          "only_submissions_after": null,
          "visibility": "featured",
          "featured": true,
          "total_photos": 5296,
          "links": {
            "self": "https://api.unsplash.com/topics/wallpapers",
            "html": "https://unsplash.com/t/wallpapers",
            "photos": "https://api.unsplash.com/topics/wallpapers/photos"
          },
          "status": "open",
          "owners": [
            {
              "id": "QV5S1rtoUJ0",
              "updated_at": "2020-09-22T10:49:58-04:00",
              "username": "unsplash",
              "name": "Unsplash",
              "first_name": "Unsplash",
              "last_name": null,
              "twitter_username": "unsplash",
              "portfolio_url": "https://unsplash.com",
              "bio": "Behind the scenes of the team building the internet’s open library of freely useable visuals.",
              "location": "Montreal, Canada",
              "links": {
                "self": "https://api.unsplash.com/users/unsplash",
                "html": "https://unsplash.com/@unsplash",
                "photos": "https://api.unsplash.com/users/unsplash/photos",
                "likes": "https://api.unsplash.com/users/unsplash/likes",
                "portfolio": "https://api.unsplash.com/users/unsplash/portfolio",
                "following": "https://api.unsplash.com/users/unsplash/following",
                "followers": "https://api.unsplash.com/users/unsplash/followers"
              },
              "profile_image": {
                "small": "https://images.unsplash.com/profile-1544707963613-16baf868f301?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32",
                "medium": "https://images.unsplash.com/profile-1544707963613-16baf868f301?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64",
                "large": "https://images.unsplash.com/profile-1544707963613-16baf868f301?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128"
              },
              "instagram_username": "unsplash",
              "total_collections": 22,
              "total_likes": 16720,
              "total_photos": 29,
              "accepted_tos": true
            }
          ],
          "current_user_contributions": [],
          "total_current_user_submissions": {},
          "cover_photo": {
            "id": "0q_YtRanczI",
            "created_at": "2018-10-26T03:24:18-04:00",
            "updated_at": "2020-06-21T01:10:35-04:00",
            "promoted_at": null,
            "width": 3992,
            "height": 2992,
            "color": "#CBCAC8",
            "blur_hash": "LEBpFJRk5TR+5toJ^ia#0KfPIoxY",
            "description": "Greek villa by the coast",
            "alt_description": "aerial view of city",
            "urls": {
              "raw": "https://images.unsplash.com/photo-1540538581514-1d465aaad58c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9",
              "full": "https://images.unsplash.com/photo-1540538581514-1d465aaad58c?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb&ixid=eyJhcHBfaWQiOjEyMDd9",
              "regular": "https://images.unsplash.com/photo-1540538581514-1d465aaad58c?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjEyMDd9",
              "small": "https://images.unsplash.com/photo-1540538581514-1d465aaad58c?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjEyMDd9",
              "thumb": "https://images.unsplash.com/photo-1540538581514-1d465aaad58c?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&ixid=eyJhcHBfaWQiOjEyMDd9"
            },
            "links": {
              "self": "https://api.unsplash.com/photos/0q_YtRanczI",
              "html": "https://unsplash.com/photos/0q_YtRanczI",
              "download": "https://unsplash.com/photos/0q_YtRanczI/download",
              "download_location": "https://api.unsplash.com/photos/0q_YtRanczI/download"
            },
            "user": {
              "id": "QV5S1rtoUJ0",
              "updated_at": "2020-09-22T10:49:58-04:00",
              "username": "unsplash",
              "name": "Unsplash",
              "first_name": "Unsplash",
              "last_name": null,
              "twitter_username": "unsplash",
              "portfolio_url": "https://unsplash.com",
              "bio": "Behind the scenes of the team building the internet’s open library of freely useable visuals.",
              "location": "Montreal, Canada",
              "links": {
                "self": "https://api.unsplash.com/users/unsplash",
                "html": "https://unsplash.com/@unsplash",
                "photos": "https://api.unsplash.com/users/unsplash/photos",
                "likes": "https://api.unsplash.com/users/unsplash/likes",
                "portfolio": "https://api.unsplash.com/users/unsplash/portfolio",
                "following": "https://api.unsplash.com/users/unsplash/following",
                "followers": "https://api.unsplash.com/users/unsplash/followers"
              },
              "profile_image": {
                "small": "https://images.unsplash.com/profile-1544707963613-16baf868f301?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32",
                "medium": "https://images.unsplash.com/profile-1544707963613-16baf868f301?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64",
                "large": "https://images.unsplash.com/profile-1544707963613-16baf868f301?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128"
              },
              "instagram_username": "unsplash",
              "total_collections": 22,
              "total_likes": 16720,
              "total_photos": 29,
              "accepted_tos": true
          },
          "preview_photos": [
            {
              "id": "8AceP6OOF3o",
              "created_at": "2017-05-28T09:48:24-04:00",
              "updated_at": "2020-09-22T09:45:00-04:00",
              "urls": {
                "raw": "https://images.unsplash.com/photo-1495978866932-92dbc079e62e?ixlib=rb-1.2.1",
                "full": "https://images.unsplash.com/photo-1495978866932-92dbc079e62e?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb",
                "regular": "https://images.unsplash.com/photo-1495978866932-92dbc079e62e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max",
                "small": "https://images.unsplash.com/photo-1495978866932-92dbc079e62e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                "thumb": "https://images.unsplash.com/photo-1495978866932-92dbc079e62e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max"
              }
            },
            {
              "id": "iHJOHaUD8RY",
              "created_at": "2016-11-13T04:50:11-05:00",
              "updated_at": "2020-09-22T09:31:58-04:00",
              "urls": {
                "raw": "https://images.unsplash.com/photo-1479030574009-1e48577746e8?ixlib=rb-1.2.1",
                "full": "https://images.unsplash.com/photo-1479030574009-1e48577746e8?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb",
                "regular": "https://images.unsplash.com/photo-1479030574009-1e48577746e8?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max",
                "small": "https://images.unsplash.com/photo-1479030574009-1e48577746e8?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                "thumb": "https://images.unsplash.com/photo-1479030574009-1e48577746e8?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max"
              }
            },
            {
              "id": "zMV7sqlJNow",
              "created_at": "2016-12-28T10:24:02-05:00",
              "updated_at": "2020-09-22T09:34:07-04:00",
              "urls": {
                "raw": "https://images.unsplash.com/photo-1482938289607-e9573fc25ebb?ixlib=rb-1.2.1",
                "full": "https://images.unsplash.com/photo-1482938289607-e9573fc25ebb?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb",
                "regular": "https://images.unsplash.com/photo-1482938289607-e9573fc25ebb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max",
                "small": "https://images.unsplash.com/photo-1482938289607-e9573fc25ebb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                "thumb": "https://images.unsplash.com/photo-1482938289607-e9573fc25ebb?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max"
              }
            },
            {
              "id": "YD1uvthZwg4",
              "created_at": "2015-12-03T17:39:24-05:00",
              "updated_at": "2020-09-22T09:10:19-04:00",
              "urls": {
                "raw": "https://images.unsplash.com/photo-1449182325215-d517de72c42d?ixlib=rb-1.2.1",
                "full": "https://images.unsplash.com/photo-1449182325215-d517de72c42d?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb",
                "regular": "https://images.unsplash.com/photo-1449182325215-d517de72c42d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max",
                "small": "https://images.unsplash.com/photo-1449182325215-d517de72c42d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max",
                "thumb": "https://images.unsplash.com/photo-1449182325215-d517de72c42d?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max"
              }
            }
          ]
        }
      ]
      """.data(using: .utf8)!

    case .photos:
      return """
      [
        {
          "id": "LBI7cgq3pbM",
          "created_at": "2016-05-03T11:00:28-04:00",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "width": 5245,
          "height": 3497,
          "color": "#60544D",
          "blur_hash": "LoC%a7IoIVxZ_NM|M{s:%hRjWAo0",
          "likes": 12,
          "liked_by_user": false,
          "description": "A man drinking a coffee.",
          "user": {
            "id": "pXhwzz1JtQU",
            "username": "poorkane",
            "name": "Gilbert Kane",
            "portfolio_url": "https://theylooklikeeggsorsomething.com/",
            "bio": "XO",
            "location": "Way out there",
            "total_likes": 5,
            "total_photos": 74,
            "total_collections": 52,
            "instagram_username": "instantgrammer",
            "twitter_username": "crew",
            "profile_image": {
              "small": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
              "medium": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
              "large": "https://images.unsplash.com/face-springmorning.jpg?q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
            },
            "links": {
              "self": "https://api.unsplash.com/users/poorkane",
              "html": "https://unsplash.com/poorkane",
              "photos": "https://api.unsplash.com/users/poorkane/photos",
              "likes": "https://api.unsplash.com/users/poorkane/likes",
              "portfolio": "https://api.unsplash.com/users/poorkane/portfolio"
            }
          },
          "current_user_collections": [ // The *current user's* collections that this photo belongs to.
            {
              "id": 206,
              "title": "Makers: Cat and Ben",
              "published_at": "2016-01-12T18:16:09-05:00",
              "last_collected_at": "2016-06-02T13:10:03-04:00",
              "updated_at": "2016-07-10T11:00:01-05:00",
              "cover_photo": null,
              "user": null
            }
          ],
          "urls": {
            "raw": "https://images.unsplash.com/face-springmorning.jpg",
            "full": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg",
            "regular": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=1080&fit=max",
            "small": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=400&fit=max",
            "thumb": "https://images.unsplash.com/face-springmorning.jpg?q=75&fm=jpg&w=200&fit=max"
          },
          "links": {
            "self": "https://api.unsplash.com/photos/LBI7cgq3pbM",
            "html": "https://unsplash.com/photos/LBI7cgq3pbM",
            "download": "https://unsplash.com/photos/LBI7cgq3pbM/download",
            "download_location": "https://api.unsplash.com/photos/LBI7cgq3pbM/download"
          }
        }
      ]
      """.data(using: .utf8)!
    }
  }
}
