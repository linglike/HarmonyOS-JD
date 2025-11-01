import { AbilityStage, Want } from '@kit.AbilityKit';
import { promptAction } from '@kit.ArkUI';

export default class MyAbilityStage extends AbilityStage {
  onCreate(): void {
    // 应用HAP首次加载时触发，可以在此执行该Module的初始化操作（例如资源预加载、线程创建等）。
  }

  onAcceptWant(want: Want): string {
    // 仅specified模式下触发
    if(want.abilityName === "documentAbility"){
      console.log(`${want?.parameters?.paramsKey}1232132131321`)
      return `${want?.parameters?.paramsKey}`

    }
    return '';
  }
}