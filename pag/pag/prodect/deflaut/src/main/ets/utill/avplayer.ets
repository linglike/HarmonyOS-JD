// 导入必要模块
import { media } from '@kit.MediaKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

class AudioPlayerDemo {
  private avPlayer: media.AVPlayer | null = null;

  // 初始化播放器
  async initAVPlayer() {
    try {
      // 创建AVPlayer实例
      this.avPlayer = await media.createAVPlayer();
      console.info('AVPlayer created successfully');

      // 设置状态监听
      this.setupEventListeners();
    } catch (error) {
      console.error(`Failed to create AVPlayer: ${(error as BusinessError).message}`);
    }
  }

  // 事件监听配置
  private setupEventListeners() {
    if (!this.avPlayer) return;

    // 状态变化监听
    this.avPlayer.on('stateChange', (state: media.AVPlayerState) => {
      console.info(`Current state: ${state}`);
    });

    // 错误处理
    this.avPlayer.on('error', (err: BusinessError) => {
      console.error(`Playback error: code=${err.code}, message=${err.message}`);
      this.releasePlayer();
    });
  }

  // 播放本地资源（HAP包内文件）
  async playLocalResource() {
    if (!this.avPlayer) return;

    try {
      const context = getContext(this) as common.UIAbilityContext;
      // 获取资源文件描述符（需将音频文件放在rawfile目录）
      const fileDescriptor = await context.resourceManager.getRawFd('demo.mp3');

      // 配置文件描述符
      const avFileDescriptor: media.AVFileDescriptor = {
        fd: fileDescriptor.fd,
        offset: fileDescriptor.offset,
        length: fileDescriptor.length
      };

      // 设置播放源
      this.avPlayer.fdSrc = avFileDescriptor;
      await this.avPlayer.prepare();
      this.avPlayer.play();
    } catch (error) {
      console.error(`Local playback failed: ${(error as BusinessError).message}`);
    }
  }

  // 播放网络资源
  async playOnlineAudio(url: string) {
    if (!this.avPlayer) return;

    try {
      // 设置网络数据源
      this.avPlayer.url = url;
      await this.avPlayer.prepare();
      this.avPlayer.play();
    } catch (error) {
      console.error(`Online playback failed: ${(error as BusinessError).message}`);
    }
  }

  // 控制方法
  togglePlayback() {
    if (!this.avPlayer) return;

    if (this.avPlayer.state === 'playing') {
      this.avPlayer.pause();
    } else {
      this.avPlayer.play();
    }
  }

  stopPlayback() {
    this.avPlayer?.stop();
  }

  // 释放资源
  releasePlayer() {
    if (this.avPlayer) {
      this.avPlayer.release();
      this.avPlayer = null;
      console.info('Player resources released');
    }
  }
}

// 使用示例
const audioPlayer = new AudioPlayerDemo();

// 初始化后选择播放方式
async function startPlayback() {
  await audioPlayer.initAVPlayer();

  // 播放本地资源
  // await audioPlayer.playLocalResource();

  // 播放网络资源
  audioPlayer.playOnlineAudio('https://example.com/audio.mp3');
}

// 停止播放
function stopPlayback() {
  audioPlayer.stopPlayback();
  audioPlayer.releasePlayer();
}