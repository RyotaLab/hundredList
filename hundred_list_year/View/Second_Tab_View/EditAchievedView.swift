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
    
    //googleAds
    @EnvironmentObject var interstitial: AdmobInterstitialManager
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    //初期値&編集
    @State var initialImageData:Data
    @State var name_field:String = ""
    @State var selectedTag:String = "その他"
    @State var memo_field:String = ""
    @State var selectedDate = Date()
    @State var selectedImage:UIImage?
    
    private let tags = ["旅行", "食事", "買い物", "仕事", "勉強・資格", "ヘルスケア", "人間関係", "趣味", "美容", "その他"]
    
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
    
    //navigation系
    @State var tabFlag: Visibility = .hidden
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    let realmController = RealmController()
    
    init(bucket_item:BucketList){
        self.bucket_item = bucket_item
        _name_field = State.init(initialValue: bucket_item.name)
        _selectedTag = State.init(initialValue: bucket_item.tag)
        _initialImageData = State.init(initialValue: bucket_item.imagedata)
        _memo_field = State.init(initialValue: bucket_item.memo)
        _selectedDate = State.init(initialValue: bucket_item.achivement_date)
    }
    
    var body: some View {
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDate), month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: calendar.component(.year, from: selectedDate), month: 12, day: 31))!
        
        ZStack{
            Color.background
            ScrollView(showsIndicators: false) {
                ZStack{
                    Color.background
                        .onTapGesture {
                            focusedField = nil
                        }
                    
                    VStack(spacing:30){
                        //名前
                        Text("名称")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        TextField("名前を入力してください", text: $name_field)
                            .focused($focusedField, equals: .achieved_edit_name)
                            .overlay(
                                RoundedRectangle(cornerSize: CGSize(width: 8.0, height: 8.0))
                                    .stroke(Color.gray, lineWidth: 1.5)
                                    .padding(-8.0)
                            )
                            .padding(8.0)
                            .background(Color.white, in: RoundedRectangle(cornerRadius: 8))
                            .padding(.horizontal, 40)
                        
                        //画像
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
                            if Default_image_flag{
                                Image(uiImage: UIImage(data: initialImageData)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:220, height: 220)
                                    .cornerRadius(5)
                            }else{
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
                        }
                        
                        //タグ
                        Text("タグ")
                            .foregroundColor(Color.button)
                            .fontWeight(.bold)
                            .padding(.top, 30)
                            .overlay(
                                Rectangle()
                                    .fill(Color.orange)
                                    .frame(width: 65, height: 1)
                                , alignment: .bottom
                            )
                        FlowLayout(alignment: .center, spacing: 7) {
                            ForEach(tags, id:\.self) { tag in
                                Text(tag)
                                    .foregroundColor(selectedTag == tag ? .white: .orange)
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 12)
                                    .background(selectedTag == tag ? .orange: .white, in: RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange, lineWidth: 1.0)
                                    )
                                    .onTapGesture {
                                        selectedTag = tag
                                    }
                            }
                        }.padding(.horizontal)//FlowLayout
                        
                        //日付
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
                        DatePicker("date", selection: $selectedDate, in: startOfYear...endOfYear, displayedComponents: [.date])
                            .environment(\.locale, Locale(identifier: "ja_JP"))
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                        
                        //メモ
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
                            .focused($focusedField, equals: .achieved_edit_memo)
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
                        //登録
                        Button{
                            if !Default_image_flag {
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
                                
                                guard let selected_Image = selectedImage else{
                                    return
                                }
                                
                                guard let selected_image_data = selected_Image.jpegData(compressionQuality: 0.1) else{
                                    print("error(UIImage->Data)")
                                    return
                                }
                                
                                initialImageData = selected_image_data
                            }
                            
                            
                            realmController.UpdateAchievedList(bucketItem: bucket_item, bucket_name: name_field, bucket_image_data: initialImageData, bucket_tag: selectedTag, bucket_date: selectedDate, bucket_memo: memo_field)
                            
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
                            Text("変更する")
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
                Default_image_flag = true
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
        
        .navigationBarTitle("編集する", displayMode: .inline)
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
        Default_image_flag = false
        UIImage_frag = true
    }
}

//#Preview {
//    EditAchieved()
//}
