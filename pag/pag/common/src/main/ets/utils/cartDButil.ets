import { relationalStore } from "@kit.ArkData";
import { BusinessError } from '@kit.BasicServicesKit';
import {cartModel} from "../cartModel/cartModel"
import { JSON } from '@kit.ArkTS';

class  cartDButil{
  private store:relationalStore.RdbStore  | null = null  //用来存储数据库的实例
  /**
   * 数据库初始化
   * @param context
   * @param tableName
   */
  initDButil(context:Context,tableName:string){
    //1.初始化数据库配置
    const STORE_CONFIG :relationalStore.StoreConfig= {
      name: 'woniu.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
      encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
      customDir: 'customDir/subCustomDir', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
      isReadOnly: false // 可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
    };
    //2.定义spl数据库
    //创建一个表名,如果数据库里面有这个表名的话就不创建，没有的话就创建
    //商品名字为字符串类型不能为空
    const SQL_CREATE_TABLE = `CREATE TABLE IF NOT EXISTS ${tableName}
    (ID INTEGER PRIMARY KEY AUTOINCREMENT,
     GOOD_BIG_NAME TEXT ,
     GOOD_NAME TEXT ,
     NAME TEXT,
     TITLE TEXT,
     COUNT INTEGER  NOT NULL,
     PRICE INTEGER  NOT NULL,
     CHECKED INTEGER  NOT NULL
     )
     `

    //3.初始化数据库表
    relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in getting RdbStore.');
      this.store = store //创建数据库表实例
      //创建表
      store.executeSql(SQL_CREATE_TABLE,(err:BusinessError)=>{
        if(!err){
          console.log(`创建${tableName}表成功`);
        }else {
          console.log(`创建${tableName}表失败 ,${err.message}`);
        }
      })
    })
  }
    /**
     * 插入数据
     * @param tableName
     * @param value
     */
  insertDB(tableName:string,value:relationalStore.ValuesBucket){
    if (this.store != null) {
      this.store.insert(tableName,value,(err:BusinessError,rowid:number)=>{
        if (err) {
          console.log(`往${tableName}插入数据失败,错误代码${err.code},错误原因${err.message}`);
          return
        }
        console.log(`往${tableName}插入数据成功,rowid:${rowid}`);
      })
    }
  }
  /**
   *
   * @param tableName
   * @param id
   */
  deleteDB(tableName:string,id:number){
    //获取想要操作的表名
    let predicates1 = new relationalStore.RdbPredicates(tableName);
    //设置删除条件 根据什么字段去删除
    predicates1.equalTo("ID", id);
    if (this.store!== null) {
      this.store.delete(predicates1, (err: BusinessError, rows: number) => {
        if (err) {
          console.error(`删除失败. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`删除成功 rows: ${rows}`);
      })
    }
  }
/**
 *
 * @param tableName
 * @param queryArr
 * @param id
 * @returns
 */
  async  queryDB(tableName:string,queryArr:string[],id?:number){
    let predicates2 = new relationalStore.RdbPredicates(tableName);
    if (id){
      //如果用户输入根据id查询就根据id查询，如果不是就查询所有数据
      predicates2.equalTo("ID", id);
    }
    const queryList:cartModel[] = []
    if (this.store!== null) {
    const  resultSet =   await this.store.query(predicates2, queryArr)
        console.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount},column count: ${resultSet.rowCount}`);
        // resultSet是一个数据集合的游标，默认指向第-1个记录，有效的数据从0开始。
        while (resultSet.goToNextRow()) {
          const ID = resultSet.getLong(resultSet.getColumnIndex('ID'));
          const GOOD_BIG_NAME = resultSet.getString(resultSet.getColumnIndex('GOOD_BIG_NAME'));
          const GOOD_NAME = resultSet.getString(resultSet.getColumnIndex('GOOD_NAME'));
          const NAME = resultSet.getString(resultSet.getColumnIndex('NAME'));
          const TITLE = resultSet.getString(resultSet.getColumnIndex('TITLE'));
          const COUNT = resultSet.getLong(resultSet.getColumnIndex('COUNT'));
          const PRICE = resultSet.getLong(resultSet.getColumnIndex('PRICE'));
          const CHECKED = resultSet.getLong(resultSet.getColumnIndex('CHECKED'));

          const temp:cartModel = new cartModel()
          temp.ID = ID
          temp.GOOD_NAME = GOOD_NAME
          temp.GOOD_BIG_NAME = GOOD_BIG_NAME
          temp.NAME = NAME
          temp.TITLE = TITLE
          temp.COUNT = COUNT
          temp.PRICE = PRICE
          temp.CHECKED = CHECKED

          queryList.push(temp)
          console.info(`id=${ID}, good_big_name=${GOOD_BIG_NAME}, good__name=${GOOD_NAME}, name=${NAME}, title=${TITLE}, count=${COUNT},price=${PRICE},check=${CHECKED}`);
        }
        // 释放数据集的内存
        resultSet.close();
    console.log("asdasd"+JSON.stringify(queryList))
    }
    return queryList
  }
/**
 *
 * @param tabName
 * @param id
 * @param valueBucket
 */
  updateDB(tabName:string,id:number,valueBucket:relationalStore.ValuesBucket){
    let predicates1 = new relationalStore.RdbPredicates(tabName); // 创建表'EMPLOYEE'的predicates
    predicates1.equalTo("ID",id); // 匹配表'EMPLOYEE'中'NAME'为'Lisa'的字段
    if (this.store!== null) {
      this.store.update(valueBucket, predicates1, (err: BusinessError, rows: number) => {
        if (err) {
          console.error(`Failed to update data. Code:${err.code}, message:${err.message}`);
          return;
        }
        console.info(`Succeeded in updating data. row count: ${rows}`);
      })
    }
  }
  }
const cartDButils = new cartDButil()
export {cartDButils}