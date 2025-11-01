import {cartDButils} from "common"
import { relationalStore } from '@kit.ArkData';

@Entry
@Component
struct RdbTesting {
  @State myid: number =0;
  @State mycount :number = 0

  build() {
    Column(){
      TextInput({placeholder:"请输入要删除的id",text:$$this.myid})
      Button("点击删除").onClick(()=>{
        cartDButils.deleteDB("shoppingCar1",this.myid)
      })
      TextInput({placeholder:"请输入要修改的数量",text:$$this.myid})
      TextInput({placeholder:"请输入要修改成多少",text:$$this.mycount})
      Button("点击修改").onClick(()=>{
        const valueBucket5: relationalStore.ValuesBucket = {
          "COUNT": this.mycount
        };
        cartDButils.updateDB("shoppingCar1",this.myid,valueBucket5)
      })

    }
    .height('100%')
    .width('100%')
  }
}