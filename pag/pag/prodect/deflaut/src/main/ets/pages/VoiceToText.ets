import { media } from '@kit.MediaKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { audio } from '@kit.AudioKit';

class AVPlayerDemo {
  private count: number = 0;
  private isSeek: boolean = true; // 用于区分模式是否支持seek操作。
  private fileSize: number = -1;
  private fd: number = 0


  // 注册avplayer回调函数。
  setAVPlayerCallback(avPlayer: media.AVPlayer) {
    // seek操作结果回调函数。
    avPlayer.on('seekDone', (seekDoneTime: number) => {
      //seekdonetime是一个变量，用于表示视频或音频seek操作完成后的时间点。这个时间点通常是经过seek操作后，媒体播放器到达的
      // 新播放位置的时间。在代码中，它被用作日志输出的一部分，以指示seek操作的成功，并显示seek操作后媒体播放器的当前时间。
      console.info(`AVPlayer seek succeeded, seek time is ${seekDoneTime}`);
    });
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用 reset接口触发重置流程。
    avPlayer.on('error', (err: BusinessError) => {
      console.error(`Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`);
      avPlayer.reset(); // 调用reset重置资源，触发idle状态。
    });
    // 状态机变化回调函数。
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      console.log(state+"st")
      // state =
      //重置
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报。
          console.info('AVPlayer state idle called.');
          avPlayer.release(); // 调用release接口销毁实例对象。
          break;
          //准备
        case 'initialized': // avplayer 设置播放源后触发该状态上报。
          console.info('AVPlayer state initialized called.');
          avPlayer.audioRendererInfo = {
            usage: audio.StreamUsage.STREAM_USAGE_MUSIC, // 音频流使用类型：音乐。根据业务场景配置，参考StreamUsage。
            rendererFlags: 0 // 音频渲染器标志。
          };
          avPlayer.prepare();
          //播放
          break;
        case 'prepared': // prepare调用成功后上报该状态机。
          console.info('AVPlayer state prepared called.');
          avPlayer.play(); // 调用播放接口开始播放。
          break;

        case 'playing': // play成功调用后触发该状态机上报。
          console.info('AVPlayer state playing called.');
          if (this.count !== 0) {
            if (this.isSeek) {
              console.info('AVPlayer start to seek.');
              avPlayer.seek(avPlayer.duration); //seek到音频末尾。
            } else {
              // 当播放模式不支持seek操作时继续播放到结尾。
              console.info('AVPlayer wait to play end.');
            }
          } else {
            // setTimeout(() => {
            //   console.info('AVPlayer playing wait to pause');
            //   avPlayer.pause(); // 播放3s后调用暂停接口暂停播放。
            // }, 3000);
          }
          this.count++;
          break;
          //暂停
        case 'paused': // pause成功调用后触发该状态机上报。
          console.info('AVPlayer state paused called.');
          // setTimeout(() => {
          //   console.info('AVPlayer paused wait to play again');
          //   avPlayer.play(); // 暂停3s后再次调用播放接口开始播放。
          // }, 3000);
          break;
          //播放结束
        case 'completed': // 播放结束后触发该状态机上报。
          console.info('AVPlayer state completed called.');
          avPlayer.stop(); //调用播放结束接口。
          break;
          //停止
        case 'stopped': // stop接口成功调用后触发该状态机上报。
          console.info('AVPlayer state stopped called.');
          avPlayer.reset(); // 调用reset接口初始化avplayer状态。
          break;

        case 'released':
          console.info('AVPlayer state released called.');
          break;
        default:
          console.info('AVPlayer state unknown called.');
          break;
      }
    });
  }

  // 以下demo为使用fs文件系统打开沙箱地址获取媒体文件地址并通过url属性进行播放示例。
  async avPlayerUrlDemo() {
    // 创建avPlayer实例对象。
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数。
    this.setAVPlayerCallback(avPlayer);
    let fdPath = 'fd://';
    // 通过UIAbilityContext获取沙箱地址filesDir，以Stage模型为例。
    let context = getContext(this) as common.UIAbilityContext;
    let pathDir = context.filesDir;
    let path = pathDir + '/01.mp3';
    // 打开相应的资源文件地址获取fd，并为url赋值触发initialized状态机上报。
    let file = await fs.open(path);
    fdPath = fdPath + '' + file.fd;
    this.isSeek = true; // 支持seek操作。
    avPlayer.url = fdPath;
  }

  // 以下demo为使用资源管理接口获取打包在HAP内的媒体资源文件并通过fdSrc属性进行播放示例。
  async avPlayerFdSrcDemo() {
    // 创建avPlayer实例对象。
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数。
    this.setAVPlayerCallback(avPlayer);
    // 通过UIAbilityContext的resourceManager成员的getRawFd接口获取媒体资源播放地址。
    // 返回类型为{fd,offset,length},fd为HAP包fd地址，offset为媒体资源偏移量，length为播放长度。
    let context = getContext(this) as common.UIAbilityContext;
    let fileDescriptor = await context.resourceManager.getRawFd("juzis.mp3");
    let avFileDescriptor: media.AVFileDescriptor = { fd: fileDescriptor.fd, offset: fileDescriptor.offset, length: fileDescriptor.length };
    this.isSeek = true; // 支持seek操作。
    // 为fdSrc赋值触发initialized状态机上报。
    avPlayer.fdSrc = avFileDescriptor;
  }

  // 以下demo为使用fs文件系统打开沙箱地址获取媒体文件地址并通过dataSrc属性进行播放(seek模式)示例。
  async avPlayerDataSrcSeekDemo() {
    // 创建avPlayer实例对象。
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数。
    this.setAVPlayerCallback(avPlayer);
    // dataSrc播放模式的的播放源地址，当播放为Seek模式时fileSize为播放文件的具体大小，下面会对fileSize赋值。
    let src: media.AVDataSrcDescriptor = {
      fileSize: -1,
      callback: (buf: ArrayBuffer, length: number, pos: number | undefined) => {
        let num = 0;
        if (buf == undefined || length == undefined || pos == undefined) {
          return -1;
        }
        num = fs.readSync(this.fd, buf, { offset: pos, length: length });
        if (num > 0 && (this.fileSize >= pos)) {
          return num;
        }
        return -1;
      }
    };
    let context = getContext(this) as common.UIAbilityContext;
    // 通过UIAbilityContext获取沙箱地址filesDir，以Stage模型为例。
    let pathDir = context.filesDir;
    let path = pathDir + '/01.mp3';
    await fs.open(path).then((file: fs.File) => {
      this.fd = file.fd;
    });

    // 获取播放文件的大小。
    this.fileSize = fs.statSync(path).size;
    src.fileSize = this.fileSize;
    this.isSeek = true; // 支持seek操作。
    avPlayer.dataSrc = src;
  }

  // 以下demo为使用fs文件系统打开沙箱地址获取媒体文件地址并通过dataSrc属性进行播放(No seek模式)示例。
  async avPlayerDataSrcNoSeekDemo() {
    // 创建avPlayer实例对象。
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数。
    this.setAVPlayerCallback(avPlayer);
    let context = getContext(this) as common.UIAbilityContext;
    let src: media.AVDataSrcDescriptor = {
      fileSize: -1,
      callback: (buf: ArrayBuffer, length: number) => {
        let num = 0;
        if (buf == undefined || length == undefined) {
          return -1;
        }
        num = fs.readSync(this.fd, buf);
        if (num > 0) {
          return num;
        }
        return -1;
      }
    };
    // 通过UIAbilityContext获取沙箱地址filesDir，以Stage模型为例。
    let pathDir = context.filesDir;
    let path = pathDir + '/01.mp3';
    await fs.open(path).then((file: fs.File) => {
      this.fd = file.fd;
    });
    this.isSeek = false; // 不支持seek操作。
    avPlayer.dataSrc = src;
  }

  // 以下demo为通过url设置网络地址来实现播放直播码流的demo。
  async avPlayerLiveDemo() {
    // 创建avPlayer实例对象。
    let avPlayer: media.AVPlayer = await media.createAVPlayer();
    // 创建状态机变化回调函数。
    this.setAVPlayerCallback(avPlayer);
    this.isSeek = false; // 不支持seek操作。
    avPlayer.url = 'http://xxx.xxx.xxx.xxx:xx/xx/index.m3u8';
  }

  //通过播放控件来实行播放
  async playAudio(avPlayer: media.AVPlayer) {
    avPlayer.play();
  }

  //通过播放控件来实行暂停
  async pauseAudio(avPlayer: media.AVPlayer) {
    avPlayer.pause();
  }
}


@Entry
@Component
struct avplayer {
  @State avPlayer: media.AVPlayer | undefined = undefined
  private av = new AVPlayerDemo()

   avplayers() {
  media.createAVPlayer().then(res=>{
    this.avPlayer = res
  })
  }
  aboutToAppear(): void {
    this.avplayers()
  }

  build() {
    Column({space:10}){
    Button("点击播放").onClick(() => {
      this.av.setAVPlayerCallback((this.avPlayer) as media.AVPlayer)
      this.av.avPlayerFdSrcDemo()
    })
    Button("暂停").onClick(()=>{
      this.av.pauseAudio((this.avPlayer) as media.AVPlayer)
    })
      Button("播放").onClick(()=>{
        this.av.playAudio((this.avPlayer) as media.AVPlayer)
      })

      Button("快进").onClick(()=>{

        this.avPlayer?.seek(5)
      })
      Button("停止").onClick(()=>{

        this.avPlayer?.stop()
      })
  }
  .width("100%")
    .height("100%")
  .alignItems(HorizontalAlign.Center)
  }
}