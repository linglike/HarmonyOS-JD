// 导入页面路由模块
import router from '@ohos.router';
// 导入弹窗
import promptAction from '@ohos.promptAction';
import { Router } from '@kit.ArkUI';

export const Path_Regist = 'pages/RegistPage'

@Entry
@Component
struct RegistPage {
  @State zcusername: string = ''; // 用户名
  @State zcuserpassword: string = ''; // 密码
  @State password2: string = ''; // 密码

  build() {
    Column() {
      Row() {
        Image($r("app.media.arrowleft"))
          .width(30)
          .height(30)
          .borderRadius(10)
          .margin({ top: 30, left: 16 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .onClick(() => {
        router.back()
      })

      Image($r("app.media.pingjialogo"))
        .width('80vp')// 默认单位就是vp，可以简写为80
        .width(80)
        .margin({ bottom: '20vp', top: 40 })

      // 欢迎文字
      Text('用户注册')
        .fontSize('30fp')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 30 })

      // 用户名和密码输入框
      TextInput({ placeholder: '请输入用户名',text:$$this.zcusername })
        .inputStyle()// 公共样式函数
        .maxLength(11)
       .margin({ left: 20, right: 20, top: 10 })

      TextInput({ placeholder: '请输入密码',text:$$this.zcuserpassword })
        .type(InputType.Password)// 输入框类型
        .inputStyle()// 公共样式函数
       .margin({ left: 20, right: 20, top: 10 })

      TextInput({ placeholder: '请再次输入密码',text:$$this.password2 })
        .type(InputType.Password)// 输入框类型
        .inputStyle()// 公共样式函数
        .margin({ left: 20, right: 20, top: 10 })

      // 登录按钮
      Button('注册', { type: ButtonType.Capsule })
        .width('60%')
        .margin({ top: 20, left: 20, right: 20 })
        .backgroundColor(Color.Red)
        .onClick(() => {
          if (this.zcuserpassword == this.password2) {
            AppStorage.setOrCreate("username",this.zcusername)
            AppStorage.setOrCreate("userpassword",this.zcuserpassword)
            router.back()
            promptAction.showToast({
              message:"注册成功"
            })
          }else {
            promptAction.showToast({
              message:"两次密码输入不一致,请重新输入!"
            })
          }
        })

    }
    .width('100%')
  }


}

// 添加公共的样式函数
// @Extend装饰器：扩展组件样式
// @Extend(组件描述名称) function 样式名称
// 输入框公共样式函数
// RegistPage.ets 的 TextInput 样式
@Extend(TextInput)
function inputStyle() {
  .placeholderColor(0x999999)
  // 移除 .maxLength(6)
  .padding('12vp')
  .margin('10vp')
}

// 原型按钮公共样式函数
@Extend(Button)
function circleBtnStyle() {
  .width('60vp')
  .height('60vp')
}
