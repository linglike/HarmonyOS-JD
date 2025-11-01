import { common } from '@kit.AbilityKit';
import Want from '@ohos.application.Want';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct DocumentPage {
  @State message: string = '备忘录';
  @State lists:number[] = []
  @State index:number = 0
  build() {
    Column() {
      Text(this.message)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        Button("点击新建备忘录").onClick(()=>{
          this.index = this.index+1
          this.lists.push(this.index)
          let context = getContext(this) as common.UIAbilityContext
          let want:Want = {
            deviceId:"",
            bundleName:"com.example.pag",
            abilityName:"documentAbility",
            parameters:{
              paramsKey:`inx_${this.index}`
            }
          }
          context.startAbility(want,(err)=>{
            if (err) {
              console.log("报错"+err)
            }
          })
          console.log(`inx_${this.index}`)
        })

      ForEach(this.lists,(item:number,index:number)=>{
        Row({space:10}){
          Image($r("app.media.app_icon")).width(50).height(50)
          Text(index+"").fontSize(30)
        }
        .margin({bottom:10})
        .width("100%")
        .onClick(()=>{
          console.log(`inx_${index+1}`)
          let context = getContext(this) as common.UIAbilityContext
          let want:Want = {
            deviceId:"",
            bundleName:"com.example.pag",
            abilityName:"documentAbility",
            parameters:{
              paramsKey:`inx_${index+1}`
            }
          }
          context.startAbility(want,(err)=>{
            if (err) {
              console.log("报错"+err.message)
            }
          })
        })
      },(item:number)=>`${item}`)
    }
    .height('100%')
    .width('100%')
  }
}