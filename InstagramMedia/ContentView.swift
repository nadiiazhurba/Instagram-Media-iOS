//
//  ContentView.swift
//  InstagramMedia
//
//  Created by Надежда Журба on 02.09.2020.
//  Copyright © 2020 NadiiaZhurba. All rights reserved.
//

import SwiftUI

/*struct ContentView: View {
    @State var instagramApi = InstagramApi.shared
    @State var signedIn = false
    @State var instagramImage = UIImage(imageLiteralResourceName:
    "instagram_background")
    @State var presentAuth = false
    @State var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    @State var instagramUser: InstagramUser? = nil
    
    var body: some View {
        NavigationView {
          ZStack {
            Image(uiImage: instagramImage)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .edgesIgnoringSafeArea(Edge.Set.all)
            VStack{
              Button(action: {
                if self.testUserData.user_id == 0 {
                  self.presentAuth.toggle()
                } else {
                  self.instagramApi.getInstagramUser(testUserData: self.testUserData) { (user) in
                    self.instagramUser = user
                    self.signedIn.toggle()
                  }
                }
              }) {
                Image("Instagram_icon")
                  .renderingMode(.original)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 100, height: 100)
            }
              Button(action: {
                if self.instagramUser != nil {
                  self.instagramApi.getMedia(testUserData: self.testUserData) { (media) in
                    if media.media_type != MediaType.VIDEO {
                      let media_url = media.media_url
                      self.instagramApi.fetchImage(urlString: media_url, completion: { (fetchedImage) in
                        if let imageData = fetchedImage {
                          self.instagramImage = UIImage(data: imageData)!
                        } else {
                          print("Didn’t fetch the data")
                        }
                      })
                      print(media_url)
                    } else {
                      print("Fetched media is a video")
                    }
                  }
                } else {
                    print("Not signed in")
                }
              }){
               Text("Fetch Media to background")
                 .font(.headline)
                 .padding()
              }
            }
          }
        }.sheet(isPresented: self.$presentAuth) {
          WebViewController(presentAuth: self.$presentAuth, testUserData:   self.$testUserData, instagramApi: self.$instagramApi)
        }
        .actionSheet(isPresented: self.$signedIn) {
          let actionSheet = ActionSheet(title: Text("Signed in:"), message: Text("with account: @\(self.instagramUser!.username)"),buttons:   [.default(Text("OK"))])
          return actionSheet
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
