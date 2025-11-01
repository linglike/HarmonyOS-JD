

import { promptAction, router } from "@kit.ArkUI"
@Component
export struct mine {

  @State message: string = ''

  build() {
    Column({ space: 20 }) {
      Row({space:20}){
        Image($r("app.media.pingjialogo")).height(60)
        Text(AppStorage.get("username")??"名字").fontSize(20).fontWeight(FontWeight.Bold)
      }.alignItems(VerticalAlign.Top)
      .width("90%")

      Row({ space: 180 }) {
        Text('退出登录').fontSize(20).margin({ left: 20 })
        Image($r("app.media.clear")).height(30).width(30)
      }
      .width('90%')
      .height(50)
      .borderRadius(25)
      .backgroundColor($r('sys.color.comp_background_list_card'))
      .onClick(()=>{
        AppStorage.clear()
        promptAction.showToast({
          message:"退出成功"
        })
        router.replaceUrl({
          url:"pages/LoginPage"
        })
      })


    }.justifyContent(FlexAlign.Start).height('100%').width('100%').margin({ top: 20, bottom: 20 })
  }
}