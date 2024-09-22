//
//  AchievementView.swift
//  hundred_list_year
//
//  Created by 渡邊涼太 on 2024/07/02.
//

import SwiftUI
import RealmSwift
import PhotosUI

struct AchievementView: View {
    
    //Realm
    @ObservedRealmObject var bucket_item: BucketList
    let realmController = RealmController()
    
    //登録変数
    @State var selectedDate = Date()
    @State var selectedImage:UIImage?
    @State var memo_field:String = ""
    
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
    
    
    //googleAds
    @EnvironmentObject var interstitial: AdmobInterstitialManager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @State var tabFlag: Visibility = .hidden
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    @State var navigationTitle = ""
    
    //変更必要なし
    @State var Default_image_flag:Bool = false
    @State var Achievement_Edit_flag:Bool = false
    
    init(bucket_item:BucketList){
        self.bucket_item = bucket_item
        
        _selectedImage = State.init(initialValue: UIImage(data: bucket_item.imagedata))
        _navigationTitle = State.init(initialValue: bucket_item.name)
    }
    
    var body: some View {
        let now = Date()
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: 1, day: 1))!
        
        ZStack{
            Color.background
            ScrollView(showsIndicators: false) {
                ZStack{
                    Color.background
                        .onTapGesture {
                            focusedField = nil
                        }
                    VStack(spacing:20){
                        Text("日付")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        DatePicker("date", selection: $selectedDate, in: startOfYear...now, displayedComponents: [.date])
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                        Text("画像")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )

                        Button{
                            showingDialog = true
                        }label:{
                            if UIImage_frag {
                                //カメラorアルバムで取得した画像
                                Image(uiImage:cropped_image!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:220, height: 220)
                                    .cornerRadius(5)
                                
                            }else{
                                //デフォルトから取得した画像
                                Image(image_name)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:220, height: 220)
                                    .cornerRadius(5)
                            }
                        }
                        
                        Text("感想")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        
                        TextEditor(text: $memo_field)
                            .focused($focusedField, equals: .achieve_memo)
                            .frame(width:300, height: 120)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1.5))
                            .overlay(alignment: .topLeading) {
                                if memo_field.isEmpty {
                                    Text("Memo")
                                        .allowsHitTesting(false) // タップ判定を無効化
                                        .foregroundColor(Color(uiColor: .placeholderText))
                                        .padding(6)
                                }
                            }
                        
                        Button{
                            //登録処理
                            if UIImage_frag {
                                //UIImage? -> UIImage
                                guard let not_optional_image = cropped_image else{
                                    return
                                }
                                selectedImage = not_optional_image
                            }else{
                                //String -> UIImage
                                guard let not_optional_image = UIImage(named:image_name) else{
                                    return
                                }
                                selectedImage = not_optional_image
                            }
                            
                            guard let selectedImage = selectedImage else{
                                return
                            }
                            
                            realmController.AcievementList(bucketItem: bucket_item, bucket_date: selectedDate, bucket_image: selectedImage, bucket_memo: memo_field)
                            
                            //dismiss
                            tabFlag = .visible
                            dismiss()
                            
                            //広告表示(購入済みでない)
                            if !purchaseManager.perchased {
                                interstitial.AdsOpenCount = interstitial.AdsOpenCount + 1
                                if interstitial.AdsOpenCount % 3 == 0{
                                    interstitial.presentInterstitial()
                                }
                            }
                            
                        }label:{
                            Text("達成！")
                                .fontWeight(.bold)
                                .frame(width: 100, height: 50, alignment: .center)
                                .foregroundColor(.orange)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.orange, lineWidth: 1.0)
                                )
                                .background(Color.white, in: RoundedRectangle(cornerRadius: 15))
                                .padding(.bottom, 100)
                        }//label
                    }//vstack
                }//zstack
            }//scroll
        }//ZStack
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
        .navigationBarTitle("名称：\(navigationTitle)" , displayMode: .inline)
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
        
        .onAppear() {
            print("読み込み開始")
            interstitial.loadInterstitial()}
        
    }
    func image_Cropped(image: UIImage){
        print("image is cropped")
        cropped_image = image
        UIImage_frag = true
    }
}

//#Preview {
//    AchievementView()
//}
