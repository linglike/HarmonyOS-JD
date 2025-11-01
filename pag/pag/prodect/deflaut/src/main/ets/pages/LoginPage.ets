// 导入页面路由模块
import router from '@ohos.router';
// 导入弹窗
import promptAction from '@ohos.promptAction';


import preferences from '@ohos.data.preferences';
import App from '@system.app';


export const Path_Login = 'pages/LoginPage'

PersistentStorage.persistProp("username","")
PersistentStorage.persistProp("userpassword","")

@Entry
@Component
struct Login {
  @State username: string = ''; // 用户名
  @State userpassword: string = ''; // 密码
  @State timeText:string= ""
  aboutToAppear(): void {
    this.song()
  }
 song(){
     setInterval(() => {
       const date = new Date();
       this.timeText = date.toLocaleTimeString();
     }, 1000);
 }
  build() {
    Row() {
      Column() {
        // logo
        Image($r("app.media.pingjialogo"))
          .width('80vp')// 默认单位就是vp，可以简写为80
          .width(80)
          .borderRadius(10)
          .margin({ bottom: '20vp' })

        // 欢迎文字
        Text('账号登录')
          .fontSize('30fp')
          .fontWeight(FontWeight.Bold)

        // 用户名和密码输入框
        TextInput({ placeholder: '请输入用户名',text:$$this.username })
          .inputStyle()// 公共样式函数
          .maxLength(11)
          .margin({ left: 20, right: 20, top: 20 })

        TextInput({ placeholder: '请输入密码',text:$$this.userpassword })
          .type(InputType.Password)// 输入框类型
          .inputStyle()// 公共样式函数
          .margin({ left: 20, right: 20, top: 10 })

        // 文字提示
        Row() {
          Text('忘记密码')
            .fontSize('16fp')
            .fontColor(Color.Blue)
            .margin({ right: 30,top:10 })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)

        // 登录按钮
        Button('登录', { type: ButtonType.Capsule })
          .width('60%')
          .margin({ top: 20})
          .backgroundColor(Color.Red)
          .onClick(() => {
            if (AppStorage.get("username") && AppStorage.get("userpassword")) {
              if (this.username == "" || this.userpassword == "") {
                promptAction.showToast({
                  message:"用户名和密码不能为空!"
                })
              }else {
                if (this.username == AppStorage.get("username")&&this.userpassword == AppStorage.get("userpassword")) {
                  router.pushUrl({
                    url:"pages/guidePagexieyi"
                  })
                }else {
                  promptAction.showToast({
                    message:"用户名或者密码输入错误!"
                  })
                }
              }
            }else {
              promptAction.showToast({
                message:"用户未注册，请先前往注册"
              })
            }
          })

        Row() {
          Text('注册')
            .fontSize('16fp')
            .fontColor(Color.Blue)
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 15 })
        .onClick(() => {
           router.pushUrl({
             url:"pages/RegistPage"
           })
        })

        // 其他
        Row() {
          Blank().height(0.5).layoutWeight(1)
            .backgroundColor(Color.Gray)
            .margin({ left: 10, right: 10 })
          Text('其他登录方式')
            .fontSize('16fp')
            .fontColor(Color.Gray)
          Blank().height(0.5).layoutWeight(1)
            .backgroundColor(Color.Gray)
            .margin({ left: 10, right: 10 })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 40 })

        // 三个按钮
        Row() {
          Row() {
            Image($r('app.media.pay')).width(40).height(40)
            Text('支付宝账号')
          }.layoutWeight(1).alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)

          Row() {
            Image($r('app.media.wx')).width(40).height(40)
            Text('微信')
          }.layoutWeight(1).alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin('20vp')


        //显示当前时间
        Text(this.timeText).fontSize(20)

      }
      .width('100%')
    }
    .height('100%')

  }


}

// 添加公共的样式函数
// @Extend装饰器：扩展组件样式
// @Extend(组件描述名称) function 样式名称
// 输入框公共样式函数
@Extend(TextInput)
function inputStyle() {
  .placeholderColor(0x999999)
  .maxLength(6)
  .padding('12vp')
  .margin('10vp')
}

// 原型按钮公共样式函数
@Extend(Button)
function circleBtnStyle() {
  .width('60vp')
  .height('60vp')
}
