import {BasicDataSource} from "../utils/BasicDataSource"
export  class MyDataSource<T> extends BasicDataSource<T> {
  //存储数据的数组
  private dataArray: T[] = [];
  //返回数组的长度
  public totalCount(): number {
    return this.dataArray.length;
  }
  //获取数组指定下表的数据
  public getData(index: number): T {
    return this.dataArray[index];
  }
  //在数组的指定下标添加一个数据
  public addData(index: number, data: T): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }
  //往数组里面添加数据
  public pushData(data: T): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
  //传一个数组进来，然后循环数组得到数组里面的每一个数据依次添加到dataArray数组中
  public pushAllData(data:T[]): void {
    for (let index = 0; index < data.length; index++) {
      this.pushData(data[index])
    }

  }

}
