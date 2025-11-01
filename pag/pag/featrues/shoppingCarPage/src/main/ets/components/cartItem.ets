import { cartDButils, cartModel } from "common"
import { relationalStore } from "@kit.ArkData"
import { promptAction } from "@kit.ArkUI"

@Component
export  struct cartitem{
   @ObjectLink item:cartModel
  @State isSelect:boolean = false
  // @Link IDS:number
  private computedTotalPrice = ()=>{}
  build() {
   Row(){
     Checkbox({name:"checkitem",group:"checkbox"})
       .selectedColor(Color.Pink)
       .select(this.item.CHECKED==1?true:false)
       .onClick(()=>{
         if(this.item.CHECKED == 0){
           this.item.CHECKED = 1
           console.log(this.item.CHECKED+"")
         }else {
           this.item.CHECKED = 0
           console.log(this.item.CHECKED+"")
         }
         this.computedTotalPrice()
       })


     Image(this.item.GOOD_BIG_NAME)
       .width(60)

Column() {
  Text(this.item.GOOD_NAME)
    .fontWeight(FontWeight.Bold)
    .fontSize(12)
    .margin({bottom:5})

  Text(this.item.TITLE)
    .fontWeight(FontWeight.Bold)
    .fontSize(12)
    .maxLines(4)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
}
     .alignItems(HorizontalAlign.Start)
     .width(120)


     Row() {
       Text("-")
         .fontSize(40)
         .onClick(()=>{
           if(this.item.COUNT==1){
             promptAction.showDialog({
               title:"dsadasd",
               message:"12312",
               buttons:[{
                 text:"true",
                 color:"Color.Red"
               },
                 {text:"flase",
                   color:"Color.blue"}
               ]
             },(err,data)=>{
               if (err) {
                 console.error('showDialog err: ' + err);
                 return
               }
               console.info('showDialog success callback, click button: ' + data.index);
             })
           }else{
             (this.item.COUNT as number) -= 1
             console.log("text"+this.item.COUNT)
           }

           this.computedTotalPrice()
           const valueBucket5: relationalStore.ValuesBucket = {
             "COUNT": this.item.COUNT as number
           };
           cartDButils.updateDB("shoppingCar1",this.item.ID as number,valueBucket5 )

         })
       Text(`${this.item.COUNT}`)
         .fontSize(16)
       Text("+")
         .fontSize(40)
         .onClick(()=>{
           (this.item.COUNT as number)+= 1
           this.computedTotalPrice()
           const valueBucket5: relationalStore.ValuesBucket = {
             "COUNT": this.item.COUNT as number
           };
           cartDButils.updateDB("shoppingCar1",this.item.ID as number,valueBucket5 )
         })
     }


     Text(`￥${this.item.PRICE}`)
       .fontColor(Color.Red)

   }
   .width("100%")
   .height(100)
   .alignItems(VerticalAlign.Center)
   .backgroundColor("#F5F5F5")
   .justifyContent(FlexAlign.SpaceAround)
  }
}