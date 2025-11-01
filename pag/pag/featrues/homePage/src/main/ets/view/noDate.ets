import {basicConstant} from "common"
@Component
export  struct nodate{
  build() {
    Column(){
      Image($r("app.media.nodata"))
        .width(60)
        .height(60)
        .margin({bottom:5})
        Text("页面空空如也！")
          .fontColor("#707070")
          .fontSize(basicConstant.MIDDLE_FONT_SIZE)
    }
    .width(basicConstant.FULL_WIDTH)
    .height(basicConstant.FULL_HEIGHT)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}