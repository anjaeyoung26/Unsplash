//
//  PhotoSampleDataFetcher.swift
//  Unsplash
//
//  Created by 안재영 on 2022/12/27.
//

import Foundation
import Moya


final class PhotoSampleDataFetcher: SampleDataFetcher {

  // MARK: - Methods

  static func fetch(target: PhotoAPI) -> Data {
    switch target {
    case .downloadURL:
      return """
      {
        "url": "https://image.unsplash.com/example"
      }
      """.data(using: .utf8)!

    case .like:
      return """
      {
        "photo": {
          "id": "LF8gK8-HGSg",
          "width": 5245,
          "height": 3497,
          "color": "#60544D",
          "blur_hash": "LED+e[?GI8-PITbwkD$#0M-Tof9b",
          "likes": 10,
          "liked_by_user": true,
          "description": "A man drinking a coffee.",
          "urls": {
            "raw": "https://images.unsplash.com/1/type-away.jpg",
            "full": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg",
            "regular": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg&w=1080&fit=max",
            "small": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg&w=400&fit=max",
            "thumb": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg&w=200&fit=max"
          },
          "links": {
            "self": "http://api.unsplash.com/photos/LF8gK8-HGSg",
            "html": "http://unsplash.com/photos/LF8gK8-HGSg",
            "download": "http://unsplash.com/photos/LF8gK8-HGSg/download"
          }
        },
        "user": {
          "id": "8VpB0GYJMZQ",
          "username": "williamnot",
          "name": "Thomas R.",
          "links": {
            "self": "http://api.unsplash.com/users/williamnot",
            "html": "http://api.unsplash.com/williamnot",
            "photos": "http://api.unsplash.com/users/williamnot/photos",
            "likes": "http://api.unsplash.com/users/williamnot/likes"
          }
        }
      }
      """.data(using: .utf8)!

    case .list:
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

    case .random:
      return """
      {
        "id": "Dwu85P9SOIk",
        "created_at": "2016-05-03T11:00:28-04:00",
        "updated_at": "2016-07-10T11:00:01-05:00",
        "width": 2448,
        "height": 3264,
        "color": "#6E633A",
        "blur_hash": "LFC$yHwc8^$yIAS$%M%00KxukYIp",
        "downloads": 1345,
        "likes": 24,
        "liked_by_user": false,
        "description": "A man drinking a coffee.",
        "exif": {
          "make": "Canon",
          "model": "Canon EOS 40D",
          "exposure_time": "0.011111111111111112",
          "aperture": "4.970854",
          "focal_length": "37",
          "iso": 100
        },
        "location": {
          "name": "Montreal, Canada",
          "city": "Montreal",
          "country": "Canada",
          "position": {
            "latitude": 45.473298,
            "longitude": -73.638488
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
          "raw": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d",
          "full": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg",
          "regular": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=1080&fit=max",
          "small": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=400&fit=max",
          "thumb": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=200&fit=max"
        },
        "links": {
          "self": "https://api.unsplash.com/photos/Dwu85P9SOIk",
          "html": "https://unsplash.com/photos/Dwu85P9SOIk",
          "download": "https://unsplash.com/photos/Dwu85P9SOIk/download"
          "download_location": "https://api.unsplash.com/photos/Dwu85P9SOIk/download"
        },
        "user": {
          "id": "QPxL2MGqfrw",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "username": "exampleuser",
          "name": "Joe Example",
          "portfolio_url": "https://example.com/",
          "bio": "Just an everyday Joe",
          "location": "Montreal",
          "total_likes": 5,
          "total_photos": 10,
          "total_collections": 13,
          "instagram_username": "instantgrammer",
          "twitter_username": "crew",
          "links": {
            "self": "https://api.unsplash.com/users/exampleuser",
            "html": "https://unsplash.com/exampleuser",
            "photos": "https://api.unsplash.com/users/exampleuser/photos",
            "likes": "https://api.unsplash.com/users/exampleuser/likes",
            "portfolio": "https://api.unsplash.com/users/exampleuser/portfolio"
          }
        }
      }
      """.data(using: .utf8)!

    case .searchCollections:
      return """
      {
        "total": 237,
        "total_pages": 12,
        "results": [
          {
            "id": 193913,
            "title": "Office",
            "description": null,
            "published_at": "2016-04-15T21:05:44-04:00",
            "last_collected_at": "2016-06-02T13:10:03-04:00",
            "updated_at": "2016-07-10T11:00:01-05:00",
            "featured": true,
            "total_photos": 60,
            "private": false,
            "share_key": "79ec77a237f014935eddc774f6aac1cd",
            "cover_photo": {
              "id": "pb_lF8VWaPU",
              "created_at": "2015-02-12T18:39:43-05:00",
              "width": 5760,
              "height": 3840,
              "color": "#1F1814",
              "blur_hash": "L14Bk2M{0d^lR*j[ofWB0K%3^l9Y",
              "likes": 786,
              "liked_by_user": false,
              "description": "A man drinking a coffee.",
              "user": {
                "id": "tkoUSod3di4",
                "username": "gilleslambert",
                "name": "Gilles Lambert",
                "first_name": "Gilles",
                "last_name": "Lambert",
                "instagram_username": "instantgrammer",
                "twitter_username": "gilleslambert",
                "portfolio_url": "http://www.gilleslambert.be/photography",
                "profile_image": {
                  "small": "https://images.unsplash.com/profile-1445832407811-c04ed64d238b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=4bb8fad0dcba43c46491c6fd0b92f537",
                  "medium": "https://images.unsplash.com/profile-1445832407811-c04ed64d238b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=a6d8602c855914fe13650eedd5996cb5",
                  "large": "https://images.unsplash.com/profile-1445832407811-c04ed64d238b?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=26099ca5069692aac6973d08ae02dd71"
                },
                "links": {
                  "self": "https://api.unsplash.com/users/gilleslambert",
                  "html": "http://unsplash.com/@gilleslambert",
                  "photos": "https://api.unsplash.com/users/gilleslambert/photos",
                  "likes": "https://api.unsplash.com/users/gilleslambert/likes"
                }
              },
              "urls": {
                "raw": "https://images.unsplash.com/photo-1423784346385-c1d4dac9893a",
                "full": "https://hd.unsplash.com/photo-1423784346385-c1d4dac9893a",
                "regular": "https://images.unsplash.com/photo-1423784346385-c1d4dac9893a?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=d60d527cb347746ab3abf5fccecf0271",
                "small": "https://images.unsplash.com/photo-1423784346385-c1d4dac9893a?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&s=0bf0c97abca8b2741380f38d3debd45f",
                "thumb": "https://images.unsplash.com/photo-1423784346385-c1d4dac9893a?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=9bc3a6d42a16809b735c22720de3fb13"
              },
              "links": {
                "self": "https://api.unsplash.com/photos/pb_lF8VWaPU",
                "html": "http://unsplash.com/photos/pb_lF8VWaPU",
                "download": "http://unsplash.com/photos/pb_lF8VWaPU/download"
              }
            },
            "user": {
              "id": "k_gSWNtOjS8",
              "username": "cjmconnors",
              "name": "Christine Connors",
              "portfolio_url": null,
              "bio": "",
              "profile_image": {
                "small": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=0ad68f44c4725d5a3fda019bab9d3edc",
                "medium": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=356bd4b76a3d4eb97d63f45b818dd358",
                "large": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=ee8bbf5fb8d6e43aaaa238feae2fe90d"
              },
              "links": {
                "self": "https://api.unsplash.com/users/cjmconnors",
                "html": "http://unsplash.com/@cjmconnors",
                "photos": "https://api.unsplash.com/users/cjmconnors/photos",
                "likes": "https://api.unsplash.com/users/cjmconnors/likes"
              }
            },
            "links": {
              "self": "https://api.unsplash.com/collections/193913",
              "html": "http://unsplash.com/collections/193913/office",
              "photos": "https://api.unsplash.com/collections/193913/photos",
              "related": "https://api.unsplash.com/collections/193913/related"
            }
          }
        ]
      }
      """.data(using: .utf8)!

    case .searchPhotos:
      return """
      {
        "total": 133,
        "total_pages": 7,
        "results": [
          {
            "id": "eOLpJytrbsQ",
            "created_at": "2014-11-18T14:35:36-05:00",
            "width": 4000,
            "height": 3000,
            "color": "#A7A2A1",
            "blur_hash": "LaLXMa9Fx[D%~q%MtQM|kDRjtRIU",
            "likes": 286,
            "liked_by_user": false,
            "description": "A man drinking a coffee.",
            "user": {
              "id": "Ul0QVz12Goo",
              "username": "ugmonk",
              "name": "Jeff Sheldon",
              "first_name": "Jeff",
              "last_name": "Sheldon",
              "instagram_username": "instantgrammer",
              "twitter_username": "ugmonk",
              "portfolio_url": "http://ugmonk.com/",
              "profile_image": {
                "small": "https://images.unsplash.com/profile-1441298803695-accd94000cac?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=7cfe3b93750cb0c93e2f7caec08b5a41",
                "medium": "https://images.unsplash.com/profile-1441298803695-accd94000cac?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=5a9dc749c43ce5bd60870b129a40902f",
                "large": "https://images.unsplash.com/profile-1441298803695-accd94000cac?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=32085a077889586df88bfbe406692202"
              },
              "links": {
                "self": "https://api.unsplash.com/users/ugmonk",
                "html": "http://unsplash.com/@ugmonk",
                "photos": "https://api.unsplash.com/users/ugmonk/photos",
                "likes": "https://api.unsplash.com/users/ugmonk/likes"
              }
            },
            "current_user_collections": [],
            "urls": {
              "raw": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f",
              "full": "https://hd.unsplash.com/photo-1416339306562-f3d12fefd36f",
              "regular": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&s=92f3e02f63678acc8416d044e189f515",
              "small": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&s=263af33585f9d32af39d165b000845eb",
              "thumb": "https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=8aae34cf35df31a592f0bef16e6342ef"
            },
            "links": {
              "self": "https://api.unsplash.com/photos/eOLpJytrbsQ",
              "html": "http://unsplash.com/photos/eOLpJytrbsQ",
              "download": "http://unsplash.com/photos/eOLpJytrbsQ/download"
            }
          }
        ]
      }
      """.data(using: .utf8)!

    case .searchUsers:
      return """
      {
        "total": 14,
        "total_pages": 1,
        "results": [
          {
            "id": "e_gYNc2Fs0s",
            "username": "solase",
            "name": "Aase H. Tjelland",
            "first_name": "Aase",
            "last_name": "H. Tjelland",
            "instagram_username": "instantgrammer",
            "twitter_username": "solase",
            "portfolio_url": null,
            "total_likes": 1,
            "total_photos": 6,
            "total_collections": 0,
            "profile_image": {
              "small": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32&s=0ad68f44c4725d5a3fda019bab9d3edc",
              "medium": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64&s=356bd4b76a3d4eb97d63f45b818dd358",
              "large": "https://images.unsplash.com/placeholder-avatars/extra-large.jpg?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128&s=ee8bbf5fb8d6e43aaaa238feae2fe90d"
            },
            "links": {
              "self": "https://api.unsplash.com/users/solase",
              "html": "http://unsplash.com/@solase",
              "photos": "https://api.unsplash.com/users/solase/photos",
              "likes": "https://api.unsplash.com/users/solase/likes"
            }
          }
      }
      """.data(using: .utf8)!

    case .single:
      return """
      {
        "id": "Dwu85P9SOIk",
        "created_at": "2016-05-03T11:00:28-04:00",
        "updated_at": "2016-07-10T11:00:01-05:00",
        "width": 2448,
        "height": 3264,
        "color": "#6E633A",
        "blur_hash": "LFC$yHwc8^$yIAS$%M%00KxukYIp",
        "downloads": 1345,
        "likes": 24,
        "liked_by_user": false,
        "public_domain": false,
        "description": "A man drinking a coffee.",
        "exif": {
          "make": "Canon",
          "model": "Canon EOS 40D",
          "name": "Canon, EOS 40D",
          "exposure_time": "0.011111111111111112",
          "aperture": "4.970854",
          "focal_length": "37",
          "iso": 100
        },
        "location": {
          "city": "Montreal",
          "country": "Canada",
          "position": {
            "latitude": 45.473298,
            "longitude": -73.638488
          }
        },
        "tags": [
          { "title": "man" },
          { "title": "drinking" },
          { "title": "coffee" }
        ],
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
          "raw": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d",
          "full": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg",
          "regular": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=1080&fit=max",
          "small": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=400&fit=max",
          "thumb": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=200&fit=max"
        },
        "links": {
          "self": "https://api.unsplash.com/photos/Dwu85P9SOIk",
          "html": "https://unsplash.com/photos/Dwu85P9SOIk",
          "download": "https://unsplash.com/photos/Dwu85P9SOIk/download"
          "download_location": "https://api.unsplash.com/photos/Dwu85P9SOIk/download"
        },
        "user": {
          "id": "QPxL2MGqfrw",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "username": "exampleuser",
          "name": "Joe Example",
          "portfolio_url": "https://example.com/",
          "bio": "Just an everyday Joe",
          "location": "Montreal",
          "total_likes": 5,
          "total_photos": 10,
          "total_collections": 13,
          "links": {
            "self": "https://api.unsplash.com/users/exampleuser",
            "html": "https://unsplash.com/exampleuser",
            "photos": "https://api.unsplash.com/users/exampleuser/photos",
            "likes": "https://api.unsplash.com/users/exampleuser/likes",
            "portfolio": "https://api.unsplash.com/users/exampleuser/portfolio"
          }
        }
      }
      """.data(using: .utf8)!

    case .unlike:
      return """
      {
        "photo": {
          "id": "LF8gK8-HGSg",
          "width": 5245,
          "height": 3497,
          "color": "#60544D",
          "blur_hash": "LED+e[?GI8-PITbwkD$#0M-Tof9b",
          "likes": 10,
          "liked_by_user": false,
          "description": "A man drinking a coffee.",
          "urls": {
            "raw": "https://images.unsplash.com/1/type-away.jpg",
            "full": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg",
            "regular": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg&w=1080&fit=max",
            "small": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg&w=400&fit=max",
            "thumb": "https://images.unsplash.com/1/type-away.jpg?q=80&fm=jpg&w=200&fit=max"
          },
          "links": {
            "self": "http://api.unsplash.com/photos/LF8gK8-HGSg",
            "html": "http://unsplash.com/photos/LF8gK8-HGSg",
            "download": "http://unsplash.com/photos/LF8gK8-HGSg/download"
          }
        },
        "user": {
          "id": "8VpB0GYJMZQ",
          "username": "williamnot",
          "name": "Thomas R.",
          "links": {
            "self": "http://api.unsplash.com/users/williamnot",
            "html": "http://api.unsplash.com/williamnot",
            "photos": "http://api.unsplash.com/users/williamnot/photos",
            "likes": "http://api.unsplash.com/users/williamnot/likes"
          }
        }
      }
      """.data(using: .utf8)!

    case .upload:
      return """
      {
        "id": "Dwu85P9SOIk",
        "created_at": "2016-05-03T11:00:28-04:00",
        "updated_at": "2016-07-10T11:00:01-05:00",
        "width": 2448,
        "height": 3264,
        "color": "#6E633A",
        "blur_hash": "LFC$yHwc8^$yIAS$%M%00KxukYIp",
        "downloads": 1345,
        "likes": 24,
        "liked_by_user": false,
        "public_domain": false,
        "description": "A man drinking a coffee.",
        "exif": {
          "make": "Canon",
          "model": "Canon EOS 40D",
          "name": "Canon, EOS 40D",
          "exposure_time": "0.011111111111111112",
          "aperture": "4.970854",
          "focal_length": "37",
          "iso": 100
        },
        "location": {
          "city": "Montreal",
          "country": "Canada",
          "position": {
            "latitude": 45.473298,
            "longitude": -73.638488
          }
        },
        "tags": [
          { "title": "man" },
          { "title": "drinking" },
          { "title": "coffee" }
        ],
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
          "raw": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d",
          "full": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg",
          "regular": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=1080&fit=max",
          "small": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=400&fit=max",
          "thumb": "https://images.unsplash.com/photo-1417325384643-aac51acc9e5d?q=75&fm=jpg&w=200&fit=max"
        },
        "links": {
          "self": "https://api.unsplash.com/photos/Dwu85P9SOIk",
          "html": "https://unsplash.com/photos/Dwu85P9SOIk",
          "download": "https://unsplash.com/photos/Dwu85P9SOIk/download"
          "download_location": "https://api.unsplash.com/photos/Dwu85P9SOIk/download"
        },
        "user": {
          "id": "QPxL2MGqfrw",
          "updated_at": "2016-07-10T11:00:01-05:00",
          "username": "exampleuser",
          "name": "Joe Example",
          "portfolio_url": "https://example.com/",
          "bio": "Just an everyday Joe",
          "location": "Montreal",
          "total_likes": 5,
          "total_photos": 10,
          "total_collections": 13,
          "links": {
            "self": "https://api.unsplash.com/users/exampleuser",
            "html": "https://unsplash.com/exampleuser",
            "photos": "https://api.unsplash.com/users/exampleuser/photos",
            "likes": "https://api.unsplash.com/users/exampleuser/likes",
            "portfolio": "https://api.unsplash.com/users/exampleuser/portfolio"
          }
        }
      }
      """.data(using: .utf8)!

    case .url:
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
    }
  }
}
