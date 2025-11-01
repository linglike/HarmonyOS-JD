import { promptAction, router } from '@kit.ArkUI';
PersistentStorage.persistProp<string>("userName","")

PersistentStorage.persistProp("zcuserName","")
PersistentStorage.persistProp("zcpassword","")

@Entry
@Component
struct Login {
  @State yonghu: string = '';
  @State password: string = '';
  @State zcyonghu: string = '';
  @State zcpassword: string = '';
  @State isshow:number = 1
  onBackPress(): boolean | void {
    return true
  }

  aboutToAppear(): void {
    this.onBackPress()
  }


  build() {
    Column({ space: 20 }) {
      Column() {
        Image($r("app.media.woniu")).width(200)
        Text("蜗牛超市")
      }


       Column() {
         Row({ space: 10 }) {
           Text("用户")
           TextInput({ placeholder: "请输入您的用户名", text: $$this.yonghu }).width(280)
         }.width(300).justifyContent(FlexAlign.Center)

         Row({ space: 10 }) {
           Text("密码")
           TextInput({ placeholder: "请输入您的密码", text: $$this.password }).width(280)
         }.width(300).justifyContent(FlexAlign.Center)
       }.width("100%").visibility(this.isshow == 1?Visibility.Visible:Visibility.None)

      Column() {
        Row({ space: 10 }) {
          Text("注册用户")
          TextInput({ placeholder: "请注册您的用户名", text: $$this.zcyonghu }).width(280)
        }.width(300).justifyContent(FlexAlign.Center)

        Row({ space: 10 }) {
          Text("注册密码")
          TextInput({ placeholder: "请注册您的密码", text: $$this.zcpassword }).width(280)
        }.width(300).justifyContent(FlexAlign.Center)
      }.width("100%").visibility(this.isshow == 2?Visibility.Visible:Visibility.None)


      Row({space:30}) {
        Button("登录")
          .width(100)
          .height(50)
          .backgroundColor(Color.Yellow)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.isshow = 1
            if (this.yonghu == "" || this.password == "") {
              promptAction.showToast({
                message: "用户名和密码不能为空"
              })
            } else {
              if (this.yonghu == AppStorage.get("zcuserName") && this.password == AppStorage.get("zcpassword")) {
                promptAction.showToast({
                  message: "登陆成功"
                })
                router.replaceUrl({
                  url: "pages/guidePage",
                })
              } else {
                promptAction.showToast({
                  message: "您的账户未注册,请先注册之后再进行登录"
                })
              }
            }
          })
        Button("注册")
          .width(100)
          .height(50)
          .backgroundColor(Color.Yellow)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.isshow = 2
            if (this.zcyonghu == "" || this.zcpassword == "") {
              promptAction.showToast({
                message: "用户名和密码不能为空"
              })
            } else {
              AppStorage.setOrCreate("zcuserName", this.zcyonghu)
              AppStorage.setOrCreate("zcpassword", this.zcpassword)
              promptAction.showToast({
                message: "注册成功"
              })

            }
          })
      }


    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height('100%')
    .width('100%')
  }
}