import { abilityAccessCtrl, bundleManager, Permissions,common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
const context: common.UIAbilityContext = getContext() as common.UIAbilityContext;

async function checkPermissionGrant(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

  // 获取应用程序的accessTokenID
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
  }

  return grantStatus;
}





//判断是否有指定权限
async function checkPermissions(permissions:Array<Permissions>): Promise<boolean> {
  let grantStatus: abilityAccessCtrl.GrantStatus = await checkPermissionGrant(permissions[0]);
  if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
    // 已经授权，可以继续访问目标操作
   return true
  } else {
    //没有授权
    return false
    // 申请弹出麦克风权限
  }
}





//判断是否弹出权限框
 async  function reqPermissionsFromUser(permissions: Array<Permissions>): Promise<boolean> {
  let atManager: abilityAccessCtrl.AtManager =  abilityAccessCtrl.createAtManager();
  // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
  let data = await atManager.requestPermissionsFromUser(context, permissions)
    let grantStatus: Array<number> = data.authResults;
    let length: number = grantStatus.length;
    // for (let i = 0; i < length; i++) {
      if (grantStatus[0] === 0) {
        // 用户授权，可以继续访问目标操作
       return true
      } else {
        //用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
        return false
      }
    // }
    // 授权成功
}

//判断是否有需要手动开启权限
async  function openPermissionsInSystemSettings(context: common.UIAbilityContext) {
  let wantInfo: Want = {
    bundleName: 'com.huawei.hmos.settings',
    abilityName: 'com.huawei.hmos.settings.MainAbility',
    uri: 'application_info_entry',
    parameters: {
      pushParams: 'com.example.myapplication3' // 打开指定应用的详情页面
    }
  }
 await context.startAbility(wantInfo)
}


async  function isok(permissions: Array<Permissions>,istrue:(v:boolean)=>void){
  checkPermissions(permissions).then(res=>{
    if(res===true){
      promptAction.showToast({
        message:"有权限咯",
      })
      // return true
      istrue(true)
    }else{
      reqPermissionsFromUser(permissions).then(res=>{
        if(res===true){
          promptAction.showToast({
            message:"权限开启成功咯"
          })
          istrue(true)
        }else{
          promptAction.showDialog({
            message:"oh my gad！ 权限开启失败啦 是否手动开启权限？",
            buttons:[
              {
                text:"取消",
                color:"#ff000"
              },
              {
                text:"确定",
                color:"#000099"
              }
            ]
          }).then(res=>{
            if(res.index != 0){
              openPermissionsInSystemSettings(context)
            }
            return
          })

        }
      })
    }
  })

}


export  {checkPermissions,reqPermissionsFromUser,openPermissionsInSystemSettings,isok}