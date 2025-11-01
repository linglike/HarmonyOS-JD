import { promptAction, router } from '@kit.ArkUI'

@Entry
@Component
struct GuidePagexieyi {
  @State isVisibility:boolean = false

  onBackPress(): boolean | void {
    return true
  }

  build() {
    Stack() {
      Column() {
        Image($r("app.media.jd1")).width(300).margin({top:10})
      }
      .backgroundColor("#e1211e")
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width('100%')

      Column() {
        LoadingProgress()
          .width(50)
          .height(50)
          .visibility(this.isVisibility == true?Visibility.Visible:Visibility.Hidden)

        Button("GO SHOPPING")
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor(Color.Red)
          .padding({
            top: 20,
            bottom: 20,
            left: 40,
            right: 40
          })
          .margin({top:90})
          .onClick(() => {
            this.showDialog()
          })
      }.offset({y:270})
    }
  }
  //显示对话框
  showDialog() {
    AlertDialog.show({
      title: ('服务协议和隐私政策'),
      message: ('请你务必审慎阅读、充分理解服务协议”和“隐私政策”各条款，包括但不限于：为了向您提供待办提醒等服务，我们需要向您的系统日历添加待办内容。你可以在系统设置中管理对应权限。你可阅读《服务协议》和《隐私政策》了解详细信息。如同意请点击“同意”开始接受我们的服务。'),
      autoCancel: true,
      alignment: DialogAlignment.Center,
      // 偏移量
      offset: { dx: 0, dy: -30 },
      // 主要按钮
      primaryButton: {
        value: ('拒绝'),
        action: () => {
          router.back()
        }
      },
      // 次要按钮
      secondaryButton: {
        value: ('同意'),
        action: () => {
          this.isVisibility = true
          promptAction.showToast({
            message: "欢迎使用京东商城",
          })
          // 延时跳转页面
          setTimeout(() => {
            router.replaceUrl({
              url: 'pages/Index',
            })
          }, 2000)
        }
      }
    })
  }
}
