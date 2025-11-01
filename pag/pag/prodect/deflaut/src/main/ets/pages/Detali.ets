import {paramsType} from "../viewModel/paramsModel"
import { router } from '@kit.ArkUI';
import {goodDetail}from "../viewModel/detailModel"
import {cartDButils, cartModel} from "common"
import { relationalStore } from '@kit.ArkData';
import {shoppingCar} from "shoppingcarpage"
import {CustomDialogExample} from "../Component/CustomDialog"

@Entry
@Component
struct Detali {
  @State message: string = '详情页面';
  @State count :number = 0
   private getparam = (router.getParams() as paramsType<string>).value

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample(),
  })


  @State goodDetailList:goodDetail = {
     id:"0",
     goodname:"XiaoMi 14",
    good_big_image:"https://cdn.cnbj0.fds.api.mi-img.com/b2c-shopapi-pms/pms_1730124041.0437021.png",
     name:"徕卡光学Summilux镜头｜光影猎人900影像传感器 | 75mm徕卡浮动长焦 | 小米澎湃OS ｜第三代骁龙®8移动平台｜小米环形冷泵",
     image:["https://cdn.cnbj0.fds.api.mi-img.com/b2c-shopapi-pms/pms_1730124041.0437021.png","https://cdn.cnbj0.fds.api.mi-img.com/b2c-shopapi-pms/pms_1730124041.20684102.png","https://cdn.cnbj0.fds.api.mi-img.com/b2c-shopapi-pms/pms_1730124041.1239613.png"] ,
     title:"「至高24期免息」徕卡光学 Summilux 高速镜头｜骁龙®8至尊版移动平台｜5400mAh 小米金沙江电池 小米澎湃OS 2｜全生态AI助手 超级小爱｜低功耗超级阳光屏",
     count:10,
     price:1999,
     checked:0,
  }
  goShoppingCar=()=>{
     const value:relationalStore.ValuesBucket = {
       GOOD_BIG_NAME:this.goodDetailList.good_big_image,
       GOOD_NAME:this.goodDetailList.goodname,
       NAME:this.goodDetailList.name,
       TITLE:this.goodDetailList.title,
       COUNT:this.goodDetailList.count,
       PRICE:this.goodDetailList.price,
       CHECKED:this.goodDetailList.checked
     }
      cartDButils.insertDB("shoppingCar1",value)

  }

  @Builder bootomMenu(){
     
     GridRow({columns:{sm:6,md:8,lg:12}}){
       GridCol({span:{sm:1,md:2,lg:3}}){
         Column() {
           Image($r("app.media.sy"))
             .width(25)
             .height(25)
             .margin({bottom:5})
           Text("首页")
         }
         .width("100%")
         .height("100%")
         .justifyContent(FlexAlign.Center)
         .alignItems(HorizontalAlign.Center)
         .onClick(()=>{
               router.pushUrl({
                 url:"pages/Index",
               })
         })
       }

       GridCol({span:{sm:1,md:2,lg:3}}){
         Column() {
           Image($r("app.media.gwc"))
             .width(25)
             .height(25)
             .margin({bottom:5})
           Text("购物车")
         }
         .width("100%")
         .height("100%")
         .justifyContent(FlexAlign.Center)
         .alignItems(HorizontalAlign.Center)
         .onClick(()=>{
           router.pushNamedRoute({
             name:"myCar"
           })
         })
       }

       GridCol({span:{sm:4,md:4,lg:6}}){
              Row(){
                Row(){
                  Text("加入购物车")
                    .fontColor(Color.White)
                }
                .justifyContent(FlexAlign.Center)
                .width("50%")
                .height(40)
                .borderRadius({topLeft:40,bottomLeft:40})
                .backgroundColor(Color.Orange)
                .onClick(this.goShoppingCar)
                Row(){
                   Text("立即支付")
                     .fontColor(Color.White)
                }
                .justifyContent(FlexAlign.Center)
                .width("50%")
                .height(40)
                .borderRadius({topRight:30,bottomRight:30})
                .backgroundColor(Color.Red)

              }
              .width("100%")
              .height("100%")
         .justifyContent(FlexAlign.SpaceBetween)
         .alignItems(VerticalAlign.Center)

       }
       .width("100%")
       .height("100%")
     }
  }
  @Builder detailSwpier(detailswiper:string[]){
     Stack({alignContent:Alignment.BottomEnd}){
       Swiper() {
         ForEach(detailswiper, (item: string) => {
               Image(item)
                 .width("100%")
                 .height("100%")
                 .objectFit(ImageFit.Contain)
         }, (item: string) => item)
       }
       .autoPlay(true)
       .loop(true)
       .height(300)
       .indicator(false)
       .onChange((index:number)=>{
                 this.count = index
       })
       Text(`${this.count + 1}/${detailswiper.length}`)
         .margin({bottom:30,right:30})
     }
  }
  @Builder detailName(detailname:goodDetail) {
    Flex({ direction: FlexDirection.Column }) {
      Text(detailname.goodname)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({bottom:18})
      Text(detailname.name)
    }
    .padding(10)
    .width("100%")
    .backgroundColor(Color.White)
    .borderRadius(20)
  }
  @Builder chooseType(detailname:goodDetail) {
    Flex({ direction: FlexDirection.Row }) {
        Text("用户选择:小米14,白色,16GB+512GB,官方标配,1个,").textOverflow({overflow:TextOverflow.Ellipsis}).maxLines(1)

    }
    .padding(10)
    .width("100%")
    .backgroundColor(Color.White)
    .borderRadius(20)
  }
  @Builder serverType(detailname:goodDetail) {
    Flex({ direction: FlexDirection.Column }) {
 Text("用户参数")
   Text(){
   Span("机身长度:宽71.5mm长152.8mm厚8.2mm")
   }
   Text(){
   Span("机身重量:193g 6.3英寸屏幕 白色")
   }

    }
    .padding(10)
    .width("100%")
    .backgroundColor(Color.White)
    .borderRadius(20)
  }
  @Builder taskType(detailname:goodDetail) {
    Flex({ direction: FlexDirection.Column }) {
        Text("商品评论")
        Row({space:10}){
          Image($r("app.media.pingjialogo")).width(25).height(25)
          Column({space:10}){
            Row({space:2}){
               Text("j****0").fontSize(14)
               Image($r("app.media.star")).width(20).height(20)

          }

          Text("外观外观:形体小巧,特别适合女生瘦小人用...").fontSize(14)
          }.alignItems(HorizontalAlign.Start).width("70%")

          Image($r("app.media.pingjiaimg")).width(60).height(60)

        }.alignItems(VerticalAlign.Top).margin({top:10})
        Row({space:10}){
        Image($r("app.media.pingjialogo")).width(25).height(25)
        Column({space:10}){
          Row({space:2}){
            Text("j****0").fontSize(14)
            Image($r("app.media.star")).width(20).height(20)

          }

          Text("外观外观:形体小巧,特别适合女生瘦小人用...").fontSize(14)
        }.alignItems(HorizontalAlign.Start).width("70%")

        Image($r("app.media.pingjiaimg")).width(60).height(60)

      }.alignItems(VerticalAlign.Top).margin({top:10})
        Row({space:10}){
        Image($r("app.media.pingjialogo")).width(25).height(25)
        Column({space:10}){
          Row({space:2}){
            Text("j****0").fontSize(14)
            Image($r("app.media.star")).width(20).height(20)

          }

          Text("外观外观:形体小巧,特别适合女生瘦小人用...").fontSize(14)
        }.alignItems(HorizontalAlign.Start).width("70%")

        Image($r("app.media.pingjiaimg")).width(60).height(60)

      }.alignItems(VerticalAlign.Top).margin({top:10})
        Row({space:10}){
        Image($r("app.media.pingjialogo")).width(25).height(25)
        Column({space:10}){
          Row({space:2}){
            Text("j****0").fontSize(14)
            Image($r("app.media.star")).width(20).height(20)

          }

          Text("外观外观:形体小巧,特别适合女生瘦小人用...").fontSize(14)
        }.alignItems(HorizontalAlign.Start).width("70%")

        Image($r("app.media.pingjiaimg")).width(60).height(60)

      }.alignItems(VerticalAlign.Top).margin({top:10})
        Row({space:10}){
        Image($r("app.media.pingjialogo")).width(25).height(25)
        Column({space:10}){
          Row({space:2}){
            Text("j****0").fontSize(14)
            Image($r("app.media.star")).width(20).height(20)

          }

          Text("外观外观:形体小巧,特别适合女生瘦小人用...").fontSize(14)
        }.alignItems(HorizontalAlign.Start).width("70%")

        Image($r("app.media.pingjiaimg")).width(60).height(60)

      }.alignItems(VerticalAlign.Top).margin({top:10})
        Row({space:10}){
        Image($r("app.media.pingjialogo")).width(25).height(25)
        Column({space:10}){
          Row({space:2}){
            Text("j****0").fontSize(14)
            Image($r("app.media.star")).width(20).height(20)

          }

          Text("外观外观:形体小巧,特别适合女生瘦小人用...").fontSize(14)
        }.alignItems(HorizontalAlign.Start).width("70%")

        Image($r("app.media.pingjiaimg")).width(60).height(60)

      }.alignItems(VerticalAlign.Top).margin({top:10})

    }
    .padding(10)
    .width("100%")

    .backgroundColor(Color.White)
    .borderRadius(20)
  }
  build() {
    Stack({alignContent:Alignment.TopStart}){
      Flex({direction:FlexDirection.Column}){
        Scroll() {
          GridRow({ columns: { sm: 6, md: 8, lg: 12 },gutter:12 }) {
            GridCol({ span: { sm: 6, md: 8, lg: 5 } }) {
              this.detailSwpier(this.goodDetailList.image as string[])
            }
            GridCol({ span: { sm: 6, md: 8, lg: 7 } }) {
              Column({space:10}){
                this.detailName(this.goodDetailList)
                this.chooseType(this.goodDetailList)
                this.serverType(this.goodDetailList)
                this.taskType(this.goodDetailList)
              }
            }
          }
        }
        .scrollBar(BarState.Off)
        .width("100%")
        .flexGrow(1)
        .backgroundColor("#F5F5F5")

        GridRow({columns:{sm:6,md:8,lg:12}}){
          GridCol({span:{sm:6,md:6,lg:8},offset:{md:1,lg:2}}){
            this.bootomMenu()
          }
          .width("100%")
          .height(60)
        }
        .width("100%")
      }
      .width("100%")

      Flex({justifyContent:FlexAlign.SpaceBetween}){
        Button("返回")
          .onClick((event:ClickEvent)=>{
            router.back()
          })
        Button("分享")
      }
      .width("100%")

    }
    .width("100%")
    .height("100%")
    .padding({top:10,left:10,right:10})
  }
}