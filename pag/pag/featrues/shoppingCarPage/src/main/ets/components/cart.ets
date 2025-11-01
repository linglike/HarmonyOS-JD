import { cartModel } from 'common/src/main/ets/cartModel/cartModel';
import { router, Type } from '@kit.ArkUI';
import { cartDButils } from 'common';
import {nodate} from "homepage"
import json from '@ohos.util.json';
import { relationalStore } from '@kit.ArkData';
import { cartitem } from './cartItem';

@Component
export  struct Cart {
  @State message: cartModel[] = []
  @State selectAll:boolean = false
  @State allPrice:number = 0


  @Builder  deleteCatItem(index:number,index2:number){
    Image($r("app.media.detele"))
      .width(100)
      .height("100%")
      .onClick(()=>{
        cartDButils.deleteDB("shoppingCar1",index)
        this.message.splice(index2,1)
        this.computedTotalPrice()
      })
}

aboutToAppear(): void {
  this.carts()
}
// goBuy=()=>{
//   relationalStore.deleteRdbStore(this.context, 'RdbTest.db', (err: BusinessError) => {
//     if (err) {
//       console.error(`Failed to delete RdbStore. Code:${err.code}, message:${err.message}`);
//       return;
//     }
//     console.info('Succeeded in deleting RdbStore.');
//   });
// }
   carts=async()=>{
  const query = await cartDButils.queryDB("shoppingCar1",["ID","GOOD_BIG_NAME","GOOD_NAME","NAME","TITLE","COUNT","PRICE","CHECKED"])
    console.log(json.stringify(query))
    this.message = query
  this.computedTotalPrice()
}

computedTotalPrice=()=>{
    const result =  this.message.reduce((sum:number,item:cartModel)=>{
      if(item.CHECKED == 1) {
         sum += (item.COUNT as number) * (item.PRICE as number)
      }
      return sum


    },0)
  this.allPrice = result
  //全选
  const selectAlls = this.message.every((item:cartModel)=>item.CHECKED==1)
  if(this.message.length>0) {
    this.selectAll = selectAlls
  }else {
    this.selectAll = false
  }




}

  build() {
    Flex({direction:FlexDirection.Column}){
      Text("购物车")
        .width("100%")
        .textAlign(TextAlign.Center)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)
      Scroll(){
  Column(){
    if (this.message.length >0 ) {
      List({space:10}) {
        ForEach(this.message, (item: cartModel,index:number) => {
          ListItem() {
            cartitem({ item: item,computedTotalPrice:this.computedTotalPrice })
          }
          .swipeAction({end:this.deleteCatItem(item.ID,index)})
        },(item:cartModel)=>item.ID +"")
      }
    }else
      {
        nodate()

    }
      }
  .width("100%")
  .height("100%")
      .flexGrow(1)

      }
      .scrollBar(BarState.Off)
      .width("100%")
      .height("100%")
      Row(){
        Row(){
          Checkbox({name:"checkbox",group:"checkboxGroup"})
            .selectedColor(Color.Pink)
            .select(this.selectAll)
            .onClick(()=>{
                this.selectAll = !this.selectAll
              this.message.forEach((item:cartModel)=>{
                item.CHECKED = this.selectAll?1:0
              })
              this.computedTotalPrice()
            })
          Text("全选")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }

        Row({space:5}){
           Text("总价")
             .fontSize(20)
             .fontWeight(FontWeight.Bold)
          Text(`￥${this.allPrice}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Red)
          Button("支付",{type:ButtonType.Capsule,stateEffect:true})
            .backgroundColor(Color.Red)
            .onClick(()=>{
              // this.goBuy()
            })
        }
        .padding({left:10,right:10})
      }
      .width("100%")
      .height(60)
      .justifyContent(FlexAlign.SpaceBetween)

  }
}}