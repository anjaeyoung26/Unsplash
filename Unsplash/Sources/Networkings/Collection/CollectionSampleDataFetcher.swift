//
//  CollectionSampleDataFetcher.swift
//  Unsplash
//
//  Created by 안재영 on 2023/02/07.
//

import Foundation
import Moya


final class CollectionSampleDataFetcher: SampleDataFetcher {

  // MARK: - Methods

  static func fetch(target: CollectionAPI) -> Data {
    switch target {
    case .addPhoto:
      return """
      {
        "photo": {
          "id": "cnwIyn_BTkc",
          "created_at": "2016-05-03T11:00:28-04:00",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "width": 1024,
          "height": 768,
          "color": "#ABC123",
          "blur_hash": "LPF#XMx]jGVs0gNGodt7R4RjS4s;",
          "likes": 12,
          "liked_by_user": false,
          "description": "A man drinking a coffee.",
          "user": {
            "id": "OuzxrCITLj8",
            "username": "aaron",
            "name": "Aaron K",
            "portfolio_url": "http://www.outerspacehero.com/",
            "bio": "Buildin' Unsplash.",
            "location": "Winnipeg",
            "total_likes": 0,
            "total_photos": 0,
            "total_collections": 1,
            "profile_image": {
              "small": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
              "medium": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
              "large": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
            },
            "links": {
              "self": "https://api.unsplash.com/users/aaron",
              "html": "https://unsplash.com/aaron",
              "photos": "https://api.unsplash.com/users/aaron/photos",
              "likes": "https://api.unsplash.com/users/aaron/likes",
              "portfolio": "https://api.unsplash.com/users/aaron/portfolio"
            }
          },
          "current_user_collections": [
            {
              "id": 206,
              "title": "Makers: Cat and Ben",
              "description": "Behind-the-scenes photos from the Makers interview with designers Cat Noone and Benedikt Lehnert.",
              "published_at": "2016-01-12T18:16:09-05:00",
              "last_collected_at": "2016-06-02T13:10:03-04:00",
              "updated_at": "2016-07-10T11:00:01-05:00",
              "cover_photo": null,
              "user": null,
            }
          ],
          "urls": {
            "raw":  "https://images.unsplash.com/photo-1454625233598-f29d597eea1e",
            "full": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy",
            "regular": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max",
            "small": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max",
            "thumb": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max"
          },
          "links": {
            "self": "https://api.unsplash.com/photos/cnwIyn_BTkc",
            "html": "https://unsplash.com/photos/cnwIyn_BTkc",
            "download": "https://unsplash.com/photos/cnwIyn_BTkc/download"
            "download_location": "https://api.unsplash.com/photos/cnwIyn_BTkc/download"
          }
        },
        "collection": {
          "id": 298,
          "title": "API test",
          "description": "Even API need photos.",
          "published_at": "2016-02-29T15:46:20-05:00",
          "last_collected_at": "2016-06-02T13:10:03-04:00",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "total_photos": 12,
          "private": false,
          "share_key", "312d188df257b957f8b86d2ce20e4766"
          "cover_photo": {
            "id": "cnwIyn_BTkc",
            "width": null,
            "height": null,
            "color": null,
            "blur_hash": "LPF#XMx]jGVs0gNGodt7R4RjS4s;",
            "user": {
              "id": "OuzxrCITLj8",
              "username": "aaron",
              "name": "Aaron K",
              "profile_image": {
                "small": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
                "medium": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
                "large": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
              },
              "links": {
                "self": "https://api.unsplash.com/users/aaron",
                "html": "https://unsplash.com/aaron",
                "photos": "https://api.unsplash.com/users/aaron/photos",
                "likes": "https://api.unsplash.com/users/aaron/likes",
                "portfolio": "https://api.unsplash.com/users/aaron/portfolio"
              }
            },
            "urls": {
              "full": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy",
              "regular": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max",
              "small": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max",
              "thumb": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max"
            },
            "links": {
              "self": "https://api.unsplash.com/photos/cnwIyn_BTkc",
              "html": "https://unsplash.com/photos/cnwIyn_BTkc",
              "download": "https://unsplash.com/photos/cnwIyn_BTkc/download"
              "download_location": "https://api.unsplash.com/photos/cnwIyn_BTkc/download"
            }
          },
          "user": {
            "id": "Z4hPZdsRla8",
            "updated_at": "2016-07-10T11:00:01-05:00",
            "username": "oscartothekeys",
            "name": "Oscar Keys",
            "bio": "simple is beautiful",
            "profile_image": {
              "small": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
              "medium": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
              "large": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
            },
            "links": {
              "self": "https://api.unsplash.com/users/oscartothekeys",
              "html": "https://unsplash.com/oscartothekeys",
              "photos": "https://api.unsplash.com/users/oscartothekeys/photos",
              "likes": "https://api.unsplash.com/users/oscartothekeys/likes",
              "portfolio": "https://api.unsplash.com/users/oscartothekeys/portfolio"
            }
          },
          "links": {
            "self": "https://api.unsplash.com/collections/298",
            "html": "https://unsplash.com/collections/298",
            "photos": "https://api.unsplash.com/collections/298/photos"
          }
        },
        "user": {
          "id": "Z4hPZdsRla8",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "username": "oscartothekeys",
          "name": "Oscar Keys",
          "profile_image": {
            "small": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
            "medium": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
            "large": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
          },
          "links": {
            "self": "https://api.unsplash.com/users/oscartothekeys",
            "html": "https://unsplash.com/oscartothekeys",
            "photos": "https://api.unsplash.com/users/oscartothekeys/photos",
            "likes": "https://api.unsplash.com/users/oscartothekeys/likes",
            "portfolio": "https://api.unsplash.com/users/oscartothekeys/portfolio"
          }
        },
        "created_at": "2016-02-29T15:47:39.969-05:00"
      }
      """.data(using: .utf8)!

    case .collectionPhotos:
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

    case .createCollection:
      return """
      {
        "id": 206,
        "title": "Makers: Cat and Ben",
        "description": "Behind-the-scenes photos from the Makers interview with designers Cat Noone and Benedikt Lehnert.",
        "published_at": "2016-01-12T18:16:09-05:00",
        "last_collected_at": "2016-06-02T13:10:03-04:00",
        "updated_at": "2016-07-10T11:00:01-05:00",
        "featured": false,
        "total_photos": 12,
        "private": false,
        "share_key": "312d188df257b957f8b86d2ce20e4766",
        "cover_photo": null,
        "user": null,
        "links": {
          "self": "https://api.unsplash.com/collections/206",
          "html": "https://unsplash.com/collections/206/makers-cat-and-ben",
          "photos": "https://api.unsplash.com/collections/206/photos"
        }
      }
      """.data(using: .utf8)!

    case .deleteCollection:
      return """
      {
        "photo": {
          "id": "cnwIyn_BTkc",
          "created_at": "2016-05-03T11:00:28-04:00",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "width": 1024,
          "height": 768,
          "color": "#ABC123",
          "blur_hash": "LPF#XMx]jGVs0gNGodt7R4RjS4s;",
          "likes": 12,
          "liked_by_user": false,
          "description": "A man drinking a coffee.",
          "user": {
            "id": "OuzxrCITLj8",
            "username": "aaron",
            "name": "Aaron K",
            "portfolio_url": "http://www.outerspacehero.com/",
            "bio": "Buildin' Unsplash.",
            "location": "Winnipeg",
            "total_likes": 0,
            "total_photos": 0,
            "total_collections": 1,
            "profile_image": {
              "small": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
              "medium": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
              "large": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
            },
            "links": {
              "self": "https://api.unsplash.com/users/aaron",
              "html": "https://unsplash.com/aaron",
              "photos": "https://api.unsplash.com/users/aaron/photos",
              "likes": "https://api.unsplash.com/users/aaron/likes",
              "portfolio": "https://api.unsplash.com/users/aaron/portfolio"
            }
          },
          "current_user_collections": [
            {
              "id": 206,
              "title": "Makers: Cat and Ben",
              "description": "Behind-the-scenes photos from the Makers interview with designers Cat Noone and Benedikt Lehnert.",
              "published_at": "2016-01-12T18:16:09-05:00",
              "last_collected_at": "2016-06-02T13:10:03-04:00",
              "updated_at": "2016-07-10T11:00:01-05:00",
              "cover_photo": null,
              "user": null,
            }
          ],
          "urls": {
            "raw":  "https://images.unsplash.com/photo-1454625233598-f29d597eea1e",
            "full": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy",
            "regular": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max",
            "small": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max",
            "thumb": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max"
          },
          "links": {
            "self": "https://api.unsplash.com/photos/cnwIyn_BTkc",
            "html": "https://unsplash.com/photos/cnwIyn_BTkc",
            "download": "https://unsplash.com/photos/cnwIyn_BTkc/download"
            "download_location": "https://api.unsplash.com/photos/cnwIyn_BTkc/download"
          }
        },
        "collection": {
          "id": 298,
          "title": "API test",
          "description": "Even API need photos.",
          "published_at": "2016-02-29T15:46:20-05:00",
          "last_collected_at": "2016-06-02T13:10:03-04:00",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "total_photos": 12,
          "private": false,
          "share_key", "312d188df257b957f8b86d2ce20e4766"
          "cover_photo": {
            "id": "cnwIyn_BTkc",
            "width": null,
            "height": null,
            "color": null,
            "blur_hash": "LPF#XMx]jGVs0gNGodt7R4RjS4s;",
            "user": {
              "id": "OuzxrCITLj8",
              "username": "aaron",
              "name": "Aaron K",
              "profile_image": {
                "small": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
                "medium": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
                "large": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
              },
              "links": {
                "self": "https://api.unsplash.com/users/aaron",
                "html": "https://unsplash.com/aaron",
                "photos": "https://api.unsplash.com/users/aaron/photos",
                "likes": "https://api.unsplash.com/users/aaron/likes",
                "portfolio": "https://api.unsplash.com/users/aaron/portfolio"
              }
            },
            "urls": {
              "full": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy",
              "regular": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max",
              "small": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max",
              "thumb": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max"
            },
            "links": {
              "self": "https://api.unsplash.com/photos/cnwIyn_BTkc",
              "html": "https://unsplash.com/photos/cnwIyn_BTkc",
              "download": "https://unsplash.com/photos/cnwIyn_BTkc/download"
              "download_location": "https://api.unsplash.com/photos/cnwIyn_BTkc/download"
            }
          },
          "user": {
            "id": "Z4hPZdsRla8",
            "updated_at": "2016-07-10T11:00:01-05:00",
            "username": "oscartothekeys",
            "name": "Oscar Keys",
            "bio": "simple is beautiful",
            "profile_image": {
              "small": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
              "medium": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
              "large": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
            },
            "links": {
              "self": "https://api.unsplash.com/users/oscartothekeys",
              "html": "https://unsplash.com/oscartothekeys",
              "photos": "https://api.unsplash.com/users/oscartothekeys/photos",
              "likes": "https://api.unsplash.com/users/oscartothekeys/likes",
              "portfolio": "https://api.unsplash.com/users/oscartothekeys/portfolio"
            }
          },
          "links": {
            "self": "https://api.unsplash.com/collections/298",
            "html": "https://unsplash.com/collections/298",
            "photos": "https://api.unsplash.com/collections/298/photos"
          }
        },
        "user": {
          "id": "Z4hPZdsRla8",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "username": "oscartothekeys",
          "name": "Oscar Keys",
          "profile_image": {
            "small": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
            "medium": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
            "large": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
          },
          "links": {
            "self": "https://api.unsplash.com/users/oscartothekeys",
            "html": "https://unsplash.com/oscartothekeys",
            "photos": "https://api.unsplash.com/users/oscartothekeys/photos",
            "likes": "https://api.unsplash.com/users/oscartothekeys/likes",
            "portfolio": "https://api.unsplash.com/users/oscartothekeys/portfolio"
          }
        },
        "created_at": "2016-02-29T15:47:39.969-05:00"
      }
      """.data(using: .utf8)!

    case .removePhoto:
      return """
      {
        "photo": {
          "id": "cnwIyn_BTkc",
          "created_at": "2016-05-03T11:00:28-04:00",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "width": 1024,
          "height": 768,
          "color": "#ABC123",
          "blur_hash": "LPF#XMx]jGVs0gNGodt7R4RjS4s;",
          "likes": 12,
          "liked_by_user": false,
          "description": "A man drinking a coffee.",
          "user": {
            "id": "OuzxrCITLj8",
            "username": "aaron",
            "name": "Aaron K",
            "portfolio_url": "http://www.outerspacehero.com/",
            "bio": "Buildin' Unsplash.",
            "location": "Winnipeg",
            "total_likes": 0,
            "total_photos": 0,
            "total_collections": 1,
            "profile_image": {
              "small": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
              "medium": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
              "large": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
            },
            "links": {
              "self": "https://api.unsplash.com/users/aaron",
              "html": "https://unsplash.com/aaron",
              "photos": "https://api.unsplash.com/users/aaron/photos",
              "likes": "https://api.unsplash.com/users/aaron/likes",
              "portfolio": "https://api.unsplash.com/users/aaron/portfolio"
            }
          },
          "current_user_collections": [
            {
              "id": 206,
              "title": "Makers: Cat and Ben",
              "description": "Behind-the-scenes photos from the Makers interview with designers Cat Noone and Benedikt Lehnert.",
              "published_at": "2016-01-12T18:16:09-05:00",
              "last_collected_at": "2016-06-02T13:10:03-04:00",
              "updated_at": "2016-07-10T11:00:01-05:00",
              "cover_photo": null,
              "user": null,
            }
          ],
          "urls": {
            "raw":  "https://images.unsplash.com/photo-1454625233598-f29d597eea1e",
            "full": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy",
            "regular": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max",
            "small": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max",
            "thumb": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max"
          },
          "links": {
            "self": "https://api.unsplash.com/photos/cnwIyn_BTkc",
            "html": "https://unsplash.com/photos/cnwIyn_BTkc",
            "download": "https://unsplash.com/photos/cnwIyn_BTkc/download"
            "download_location": "https://api.unsplash.com/photos/cnwIyn_BTkc/download"
          }
        },
        "collection": {
          "id": 298,
          "title": "API test",
          "description": "Even API need photos.",
          "published_at": "2016-02-29T15:46:20-05:00",
          "last_collected_at": "2016-06-02T13:10:03-04:00",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "total_photos": 12,
          "private": false,
          "share_key", "312d188df257b957f8b86d2ce20e4766"
          "cover_photo": {
            "id": "cnwIyn_BTkc",
            "width": null,
            "height": null,
            "color": null,
            "blur_hash": "LPF#XMx]jGVs0gNGodt7R4RjS4s;",
            "user": {
              "id": "OuzxrCITLj8",
              "username": "aaron",
              "name": "Aaron K",
              "profile_image": {
                "small": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
                "medium": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
                "large": "https://images.unsplash.com/profile-1444840959767-6286d046f7f2?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
              },
              "links": {
                "self": "https://api.unsplash.com/users/aaron",
                "html": "https://unsplash.com/aaron",
                "photos": "https://api.unsplash.com/users/aaron/photos",
                "likes": "https://api.unsplash.com/users/aaron/likes",
                "portfolio": "https://api.unsplash.com/users/aaron/portfolio"
              }
            },
            "urls": {
              "full": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy",
              "regular": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max",
              "small": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max",
              "thumb": "https://images.unsplash.com/photo-1454625233598-f29d597eea1e?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max"
            },
            "links": {
              "self": "https://api.unsplash.com/photos/cnwIyn_BTkc",
              "html": "https://unsplash.com/photos/cnwIyn_BTkc",
              "download": "https://unsplash.com/photos/cnwIyn_BTkc/download"
              "download_location": "https://api.unsplash.com/photos/cnwIyn_BTkc/download"
            }
          },
          "user": {
            "id": "Z4hPZdsRla8",
            "updated_at": "2016-07-10T11:00:01-05:00",
            "username": "oscartothekeys",
            "name": "Oscar Keys",
            "bio": "simple is beautiful",
            "profile_image": {
              "small": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
              "medium": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
              "large": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
            },
            "links": {
              "self": "https://api.unsplash.com/users/oscartothekeys",
              "html": "https://unsplash.com/oscartothekeys",
              "photos": "https://api.unsplash.com/users/oscartothekeys/photos",
              "likes": "https://api.unsplash.com/users/oscartothekeys/likes",
              "portfolio": "https://api.unsplash.com/users/oscartothekeys/portfolio"
            }
          },
          "links": {
            "self": "https://api.unsplash.com/collections/298",
            "html": "https://unsplash.com/collections/298",
            "photos": "https://api.unsplash.com/collections/298/photos"
          }
        },
        "user": {
          "id": "Z4hPZdsRla8",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "username": "oscartothekeys",
          "name": "Oscar Keys",
          "profile_image": {
            "small": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32",
            "medium": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64",
            "large": "https://images.unsplash.com/profile-1453284965521-5bd2363623de?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128"
          },
          "links": {
            "self": "https://api.unsplash.com/users/oscartothekeys",
            "html": "https://unsplash.com/oscartothekeys",
            "photos": "https://api.unsplash.com/users/oscartothekeys/photos",
            "likes": "https://api.unsplash.com/users/oscartothekeys/likes",
            "portfolio": "https://api.unsplash.com/users/oscartothekeys/portfolio"
          }
        },
        "created_at": "2016-02-29T15:47:39.969-05:00"
      }

      """.data(using: .utf8)!

    case .updateCollection:
      return """
      {
        "id": 206,
        "title": "Makers: Cat and Ben",
        "description": "Behind-the-scenes photos from the Makers interview with designers Cat Noone and Benedikt Lehnert.",
        "published_at": "2016-01-12T18:16:09-05:00",
        "last_collected_at": "2016-06-02T13:10:03-04:00",
        "updated_at": "2016-07-10T11:00:01-05:00",
        "featured": false,
        "total_photos": 12,
        "private": false,
        "share_key": "312d188df257b957f8b86d2ce20e4766",
        "cover_photo": null,
        "user": null,
        "links": {
          "self": "https://api.unsplash.com/collections/206",
          "html": "https://unsplash.com/collections/206/makers-cat-and-ben",
          "photos": "https://api.unsplash.com/collections/206/photos"
        }
      }
      """.data(using: .utf8)!
    }
  }
}
