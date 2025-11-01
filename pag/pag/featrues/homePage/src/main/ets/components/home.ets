import {basicConstant} from "common"
import {breakPointSystem} from "common"
import {
  homeTitle,
  homeTitleDate,
  listData, listDatass,
} from "../viewModel/viewModel"
import {MyhttpRequest} from "common"
import {listDatea}from '../API/homeApi'
import {nodate} from "../view/noDate"
import { http } from "@kit.NetworkKit"
import { router } from "@kit.ArkUI"
// import "../../../../../../prodect/deflaut/src/main/ets/pages/Detali"

//搜索
@Builder function sousuo(){
  Flex({justifyContent:FlexAlign.SpaceBetween}){
    Image($r("app.media.woniu"))
      .width(25)
    Image($r("app.media.sys"))
      .width(25)
  }
  .height(50)
  .width(basicConstant.FULL_WIDTH)
  .margin({bottom:8})
  Row({space:10}){
    Image($r("app.media.fdj"))
      .width(20)
      .margin({left:10})
    TextInput({placeholder:"请输入你想搜索的商品"}).width("60%").backgroundColor(Color.White).placeholderFont({size:10})
  }
  .height(50)
  .width(basicConstant.FULL_WIDTH)
  .backgroundColor(Color.White)
  .borderRadius(20)
  .margin({bottom:10})
}
//轮播图
@Builder function mySwipers(breakpoint:string){
  Swiper(){
    Image("https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/8835531789bb48deb91eedffeff58518.jpg?w=2452&h=920")
    Image("https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/e2caa56930291816d827912646f6e5ee.jpg?thumb=1&w=1533&h=575&f=webp&q=90")
    Image("https://cdn.cnbj1.fds.api.mi-img.com/mi-mall/105e5ca001ebac00630dcbea2f1182bf.jpg?thumb=1&w=1533&h=575&f=webp&q=90")
  }
  .height(250)
  .width(basicConstant.FULL_WIDTH)
  .indicator(true) //是否显示导航点
  .loop(true) //是否循环播放
  .autoPlay(true) //是否自动播放
  .displayCount(breakpoint=="sm"?1:breakpoint=="lg"?2:3)
  .margin({bottom:10})
}
//楼梯导航
@Builder function Titles(arr:homeTitle[]){
  Grid(){
    ForEach(arr,(item:homeTitle)=>{
      GridItem(){
        Column() {
          Image(item.image)
            .width(40)
          Text(item.name)
        }
      }
    },(item:homeTitle)=>item.id+"")
  }
  .rowsTemplate("1fr 1fr")
  .columnsTemplate("1fr 1fr 1fr 1fr")
  .rowsGap(5)
  .columnsGap(5)
  .width(basicConstant.FULL_WIDTH)
  .height(250)
  .margin({bottom:10})
}

@Component
export struct home {
private  breakPointSystem = new breakPointSystem()
private itemDetail = (value:string)=>{}
  //商品导航
  @Builder  listDate(){
    if (listDatass.length>0){
      List(){
        ForEach(listDatass,(item:listData)=>{
          ListItem(){
            Column(){
              Image(item.image)
                .width("100%")
                .height(100)
                .margin({bottom:5})
              Column() {
                Text(item.title)
                  .width("100%")
                  .textAlign(TextAlign.Center)
                  .margin({bottom:5})
                Row() {
                  Text(`￥${item.price}`)
                    .fontSize(basicConstant.MIDDLE_FONT_SIZE)
                    .fontColor(Color.Red)
                  Image($r("app.media.car"))
                    .width(20)
                }
                .width("100%")
                .justifyContent(FlexAlign.SpaceBetween)
              }
            }
            .padding(10)
            .width("96%")
            .backgroundColor(Color.White)
            .margin({bottom:10})
            .onClick((Event:ClickEvent)=>this.itemDetail(item.id))
            // .onClick(()=>{
            //   router.pushNamedRoute({
            //     name:"Detali"
            //   })
            // })
          }
        })
      }
      .scrollBar(BarState.Off)
      .lanes(2)
    }else{
      nodate()
    }

  }


  @StorageProp("currentBreakPoint") currentBreaKPoint:string = "lk"
  @State homeTitleDates:homeTitle[] = []
  @State listDates:listData[] = []
  //商品
  listDateapi = async ()=>{
    const res:listData[] =  await listDatea()
    this.listDates = res
    console.log(res+"")
  }

  aboutToAppear() {
    console.log(this.currentBreaKPoint)
    this.homeTitleDates = homeTitleDate
    this.listDateapi()
  }

  aboutToDisappear(): void {
 this.breakPointSystem.unregister()
}
  build() {
    Column(){
        Stack({alignContent:Alignment.Top}){
          //背景图
          Row(){
          }
          .width(basicConstant.FULL_WIDTH)
          .height(200)
          .backgroundColor("#FF8247")
          .borderRadius({bottomLeft:150,bottomRight:150})


          //主要内容
          Flex({
            direction:FlexDirection.Column
          }){
            //图标搜索
            sousuo()

            //轮播图
            mySwipers(this.currentBreaKPoint)
            //楼层
            Titles(this.homeTitleDates)
            //商品
            this.listDate()
          }
          .width(basicConstant.FULL_WIDTH)
          .height(basicConstant.FULL_HEIGHT)
          .padding({top:10,left:12,right:12})
        }
        .alignSelf(ItemAlign.Start)
    }
    .width(basicConstant.FULL_WIDTH)
    .height(basicConstant.FULL_HEIGHT)
  }
}
