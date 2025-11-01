import {isok,openPermissionsInSystemSettings} from "../utill/permission1"
import { promptAction } from '@kit.ArkUI';
import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { mapCommon } from '@kit.MapKit';
import { map } from '@kit.ConnectivityKit';
import { ble } from '@kit.ConnectivityKit';

function dw(address:(v:string)=>void){
  //获取当前位置
 let request: geoLocationManager.SingleLocationRequest = {
    'locatingPriority': geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
    'locatingTimeoutMs': 10000
  }

    geoLocationManager.getCurrentLocation(request).then((result) => { // 调用getCurrentLocation获取当前设备位置，通过promise接收上报的位置
      console.log('current location: ' + JSON.stringify(result));
      //把当前位置经纬度转换成地址
      let reverseGeocodeRequest:geoLocationManager.ReverseGeoCodeRequest = {"latitude":result.latitude, "longitude":result.longitude, "maxItems": 1};

        geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest, (err, data) => {
          if (err) {
            console.log('getAddressesFromLocation err: ' + JSON.stringify(err));
          } else {
            console.log('getAddressesFromLocation data: ' + JSON.stringify(data));
            address(data[0].placeName+"")
          }
        });

    })
}

function  openble(v:(s:Array<ble.ScanResult>)=>void){
   let list:Array<ble.ScanResult> | null = []
  console.log(JSON.stringify(list)+"0900")
  //扫描设备 监听扫描结果
  try {
    ble.on("BLEDeviceFind", (data: Array<ble.ScanResult>)=>{
      // console.info('BLE scan device find result = '+ JSON.stringify(data));
      data.forEach(v=>{
        console.log("id:"+v.deviceId+"name:"+v.deviceName+"Rssi:"+v.rssi)
      })
      const newlist = data.filter(v=>{
        return list?.some(i=>i.deviceId === v.deviceId) === false

      })

      list?.push(...newlist)

      if(list != null) {
        v(list)
      }
    });

    // let scanFilter: ble.ScanFilter = {
    //   deviceId:"",
    //   name:"",
    //   serviceUuid:""
    // };

    //开启扫描
    let scanOptions: ble.ScanOptions = {
      interval: 500,
      dutyMode: ble.ScanDuty.SCAN_MODE_LOW_POWER,
      matchMode: ble.MatchMode.MATCH_MODE_AGGRESSIVE
    }
    ble.startBLEScan(null,scanOptions);

    //设置定时器  关闭扫描状态  因为扫描结果会重复
    const timer = setTimeout(()=>{
     ble.off("BLEDeviceFind")
     ble.stopBLEScan()
   },5000)

     if(timer){
       clearTimeout(timer)
     }
  } catch (err) {
    console.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
  }

}
@Entry
@Component
struct Pageper {
  @State message: string = 'Hello World';
  @State newlist:Array<ble.ScanResult> | null = []
  build() {
    Column() {
      Button("获取当前定位").onClick(()=>{
        isok(["ohos.permission.APPROXIMATELY_LOCATION"],(v)=>{
          if(v===true){
            promptAction.showToast({
              message:"有权限了，可以进行下面的操作了"
            })
            dw(v=>{
              this.message = v
            })

          }
        })
      })
      Text(this.message)
      Button("蓝牙授权").onClick(()=>{
        isok(["ohos.permission.ACCESS_BLUETOOTH"],(v)=>{
          promptAction.showToast({
            message:"蓝牙授权成功"
          })
        })
      })
      Button("蓝牙扫描").onClick(()=>{
        openble(s=>{
         this.newlist = s
        })
      })
      if(this.newlist != null){
        ForEach(this.newlist,(item:ble.ScanResult)=>{
            Column({space:10}){
              Column({space:10}){
                Text("deviceId:"+item.deviceId)
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
                Text("Rssi:"+item.rssi)
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
              }
              .backgroundColor(Color.Blue)
              .width("100%")
              .padding(20)
            }
            .width("100%")
        })
      }







    }
    .height('100%')
    .width('100%')
  }
}