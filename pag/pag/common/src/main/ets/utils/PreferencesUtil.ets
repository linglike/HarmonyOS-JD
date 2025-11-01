import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';


class  preferencesUtil{
  private  dataPreferences: preferences.Preferences | null = null;
  /**
   * 首选项初始化  通常在uiability里面使用
   * @param context   上下文
   * @paramproName    设置首选项的名字
   */
   init(context:Context,preName:string){
       let options: preferences.Options = { name: preName };
       this.dataPreferences = preferences.getPreferencesSync(context, options);
       console.log("1231231232132131321222")

   }

  /**
   * 存储数据
   * @param key  存进去的key值
   * @param value  存进去的value值
   */
   insert(key:string,value:string){
    if(this.dataPreferences != null){
      //判断当前的key值存不存在，如果不存在就正常存储数据
      if (this.dataPreferences.hasSync(key)) {
        console.info(`The key ${key}已经存在了`);
      } else {
        console.info(`The key ${key}不存在，可以正常存储`);
        // 此处以此键值对不存在时写入数据为例
        this.dataPreferences.putSync(key, value);
        //数据持久化
        this.dataPreferences.flush()
        // // 当字符串有特殊字符时，需要将字符串转为Uint8Array类型再存储
        // let uInt8Array1 = new util.TextEncoder().encodeInto("~！@#￥%……&*（）——+？");
        // this. dataPreferences.putSync('uInt8', uInt8Array1);
      }
    }
   }
   
   /**
    * 读取数据
    * @param key  读取的键名
    * @param defalut  数据读取失败(或者查无此值)时出现的默认数据
    * @returns 如果查到的数据就把数据返回来
    */
   reading(key:string,defalut:string){
    let  vals: preferences.ValueType | null = null
     if (this.dataPreferences != null) {
       let val = this.dataPreferences.getSync(key, defalut);
       console.info(`The ${key} is `+val);
       vals = val
       // 当获取的值为带有特殊字符的字符串时，需要将获取到的Uint8Array转换为字符串
       // let uInt8Array2 : preferences.ValueType = this.dataPreferences.getSync('uInt8', new Uint8Array(0));
       // let textDecoder = util.TextDecoder.create('utf-8');
       // val = textDecoder.decodeToString(uInt8Array2 as Uint8Array);
       // console.info("The 'uInt8' value is " + val);
     }
     return vals
   }

  /**
   * 删除数据
   * @param key  需要删除的键名
   */
   deleteing(key:string){
    if(this.dataPreferences != null){
       this.dataPreferences.deleteSync(key)
    }
   }

  /**
   * 修改数据
   * @param key   需要修改的键名
   * @param value 需要改成什么
   */
  revise(key:string,value:string){
    //监听存进去的值有没有发生变化，如果发生变化就调用这个observer
    let observer = (key: string) => {
      console.info('The key' + key + 'changed.');
    }
    //监听存进去的key值的变化
    this.dataPreferences?.on('change', observer);
    // 数据产生变更，由'auto'变为'manual'
    this.dataPreferences?.put(key, value, (err: BusinessError) => {
      if (err) {
        console.error(`Failed to put the value of 'startup'. Code:${err.code},message:${err.message}`);
        return;
      }
      console.info("Succeeded in putting the value of 'startup'.");
      if (this.dataPreferences !== null) {
        this.dataPreferences?.flush((err: BusinessError) => {
          if (err) {
            console.error(`Failed to flush. Code:${err.code}, message:${err.message}`);
            return;
          }
          console.info('Succeeded in flushing.');
        })
      }
    })
  }

}

 const  preferencesUtils = new preferencesUtil()
export {preferencesUtils}