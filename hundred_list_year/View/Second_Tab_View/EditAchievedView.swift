//
//  EditAchieved.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/13.
//

import SwiftUI
import RealmSwift
import PhotosUI

struct EditAchievedView: View {
    
    //Realm
    @ObservedRealmObject var bucket_item: BucketList
    
    //初期値&編集
    @State var initialImageData:Data
    
    //監視に必要なflag
    @State var Default_image_flag:Bool = true
    @State var Achievement_Edit_flag:Bool = true
    
    //写真取得方法の選択
    @State var showingDialog:Bool = false
    @State var showingSheet:Bool = false
    @State var selectedSheet:String = ""
    @State var showingPhotosPicker:Bool = false
    @State var showingCamera:Bool = false
    
    //写真関係の変数
    @State var image_name:String = "imageEx1"
    @State var UIImage_frag:Bool = false
    @State var will_crop_image: UIImage?
    @State var cropped_image: UIImage?
    @State var album_images: [PhotosPickerItem] = []
    
    @State var tabFlag: Visibility = .hidden
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    init(bucket_item:BucketList){
        self.bucket_item = bucket_item
        
//        _selectedImage = State.init(initialValue: UIImage(data: bucket_item.imagedata))
//        _navigationTitle = State.init(initialValue: bucket_item.name)
        _initialImageData = State.init(initialValue: bucket_item.imagedata)
    }
    
    var body: some View {
        ZStack{
            Color.background
                
            ScrollView(showsIndicators: false) {
                ZStack{
                    Color.background
                        .onTapGesture {
                            focusedField = nil
                        }
                    
                    VStack(spacing:30){
                        Button{
                            showingDialog = true
                        }label:{
                            if Default_image_flag{
                                Image(uiImage: UIImage(data: initialImageData)!)
                            }else{
                                if UIImage_frag {
                                    //カメラorアルバムで取得した画像
                                    Image(uiImage:cropped_image!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:220, height: 220)
                                    
                                }else{
                                    //デフォルトから取得した画像
                                    Image(image_name)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:220, height: 220)
                                }
                            }
                        }
                        
                    }//VStack
                }//ZStack
            }//scroll
        }
        .confirmationDialog("画像の変更", isPresented: $showingDialog, titleVisibility: .visible){
            Button("アルバムから取得"){
                showingPhotosPicker = true
            }
            Button("カメラから取得"){
                showingCamera = true
            }
            Button("画像集から取得"){
                //sheet遷移（DefaultImageView)
                selectedSheet = "ToDefaultImageView"
                showingSheet = true
            }
            Button("元に戻す"){
                Default_image_flag = false
            }
        }message: {
            Text("画像を取得する方法を選んでください")
        }
        //sheet
        .sheet(isPresented: $showingSheet){
            switch selectedSheet {
                //デフォルト画像から選択
            case "ToDefaultImageView":
                DefaultImageView(image_name: $image_name, UIImage_frag: $UIImage_frag, Default_image_flag: $Default_image_flag, Achievement_Edit_flag: $Achievement_Edit_flag)
                
                //画像をクロップするときに表示
            case "CropImage":
                ImageCropper(image: self.$will_crop_image, visible: self.$showingSheet, done: image_Cropped)
                
            default:
                DefaultImageView(image_name: $image_name, UIImage_frag: $UIImage_frag, Default_image_flag: $Default_image_flag, Achievement_Edit_flag: $Achievement_Edit_flag)
            }
        }
        //アルバム起動
        .photosPicker(isPresented: $showingPhotosPicker, selection: $album_images, maxSelectionCount: 1, matching: .images)
        //カメラ起動
        .fullScreenCover(isPresented:$showingCamera){
            CameraView(image: $will_crop_image).ignoresSafeArea()
        }
        
        //アルバムの画像をData型に編集する
        .onChange(of: album_images){
            Task{
                guard let data = try? await album_images[0].loadTransferable(type: Data.self) else {return}
                guard let uiImage = UIImage(data:data) else {return}
                will_crop_image = uiImage
            }
        }
        //クロップシートの呼び出し
        .onChange(of: will_crop_image){
            selectedSheet = "CropImage"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showingSheet = true
            }
        }
        
        .navigationTitle("編集する")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button{
                    //戻るボタン
                    dismiss()
                    tabFlag = .visible
                    
                }label:{
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .foregroundColor(Color.button)
                    
                }
            }
        }
        .toolbar(tabFlag, for: .tabBar)
    }
    func image_Cropped(image: UIImage){
        print("image is cropped")
        cropped_image = image
        Default_image_flag = false
        UIImage_frag = true
    }
}

//#Preview {
//    EditAchieved()
//}
