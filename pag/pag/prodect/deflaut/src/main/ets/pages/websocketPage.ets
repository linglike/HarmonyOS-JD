import { webSocket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

function websocket(){
  let defaultIpAddress = "ws://192.168.1.1:8080";
  let ws = webSocket.createWebSocket();
  //向服务器发送消息
  ws.on('open', (err: BusinessError, value: Object) => {
    console.log("on open, status:" + JSON.stringify(value));
    // 当收到on('open')事件时，可以通过send()方法与服务器进行通信
    ws.send("Hello, server!", (err: BusinessError, value: boolean) => {
      if (!err) {
        console.log("Message send successfully"+value);
      } else {
        console.log("Failed to send the message. Err:" + JSON.stringify(err));
      }
    });
  });

  //接受服务器传过来的信息
  ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
    console.log("接收到服务器传过来的数据:" + value);
    // 当收到服务器的`bye`消息时（此消息字段仅为示意，具体字段需要与服务器协商），主动断开连接
    if (value === 'bye') {
      ws.close((err: BusinessError, value: boolean) => {
        if (!err) {
          console.log("Connection closed successfully");
        } else {
          console.log("Failed to close the connection. Err: " + JSON.stringify(err));
        }
      });
    }
  });
  //关闭websocket
  ws.on('close', (err: BusinessError, value: webSocket.CloseResult) => {
    console.log("on close, code is " + value.code + ", reason is " + value.reason);
  });

  //websocket错误问题
  ws.on('error', (err: BusinessError) => {
    console.log("on error, error:" + JSON.stringify(err));
  });

  //连接websocket服务器
  ws.connect(defaultIpAddress, (err: BusinessError, value: boolean) => {
    if (!err) {
      //连接成功
      console.log("Connected successfully");
    } else {
      //连接失败
      console.log("Connection failed. Err:" + JSON.stringify(err));
    }
  });
}




@Entry
@Component
struct WebsocketPage {
  @State message: string = 'Hello World';
aboutToAppear(): void {

}



  build() {
    Column() {
      Text(this.message)
        .fontSize(30)
        .onClick(()=>{
        websocket()
      })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}