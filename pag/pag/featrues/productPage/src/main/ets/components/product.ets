@Entry
@Component
export  struct NavigationExample {
  @State arr: number[] = [1, 2, 3,4,5,6,7,8,9,10,11,12,13,14,15];



  build() {
    Column() {
     Text("消息").fontSize(20).fontWeight(FontWeight.Bold)
      List({space:20}){

       ForEach(this.arr,(item:number,index:number)=>{
         ListItem(){
           Row({space:10}){
             Image($r("app.media.pingjialogo")).width(30).height(30)
             Column({space:5}){
               Text("联想供应商客服").fontWeight(FontWeight.Bold)
               Text("好滴小主人")
             }.width("70%").alignItems(HorizontalAlign.Start)
             Text("17:39")

           }.width("90%").height(50).alignItems(VerticalAlign.Top).borderWidth({bottom:1}).borderColor("#F8F8FF")
         }.width("100%")
         .swipeAction({
           end: {
             // index为该ListItem在List中的索引值。
             builder: () => {
               this.itemEnd(index)
             },
           }

         })
       })

      }.margin({top:30}).scrollBar(BarState.Off)
    }

    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#F1F3F5')
  }
  @Builder itemEnd(index: number) {
    // 构建尾端滑出组件
    Row() {
      Image($r("app.media.detele"))
        .width(50)
        .height(50)
    }
    .width(88)
    .height(88)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.arr.splice(index, 1);
    })
  }
}

// PageOne.ets
@Component
export struct pageOneTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent1")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle1")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}

// PageTwo.ets
@Component
export struct pageTwoTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent2")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle2")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}



// PageThree.ets
@Component
export struct pageThreeTmp {
  @Consume('pageInfos') pageInfos: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        Text("NavDestinationContent3")
      }.width('100%').height('100%')
    }.title("NavDestinationTitle3")
    .onBackPressed(() => {
      const popDestinationInfo = this.pageInfos.pop() // 弹出路由栈栈顶元素
      console.log('pop' + '返回值' + JSON.stringify(popDestinationInfo))
      return true
    })
  }
}