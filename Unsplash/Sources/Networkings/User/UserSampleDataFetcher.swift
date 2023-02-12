//
//  UserSampleDataFetcher.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation
import Moya


final class UserSampleDataFetcher: SampleDataFetcher {

    // MARK: - Methods

  static func fetch(target: UserAPI) -> Data {
    switch target {
    case .likePhotos:
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
          "current_user_collections": [
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

    case .me:
      return """
      {
        "id": "pXhwzz1JtQU",
        "updated_at": "2016-07-10T11:00:01-05:00",
        "username": "jimmyexample",
        "first_name": "James",
        "last_name": "Example",
        "twitter_username": "jimmy",
        "portfolio_url": null,
        "bio": "The user's bio",
        "location": "Montreal, Qc",
        "total_likes": 20,
        "total_photos": 10,
        "total_collections": 5,
        "followed_by_user": false,
        "downloads": 4321,
        "uploads_remaining": 4,
        "instagram_username": "james-example",
        "location": null,
        "email": "jim@example.com",
        "links": {
          "self": "https://api.unsplash.com/users/jimmyexample",
          "html": "https://unsplash.com/jimmyexample",
          "photos": "https://api.unsplash.com/users/jimmyexample/photos",
          "likes": "https://api.unsplash.com/users/jimmyexample/likes",
          "portfolio": "https://api.unsplash.com/users/jimmyexample/portfolio"
        }
      }
      """.data(using: .utf8)!

    case .stat:
      return """
      {
        "id": "LBI7cgq3pbM",
        "username": "jimmyexample",
        "downloads": {
          "total": 15687,
          "historical": {
            "change": 608,
            "average": 20,
            "resolution": "days",
            "quantity": 30,
            "values": [
              { "date": "2017-02-25", "value": 8 },
              { "date": "2017-02-26", "value": 26 },
              { "date": "2017-02-27", "value": 72 },
              { "date": "2017-02-28", "value": 21 },
              { "date": "2017-03-01", "value": 22 },
              { "date": "2017-03-02", "value": 26 },
              { "date": "2017-03-03", "value": 26 },
              { "date": "2017-03-04", "value": 7 },
              { "date": "2017-03-05", "value": 10 },
              { "date": "2017-03-06", "value": 21 },
              { "date": "2017-03-07", "value": 24 },
              { "date": "2017-03-08", "value": 22 },
              { "date": "2017-03-09", "value": 4 },
              { "date": "2017-03-10", "value": 1 },
              { "date": "2017-03-11", "value": 2 },
              { "date": "2017-03-12", "value": 3 },
              { "date": "2017-03-13", "value": 7 },
              { "date": "2017-03-14", "value": 7 },
              { "date": "2017-03-15", "value": 3 },
              { "date": "2017-03-16", "value": 3 },
              { "date": "2017-03-17", "value": 1 },
              { "date": "2017-03-18", "value": 6 },
              { "date": "2017-03-19", "value": 40 },
              { "date": "2017-03-20", "value": 1 },
              { "date": "2017-03-21", "value": 86 },
              { "date": "2017-03-22", "value": 156 },
              { "date": "2017-03-23", "value": 3 },
              { "date": "2017-03-24", "value": 0 },
              { "date": "2017-03-25", "value": 0 },
              { "date": "2017-03-26", "value": 0 }
            ]
          }
        },
        "views": {
          "total": 2374826,
          "historical": {
            "change": 30252,
            "average": 1008,
            "resolution": "days",
            "quantity": 30,
            "values": [
              { "date": "2017-02-25", "value": 21 },
              { "date": "2017-02-26", "value": 22 },
              { "date": "2017-02-27", "value": 32 },
              { "date": "2017-02-28", "value": 31 },
              { "date": "2017-03-01", "value": 31 },
              { "date": "2017-03-02", "value": 31 },
              { "date": "2017-03-03", "value": 27 },
              { "date": "2017-03-04", "value": 17 },
              { "date": "2017-03-05", "value": 20 },
              { "date": "2017-03-06", "value": 32 },
              { "date": "2017-03-07", "value": 31 },
              { "date": "2017-03-08", "value": 14 },
              { "date": "2017-03-09", "value": 11 },
              { "date": "2017-03-10", "value": 16 },
              { "date": "2017-03-11", "value": 15 },
              { "date": "2017-03-12", "value": 17 },
              { "date": "2017-03-13", "value": 21 },
              { "date": "2017-03-14", "value": 14 },
              { "date": "2017-03-15", "value": 10 },
              { "date": "2017-03-16", "value": 13 },
              { "date": "2017-03-17", "value": 25 },
              { "date": "2017-03-18", "value": 22 },
              { "date": "2017-03-19", "value": 30 },
              { "date": "2017-03-20", "value": 24 },
              { "date": "2017-03-21", "value": 21 },
              { "date": "2017-03-22", "value": 19 },
              { "date": "2017-03-23", "value": 18 },
              { "date": "2017-03-24", "value": 17 },
              { "date": "2017-03-25", "value": 19 },
              { "date": "2017-03-26", "value": 10 }
            ]
          }
        }
      }
      """.data(using: .utf8)!

    case .updateProfile:
      return """
      {
        "id": "pXhwzz1JtQU",
        "updated_at": "2016-07-10T11:00:01-05:00",
        "username": "jimmyexample",
        "first_name": "James",
        "last_name": "Example",
        "twitter_username": "jimmy",
        "portfolio_url": null,
        "bio": "The user's bio",
        "location": "Montreal, Qc",
        "total_likes": 20,
        "total_photos": 10,
        "total_collections": 5,
        "followed_by_user": false,
        "downloads": 4321,
        "uploads_remaining": 4,
        "instagram_username": "james-example",
        "location": null,
        "email": "jim@example.com",
        "links": {
          "self": "https://api.unsplash.com/users/jimmyexample",
          "html": "https://unsplash.com/jimmyexample",
          "photos": "https://api.unsplash.com/users/jimmyexample/photos",
          "likes": "https://api.unsplash.com/users/jimmyexample/likes",
          "portfolio": "https://api.unsplash.com/users/jimmyexample/portfolio"
        }
      }
      """.data(using: .utf8)!

    case .userCollections:
      return """
      [
        {
          "id": 296,
          "title": "I like a man with a beard.",
          "description": "Yeah even Santa...",
          "published_at": "2016-01-27T18:47:13-05:00",
          "last_collected_at": "2016-06-02T13:10:03-04:00",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "total_photos": 12,
          "private": false,
          "share_key": "312d188df257b957f8b86d2ce20e4766",
          "cover_photo": {
            "id": "C-mxLOk6ANs",
            "width": 5616,
            "height": 3744,
            "color": "#E4C6A2",
            "blur_hash": "L57Uhwni00t7EeRkagj@s+kBxvoe",
            "likes": 12,
            "liked_by_user": false,
            "description": "A man drinking a coffee.",
            "user": {
              "id": "xlt1-UPW7FE",
              "username": "lionsdenpro",
              "name": "Greg Raines",
              "portfolio_url": "https://example.com/",
              "bio": "Just an everyday Greg",
              "location": "Montreal",
              "total_likes": 5,
              "total_photos": 10,
              "total_collections": 13,
              "profile_image": {
                "small": "https://images.unsplash.com/profile-1449546653256-0faea3006d34?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
                "medium": "https://images.unsplash.com/profile-1449546653256-0faea3006d34?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
                "large": "https://images.unsplash.com/profile-1449546653256-0faea3006d34?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
              },
              "links": {
                "self": "https://api.unsplash.com/users/lionsdenpro",
                "html": "https://unsplash.com/lionsdenpro",
                "photos": "https://api.unsplash.com/users/lionsdenpro/photos",
                "likes": "https://api.unsplash.com/users/lionsdenpro/likes",
                "portfolio": "https://api.unsplash.com/users/lionsdenpro/portfolio"
              }
            },
            "urls": {
              "raw": "https://images.unsplash.com/photo-1449614115178-cb924f730780",
              "full": "https://images.unsplash.com/photo-1449614115178-cb924f730780?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy",
              "regular": "https://images.unsplash.com/photo-1449614115178-cb924f730780?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max",
              "small": "https://images.unsplash.com/photo-1449614115178-cb924f730780?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max",
              "thumb": "https://images.unsplash.com/photo-1449614115178-cb924f730780?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max"
            },
            "links": {
              "self": "https://api.unsplash.com/photos/C-mxLOk6ANs",
              "html": "https://unsplash.com/photos/C-mxLOk6ANs",
              "download": "https://unsplash.com/photos/C-mxLOk6ANs/download"
            }
          },
          "user": {
            "id": "IFcEhJqem0Q",
            "updated_at": "2016-07-10T11:00:01-05:00",
            "username": "fableandfolk",
            "name": "Annie Spratt",
            "portfolio_url": "http://mammasaurus.co.uk",
            "bio": "Follow me on Twitter &amp; Instagram @anniespratt\r\nEmail me at hello@fableandfolk.com",
            "location": "New Forest National Park, UK",
            "total_likes": 0,
            "total_photos": 273,
            "total_collections": 36,
            "profile_image": {
              "small": "https://images.unsplash.com/profile-1450003783594-db47c765cea3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
              "medium": "https://images.unsplash.com/profile-1450003783594-db47c765cea3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
              "large": "https://images.unsplash.com/profile-1450003783594-db47c765cea3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
            },
            "links": {
              "self": "https://api.unsplash.com/users/fableandfolk",
              "html": "https://unsplash.com/fableandfolk",
              "photos": "https://api.unsplash.com/users/fableandfolk/photos",
              "likes": "https://api.unsplash.com/users/fableandfolk/likes",
              "portfolio": "https://api.unsplash.com/users/fableandfolk/portfolio"
            }
          },
          "links": {
            "self": "https://api.unsplash.com/collections/296",
            "html": "https://unsplash.com/collections/296",
            "photos": "https://api.unsplash.com/collections/296/photos",
            "related": "https://api.unsplash.com/collections/296/related"
          }
        }
      ]
      """.data(using: .utf8)!

    case .userPhotos:
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
          "current_user_collections": [
            {
              "id": "206",
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
        },
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
          "current_user_collections": [
            {
              "id": "206",
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
        },
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
          "current_user_collections": [
            {
              "id": "206",
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
        },
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
          "current_user_collections": [
            {
              "id": "206",
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
