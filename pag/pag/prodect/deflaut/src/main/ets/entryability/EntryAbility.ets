import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import  {cartDButils, preferencesUtils}  from 'common';
import { shoppingCar } from 'shoppingcarpage/src/main/ets/components/shoppingCar';
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    AppStorage.setOrCreate("username","liuxinyue")
    AppStorage.setOrCreate("userpassword","123456")
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    relationalStore.deleteRdbStore(this.context, 'woniu.db', (err: BusinessError) => {
      if (err) {
        console.error(`Failed to delete RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      console.info('Succeeded in deleting RdbStore.');
    });
  }


  onWindowStageCreate(windowStage: window.WindowStage): void {
    cartDButils.initDButil(this.context,"shoppingCar1")
    preferencesUtils.init(this.context,"myStore")
    // const val = preferencesUtils.reading("FRIST","查无此值")




    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent( "pages/LoginPage", (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');

  }
}
