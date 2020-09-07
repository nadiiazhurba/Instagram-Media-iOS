//
//  InstagramResponse.swift
//  InstagramMedia
//
//  Created by Надежда Журба on 03.09.2020.
//  Copyright © 2020 NadiiaZhurba. All rights reserved.
//

import UIKit

struct InstagramTestUser: Codable {
  var access_token: String
  var user_id: Int
}
struct InstagramUser: Codable {
  var id: String
  var username: String
}
struct Feed: Codable {
  var data: [MediaData]
  var paging: PagingData
}
struct MediaData: Codable {
  var id: String
  var caption: String?
}
struct PagingData: Codable {
  var cursors: CursorData
  var next: String
}
struct CursorData: Codable {
  var before: String
  var after: String
}
struct InstagramMedia: Codable {
  var id: String
  var media_type: MediaType
  var media_url: String
  var username: String
  var timestamp: String
}
enum MediaType: String, Codable {
  case IMAGE
  case VIDEO
  case CAROUSEL_ALBUM
}