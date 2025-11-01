// import { DynamicsComponent, ItemProperty } from 'flexlayout';
// import index from './index.json';
// // 导入默认界面需要的日志模块和错误码模块
// import { promptAction, router } from '@kit.ArkUI';
// import { myTabController } from '../Index';
// import { storeEvaluatesAPI } from '../../api/HomeApi';
// import { DataRest } from '../../common/http/AxiosApi';
// import { Constants } from '../../common/constants/Constants';
// import { evaluateParam } from '../../viewmodel/home/HomeIndexModel';
// import { IGetOrderListRecords, IPage, Order } from '../../api/OrderApi';
//
// class Statistics {
//   turnover: number = 0
//   refundAmount: number = 0
//   totalOrderNum: number = 0
//   newMemberNum: number = 0
// }
import axios, { AxiosError, AxiosRequestConfig, AxiosResponse } from '@ohos/axios';

interface  s{
  "success": boolean,
  "message": string,
  "code": number,
  "timestamp": number,
  "result":operation[]
}

interface operation {
  "turnover": number,
  "refundAmount": number,
  "totalOrderNum": number,
  "newMemberNum": number,
  "afterSalesNum": number,
  "deliveryNum": number,
  "feedbackNum": number,
  "evaluateNum": number,
  "pendingShipmentNum": number,
  "pickedUpNum": number
}
let param:object = new Object()
param["type"] = "YEAR"
param["storeId"] = "1907680793935380488"
function date() {
  // 向给定ID的用户发起请求
  axios.post<s, AxiosResponse<s>, null>("http://119.3.215.87:9005/buyer/order/report/orderStatistics?type=YEAR&storeId=1907680793935380488")
    .then((response: AxiosResponse<s>)=> {
      // 处理成功情况
      console.info("id" + response.data)
      console.info(JSON.stringify(response.data));
    })
    .catch((error: AxiosError)=> {
      // 处理错误情况
      console.info(JSON.stringify(error));
    })
    .then(()=> {
      // 总是会执行
    });
}

@Entry
@Component
struct song {
aboutToAppear(): void {
  date()
}

  build() {


  }
}