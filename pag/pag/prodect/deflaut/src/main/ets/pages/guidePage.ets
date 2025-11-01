import { router } from '@kit.ArkUI';
import {breakPointSystem,preferencesUtils} from "common"
@Entry
@Component
struct GuidePage {
  @State message: string = 'Hello World';
  private  timer:number = 0
  @State  count:number = 3
  @State flag:number = 1
  @StorageProp("currentBreakPoint") currentBreakPoint:string = "sl"
  private  breakPointSystem = new breakPointSystem()
aboutToAppear(): void {
   this.breakPointSystem.register()
  preferencesUtils.insert("FRIST","ISFRIST")
  switch (this.currentBreakPoint){
     case "sm":this.flag *= 1
    break;
    case  "md":this.flag *= 1.1
      break;
    case  "lg":this.flag *= 1.2
      break;
    case  "xl":this.flag *= 1.5
      break;

  }

   this.timer = setInterval(()=>{
    this.count --
    if(this.count == 0){
      router.pushUrl({
        url:"pages/Index"
      })
    }
  },1000)
}
aboutToDisappear(): void {
  clearInterval(this.timer)
  this.breakPointSystem.unregister()

}
  build() {
    Stack(){
      Text("倒计时"+this.count+this.currentBreakPoint)

      Flex({
        direction:FlexDirection.Column,
        alignItems:ItemAlign.Center
      }) {
        Column(){
          Image($r("app.media.woniu"))
            .width(120 * this.flag)
            .objectFit(ImageFit.Contain)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .flexGrow(1)
        Text("蜗牛超市")
          .letterSpacing(5)
          .fontWeight(FontWeight.Bold)
          .fontSize(18 * this.flag)
          .fontColor(Color.Brown)
          .fontStyle(FontStyle.Italic)

        Text("WoniuMall超市")
          .fontSize(20 * this.flag)
          .fontWeight(FontWeight.Bold)
          .letterSpacing(15)
          .margin({top:20,bottom:120})

      }
      .height('100%')
      .width('100%')
    }
    }
  }