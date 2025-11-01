import {breakPointSystem,add} from "common"
import {home} from "homepage"
import {NavigationExample} from "productpage"
import {shoppingCar} from "shoppingcarpage"
import {mine} from "minepage"
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private  breakPointSystem = new breakPointSystem()
  @StorageProp("currentBreakPoint") currentBreakPoint:string = "lb"
  private tabsController = new TabsController()
  @State currentIndex:number = 0
  aboutToAppear() {
    this.breakPointSystem.register()
    console.log(this.currentBreakPoint);
    }

    onBackPress(): boolean | void {
      return true
    }

    @Builder tabContent(title:string,targetIndex:number,selectImage:Resource,nomalImage:Resource){
     Column(){
       Image(this.currentIndex == targetIndex?selectImage:nomalImage)
         .width(25)
         .height(25)
       Text(title)
         .fontColor(this.currentIndex == targetIndex?Color.Red:Color.Gray)
     }
     .width("100%")
      .height("100%")
     .onClick(()=>{
       this.currentIndex = targetIndex
       this.tabsController.changeIndex(targetIndex)
     })
    }

    private  checkitem = (value:string) =>{
      console.log("接受跳转的item的id值"+value);
      router.pushUrl({
        url:"pages/Detali",
        params:{
          value:value
        }
      })
    }

  build() {
    Tabs({
      barPosition:this.currentBreakPoint == "lg"? BarPosition.Start:BarPosition.End,
      controller:this.tabsController
    }) {
      TabContent() {
      home({itemDetail:this.checkitem})
      }
      .tabBar(this.tabContent(("首页"),0,$r("app.media.syc"),$r("app.media.sy")))

      TabContent() {
        NavigationExample()
      }
      .tabBar(this.tabContent(("消息"),1,$r("app.media.cpc"),$r("app.media.cp")))

      TabContent() {
        shoppingCar()
      }
      .tabBar(this.tabContent(("购物车"),2,$r("app.media.gwcc"),$r("app.media.gwc")))

      TabContent() {
        mine()
      }
      .tabBar(this.tabContent(("我的"),3,$r("app.media.wdc"),$r("app.media.wd")))
    }
    .vertical(this.currentBreakPoint == "lg"?true:false) //导航栏横向显示
    // .barWidth(100)  //导航栏宽度
    // .barHeight(200) //导航栏高度
    .height('100%')
    .width('100%')
    .backgroundColor("#F5F5F5")
    .onChange((index:number)=>{
      this.currentIndex = index
    })
  }
}