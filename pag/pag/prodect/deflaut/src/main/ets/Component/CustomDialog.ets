@CustomDialog
export  struct CustomDialogExample {
  controller: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
  })
  @State mygood:string = ""



  build() {
    Column() {
      TextInput({placeholder:"请输入你想要搜索的商品",text:$$this.mygood})
    }
    .height("50%")
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.Pink)
    .padding(10)
  }
}