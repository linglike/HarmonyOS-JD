//为了http请求工具能动态共享，所以封装到common动态共享库中
//第一步引入http模块
import {http} from "@kit.NetworkKit"
import { BusinessError } from "@kit.BasicServicesKit";
import {basicConstant} from "../constants/basicConstant"
import { listData } from "homepage/src/main/ets/viewModel/viewModel";

export function MyhttpRequest<T>(url:string,method:http.RequestMethod,requestdate:string) {
  //第二步创建http对象
  const httpRequest = http.createHttp()

  return new Promise((resolve:(value:T)=>void,reject:(value:string)=>void)=>{
    //第三步创建请求头
    httpRequest.on('headersReceive', (header: Object) => {
      console.info('header: ' + JSON.stringify(header));
    });
    //第三步设置请求参数
    httpRequest.request(
      basicConstant.BASE_HTTPURL+url,
      {
        method:method,
        header:{
          "Content-type":"application/json"
        },
        readTimeout:9000,
        connectTimeout:9000,
        extraData:requestdate
      },(err:BusinessError,res:http.HttpResponse)=>{
        if (!err) {
          // console.log(`数据请求成功+${JSON.stringify(res)}`);
          resolve(JSON.parse(res.result as string))
          httpRequest.destroy()//请求成功的时候销毁数据请求
          httpRequest.off("headerReceive") //请求成功的时候关闭请求头
        }else {
          // console.log(`数据请求失败,${JSON.stringify(err)}`);
          reject(JSON.stringify(err.message))
          httpRequest.destroy()//请求失败的时候销毁数据请求
          httpRequest.off("headerReceive") //请求失败的时候关闭请求头
        }
      }
    )
  })

}