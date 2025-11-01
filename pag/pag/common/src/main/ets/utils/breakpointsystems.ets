//引入常量
import { breakPiontConstants} from "../constants/breakpointconstant"
import {mediaquery} from "@kit.ArkUI"
export  class breakPointSystem {
  //设置当前屏幕的尺寸，用于全局存储
  private currentBreakPoint: string = ""
  //媒体查询的四个条件
  private smListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(breakPiontConstants.RANGE_SM)
  private mdListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(breakPiontConstants.RANGE_MD)
  private lgListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(breakPiontConstants.RANGE_LG)
  private xlListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync(breakPiontConstants.RANGE_XL)

  //外面调用这个函数用来判断屏幕属于哪个尺寸 通常在应用级项目
   public  register() {
    this.smListener = mediaquery.matchMediaSync(breakPiontConstants.RANGE_SM)
    this.smListener.on("change", this.isListenerSM)
    this.mdListener = mediaquery.matchMediaSync(breakPiontConstants.RANGE_MD)
    this.mdListener.on("change", this.isListenerMD)
    this.lgListener = mediaquery.matchMediaSync(breakPiontConstants.RANGE_LG)
    this.lgListener.on("change", this.isListenerLG)
    this.xlListener = mediaquery.matchMediaSync(breakPiontConstants.RANGE_XL)
    this.xlListener.on("change", this.isListenerXL)

  }


  //解除绑定
  public unregister() {
    this.smListener.off("change", this.isListenerSM)
    this.mdListener.off("change", this.isListenerMD)
    this.lgListener.off("change", this.isListenerLG)
    this.xlListener.off("change", this.isListenerXL)
  }

  private isListenerSM = (MediaQueryResult: mediaquery.MediaQueryResult) => {
    console.log("1111");
    if (MediaQueryResult.matches) {
      //判断屏幕尺寸是不是sm,如果成立就把尺寸存储起来
      this.update(breakPiontConstants.BREAKPOINT_SM)
    }
  }
  private isListenerMD = (MediaQueryResult: mediaquery.MediaQueryResult) => {
    console.log("2222");
    if (MediaQueryResult.matches) {
      //判断屏幕尺寸是不是MD,如果成立就把尺寸存储起来
      this.update(breakPiontConstants.BREAKPOINT_MD)

    }
  }
  private isListenerLG = (MediaQueryResult: mediaquery.MediaQueryResult) => {
    console.log("3333");
    if (MediaQueryResult.matches) {
      //判断屏幕尺寸是不是LG,如果成立就把尺寸存储起来
      this.update(breakPiontConstants.BREAKPOINT_LG)

    }
  }
  private isListenerXL = (MediaQueryResult: mediaquery.MediaQueryResult) => {
    console.log("4444");
    if (MediaQueryResult.matches) {
      //判断屏幕尺寸是不是XL,如果成立就把尺寸存储起来
      this.update(breakPiontConstants.BREAKPOINT_XL)

    }
  }


  private update(mediaquery:string){
    console.log("5555");
    if(this.currentBreakPoint !== mediaquery){
      console.log(this.currentBreakPoint+"123"+mediaquery);
      this.currentBreakPoint = mediaquery
      AppStorage.setOrCreate<string>(breakPiontConstants.CURRENT_BREAKPOINT,this.currentBreakPoint)
    }
  }

}
