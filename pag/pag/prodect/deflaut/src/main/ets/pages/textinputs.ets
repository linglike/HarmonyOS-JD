import { Content, router } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import  {listDatea} from 'homepage/src/main/ets/API/homeApi'
import { http } from '@kit.NetworkKit';

@Entry
@Component
struct Textinputs {
  @State goodName: string = '';
  @State ss: string[] = []
 aboutToAppear(): void {
           listDatea().then(res=>{
             console.log("11111111"+res)
           }).catch((r:Error)=>{
             console.log(r.message)
           })
   console.log("12312")

 }
  build() {
    Column() {
      Row() {
        TextInput({ placeholder: "请输入要搜索到商品", text: $$this.goodName })
          .layoutWeight(1)
          .height(50)
        Button("搜索")
          .height(50)
          .onClick(() => {

            if(this.ss.indexOf(this.goodName) != -1){
              return
            }else {
              this.ss.push(this.goodName)
            }
          })
      }
     .justifyContent(FlexAlign.Center)
      .width("100%")
      .height(50)
   .padding({left:20,right:20})


      Row({ space: 20 }) {
      ForEach(this.ss, (item: string) => {
          Text(item)
            .onClick(()=>{
              this.goodName = item
            })
      })
      }
      .width("100%")
      .margin({top:15})
      .padding({left:20,right:20})

      Button("点击跳转支付").onClick(()=>{
        //获取应用上下文
          const context = getContext(this) as common.UIAbilityContext
        let want:Want = {
            deviceId:"",  //设置为空代表当前设备
            bundleName:"com.example.pag",  //表示当前设备的项目名
            abilityName:"PayAbility"  //表示需要跳转的目标窗口(UiAbility)
        }
        //通过startAbility进行窗口跳转的
        context.startAbility(want,(err)=>{
          console.log("报错"+err)
        })
    })
    }
    .height('100%')
    .width('100%')
  }
}