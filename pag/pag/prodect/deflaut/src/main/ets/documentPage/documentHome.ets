@Entry
@Component
struct DocumentHome {
  @State message: string = '新建备忘录';

  build() {
    Column() {
     TextInput({placeholder:"请输入内容"})
    }
    .height('100%')
    .width('100%')
  }
}