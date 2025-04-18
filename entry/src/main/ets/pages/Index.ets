import { authentication } from '@kit.AccountKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import promptAction from '@ohos.promptAction';
import pasteboard from '@system/pasteboard';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State password: string = '点击生成';
  @State randomPassword: string = 'Phephe8h';
  @State easyPassword: string = 'reflush-me';
  @State pinPassword: string = '9419';
  @State passwordLength: number = 8;
  @State includeLowercase: boolean = true;
  @State includeUppercase: boolean = false;
  @State includeNumbers: boolean = false;
  @State includeSymbols: boolean = false;
  @State currentIndex: number = 0;
  @State easyPasswordLength: number = 4;
  @State useCapitalLetters: boolean = false;
  @State useNumbersInWord: boolean = false;
  @State pinLength: number = 4;

  build() {
    Column() {
      Column() {
        Text('\n功能强大的强密码生成器，\n保障您的在线账户安全。')
          .fontSize(19)
          .fontColor('#FFFFFF')
          .margin({ bottom: 24 })
          .textAlign(TextAlign.Start)
      }
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 20, right: 20 })
      .width('100%')

      Column() {
        // 整体内容区域
        Column() {
          // 标签区域
          Row() {
            ForEach(['随机', '容易记住', 'PIN'], (title: string, index: number) => {
              Column() {
                Row() {
                  if (title === '随机') {
                    Text('⟳')
                      .fontSize(18)
                      .fontColor(this.currentIndex === index ? '#0A59F7' : '#B8C3FF')
                      .margin({ right: 4 })
                  } else if (title === '容易记住') {
                    Text('💡')
                      .fontSize(16)
                      .fontColor(this.currentIndex === index ? '#0A59F7' : '#B8C3FF')
                      .margin({ right: 4 })
                  } else if (title === 'PIN') {
                    Text('⚅')
                      .fontSize(18)
                      .fontColor(this.currentIndex === index ? '#0A59F7' : '#B8C3FF')
                      .margin({ right: 4 })
                  }
                  Text(title)
                    .fontColor(this.currentIndex === index ? '#0A59F7' : '#B8C3FF')
                    .fontSize(16)
                    .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Regular)
                }
                .justifyContent(FlexAlign.Center)
              }
              .width('33.33%')
              .height(50)
              .backgroundColor(this.currentIndex === index ? '#F5F7FF' : 'rgba(255, 255, 255, 0.15)')
              .borderRadius(index === 0 ? { topLeft: 16, topRight: 0, bottomLeft: 0, bottomRight: 0 } : 
                           index === 2 ? { topLeft: 0, topRight: 16, bottomLeft: 0, bottomRight: 0 } : 0)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                this.currentIndex = index;
              })
            })
          }
          .width('100%')
          .margin({ bottom: 1 })
          
          // 内容区域
          if (this.currentIndex === 0) {
            Column() {
              Text('自定义新密码')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 20 })
                .fontColor('#333333')
                .alignSelf(ItemAlign.Start)

              Row() {
                Text('字符')
                  .fontSize(16)
                  .fontColor('#333333')
                Slider({
                  value: this.passwordLength,
                  min: 4,
                  max: 32,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .width('80%')
                  .selectedColor('#0A59F7')
                  .trackThickness(4)
                  .showTips(true)
                  .onChange((value: number) => {
                    this.passwordLength = value;
                  })

                Text(this.passwordLength.toString())
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ left: 15 })
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ bottom: 30 })

              Text('字符类型')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 15 })
                .fontColor('#333333')
                .alignSelf(ItemAlign.Start)

              Row() {
                Column() {
                  Row() {
                    Toggle({ type: ToggleType.Switch, isOn: this.includeNumbers })
                      .width(44)
                      .height(28)
                      .selectedColor('#0A59F7')
                      .onChange(checked => this.includeNumbers = checked)
                    Text('数字')
                      .fontSize(16)
                      .fontColor('#333333')
                      .margin({ left: 10 })
                  }.width('100%')

                  Row() {
                    Toggle({ type: ToggleType.Switch, isOn: this.includeSymbols })
                      .width(44)
                      .height(28)
                      .selectedColor('#0A59F7')
                      .onChange(checked => this.includeSymbols = checked)
                    Text('符号')
                      .fontSize(16)
                      .fontColor('#333333')
                      .margin({ left: 10 })
                  }.width('100%').margin({ top: 15 })
                }.width('45%')

                Column() {
                  Row() {
                    Toggle({ type: ToggleType.Switch, isOn: this.includeLowercase })
                      .width(44)
                      .height(28)
                      .selectedColor('#0A59F7')
                      .onChange(checked => this.includeLowercase = checked)
                    Text('小写')
                      .fontSize(16)
                      .fontColor('#333333')
                      .margin({ left: 10 })
                  }.width('100%')

                  Row() {
                    Toggle({ type: ToggleType.Switch, isOn: this.includeUppercase })
                      .width(44)
                      .height(28)
                      .selectedColor('#0A59F7')
                      .onChange(checked => this.includeUppercase = checked)
                    Text('大写')
                      .fontSize(16)
                      .fontColor('#333333')
                      .margin({ left: 10 })
                  }.width('100%').margin({ top: 15 })
                }.width('45%')
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .margin({ bottom: 30 })

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                ForEach(this.randomPassword.split(''), (char: string) => {
                  Text(char)
                    .fontSize(24)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(this.getCharColor(char))
                })
              }
              .margin({ bottom: 30 })
              .padding(20)
              .borderRadius(12)
              .backgroundColor('#F5F7FF')
              .borderWidth(1)
              .borderColor('#0A59F7')
              .width('100%')

              Button('复制密码')
                .width('100%')
                .height(50)
                .backgroundColor('#0A59F7')
                .borderRadius(10)
                .onClick(() => {
                  if (this.randomPassword === '点击生成' || this.randomPassword === '请选择至少一个选项') {
                    promptAction.showToast({ message: '请先生成密码' });
                    return;
                  }
                  let systemPasteboard = pasteboard.getSystemPasteboard();
                  let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.randomPassword);
                  systemPasteboard.setData(pasteData).then(() => {
                    promptAction.showToast({ message: '密码已复制到剪贴板' });
                  }).catch(() => {
                    promptAction.showToast({ message: '复制失败，请重试' });
                  });
                })

              Button('刷新密码')
                .width('100%')
                .height(50)
                .backgroundColor('#FFFFFF')
                .borderRadius(10)
                .borderWidth(2)
                .borderColor('#0A59F7')
                .fontColor('#0A59F7')
                .margin({ top: 15 })
                .onClick(() => this.generateRandomPassword())
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius({ bottomLeft: 16, bottomRight: 16 })
          } else if (this.currentIndex === 1) {
            Column() {
              Text('自定义新密码')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 20 })
                .fontColor('#333333')
                .alignSelf(ItemAlign.Start)

              Row() {
                Text('字符')
                  .fontSize(16)
                  .fontColor('#333333')
                Slider({
                  value: this.easyPasswordLength,
                  min: 2,
                  max: 8,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .width('60%')
                  .selectedColor('#0A59F7')
                  .trackThickness(4)
                  .showTips(true)
                  .margin({ left: 16, right: 16 })
                  .onChange((value: number) => {
                    this.easyPasswordLength = value;
                  })
                Text(this.easyPasswordLength.toString())
                  .fontSize(16)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ bottom: 20 })

              Row() {
                Row() {
                  Text('首字母大写')
                    .fontSize(16)
                    .fontColor('#333333')
                  Toggle({ type: ToggleType.Switch, isOn: this.useCapitalLetters })
                    .width(44)
                    .height(28)
                    .selectedColor('#0A59F7')
                    .margin({ left: 'auto' })
                    .onChange(checked => this.useCapitalLetters = checked)
                }
                .width('100%')
              }
              .margin({ bottom: 15 })

              Row() {
                Row() {
                  Text('使用完整单词')
                    .fontSize(16)
                    .fontColor('#333333')
                  Toggle({ type: ToggleType.Switch, isOn: this.useNumbersInWord })
                    .width(44)
                    .height(28)
                    .selectedColor('#0A59F7')
                    .margin({ left: 'auto' })
                    .onChange(checked => this.useNumbersInWord = checked)
                }
                .width('100%')
              }
              .margin({ bottom: 30 })

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                ForEach(this.easyPassword.split('-'), (word: string, index: number) => {
                  if (index > 0) {
                    Text('-')
                      .fontSize(24)
                      .fontWeight(FontWeight.Medium)
                      .fontColor('#0A59F7')
                  }
                  Text(word)
                    .fontSize(24)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#333333')
                })
              }
              .margin({ bottom: 30 })
              .padding(20)
              .borderRadius(12)
              .borderWidth(1)
              .borderColor('#0A59F7')
              .backgroundColor('#F5F7FF')
              .width('100%')

              Button('复制密码')
                .width('100%')
                .height(50)
                .backgroundColor('#0A59F7')
                .borderRadius(10)
                .onClick(() => {
                  if (this.easyPassword === '点击生成' || this.easyPassword === '请选择至少一个选项') {
                    promptAction.showToast({ message: '请先生成密码' });
                    return;
                  }
                  let systemPasteboard = pasteboard.getSystemPasteboard();
                  let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.easyPassword);
                  systemPasteboard.setData(pasteData).then(() => {
                    promptAction.showToast({ message: '密码已复制到剪贴板' });
                  }).catch(() => {
                    promptAction.showToast({ message: '复制失败，请重试' });
                  });
                })

              Button('刷新密码')
                .width('100%')
                .height(50)
                .backgroundColor('#FFFFFF')
                .borderRadius(10)
                .borderWidth(2)
                .borderColor('#0A59F7')
                .fontColor('#0A59F7')
                .margin({ top: 15 })
                .onClick(() => this.generateEasyPassword())
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius({ bottomLeft: 16, bottomRight: 16 })
          } else {
            Column() {
              Text('自定义新密码')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 20 })
                .fontColor('#333333')
                .alignSelf(ItemAlign.Start)

              Row() {
                Text('字符')
                  .fontSize(16)
                  .fontColor('#333333')
                Slider({
                  value: this.pinLength,
                  min: 4,
                  max: 8,
                  step: 1,
                  style: SliderStyle.OutSet
                })
                  .width('60%')
                  .selectedColor('#0A59F7')
                  .trackThickness(4)
                  .showTips(true)
                  .margin({ left: 16, right: 16 })
                  .onChange((value: number) => {
                    this.pinLength = value;
                  })
                Text(this.pinLength.toString())
                  .fontSize(16)
                  .fontColor('#333333')
              }
              .width('100%')
              .margin({ bottom: 30 })

              Text('生成密码')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 15 })
                .fontColor('#333333')
                .alignSelf(ItemAlign.Start)

              Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
                Text(this.pinPassword)
                  .fontSize(24)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#0A59F7')
              }
              .margin({ bottom: 30 })
              .padding(20)
              .borderRadius(12)
              .backgroundColor('#F5F7FF')
              .borderWidth(1)
              .borderColor('#0A59F7')
              .width('100%')

              Button('复制密码')
                .width('100%')
                .height(50)
                .backgroundColor('#0A59F7')
                .borderRadius(10)
                .onClick(() => {
                  if (this.pinPassword === '点击生成' || this.pinPassword === '请选择至少一个选项') {
                    promptAction.showToast({ message: '请先生成密码' });
                    return;
                  }
                  let systemPasteboard = pasteboard.getSystemPasteboard();
                  let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.pinPassword);
                  systemPasteboard.setData(pasteData).then(() => {
                    promptAction.showToast({ message: '密码已复制到剪贴板' });
                  }).catch(() => {
                    promptAction.showToast({ message: '复制失败，请重试' });
                  });
                })

              Button('刷新密码')
                .width('100%')
                .height(50)
                .backgroundColor('#FFFFFF')
                .borderRadius(10)
                .borderWidth(2)
                .borderColor('#0A59F7')
                .fontColor('#0A59F7')
                .margin({ top: 15 })
                .onClick(() => this.generatePinPassword())
            }
            .width('100%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius({ bottomLeft: 16, bottomRight: 16 })
          }
        }
        .width('90%')
        .backgroundColor('#FFFFFF')
        .borderRadius(16)
        .shadow({ radius: 12, color: 'rgba(0, 0, 0, 0.3)', offsetX: 0, offsetY: 4 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#121C40')
      .padding({ top: 10 })
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#121C40')
  }

  private getCharColor(char: string): string {
    if (/[0-9]/.test(char)) {
      return '#0A59F7'; // 数字显示为蓝色
    } else if (/[!@#$%^&*()]/.test(char)) {
      return '#FF4D4F'; // 特殊字符显示为红色
    }
    return '#333333'; // 其他字符保持原来的颜色
  }

  private generateRandomPassword() {
    let charset = '';
    if (this.includeLowercase) charset += 'abcdefghijklmnopqrstuvwxyz';
    if (this.includeUppercase) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (this.includeNumbers) charset += '0123456789';
    if (this.includeSymbols) charset += '!@#$%^&*()';

    if (!charset) {
      this.randomPassword = '请选择至少一个选项';
      return;
    }

    let result = '';
    for (let i = 0; i < this.passwordLength; i++) {
      result += charset.charAt(Math.floor(Math.random() * charset.length));
    }
    this.randomPassword = result;
  }

  private generateEasyPassword() {
    // 常用单词列表
    const words: string[] = [
      'time', 'year', 'way', 'day', 'man', 'thing', 'life', 'world', 'hand', 'part',
      'child', 'eye', 'woman', 'place', 'work', 'week', 'case', 'point', 'fact', 'group',
      'number', 'room', 'water', 'money', 'story', 'fact', 'month', 'book', 'night', 'word',
      'food', 'home', 'air', 'line', 'city', 'earth', 'paper', 'music', 'river', 'fire'
    ];

    // 字母到数字的映射
    const letterToNumber: Record<string, string> = {
      'a': '4',
      'e': '3',
      'i': '1',
      'o': '0',
      's': '5',
      't': '7'
    };

    // 生成指定数量的随机单词
    let selectedWords: string[] = [];
    for (let i = 0; i < this.easyPasswordLength; i++) {
      let word = words[Math.floor(Math.random() * words.length)];
      
      // 如果需要首字母大写
      if (this.useCapitalLetters) {
        word = word.charAt(0).toUpperCase() + word.slice(1);
      }
      
      // 如果不使用完整单词，随机替换一些字母为数字
      if (!this.useNumbersInWord) {
        // 遍历每个可能的替换
        for (let j = 0; j < word.length; j++) {
          let letter = word.charAt(j).toLowerCase();
          if (letterToNumber[letter] && Math.random() < 0.3) { // 30%的概率替换
            word = word.substring(0, j) + letterToNumber[letter] + word.substring(j + 1);
          }
        }
      }
      
      selectedWords.push(word);
    }

    // 用连字符连接单词
    this.easyPassword = selectedWords.join('-');
  }

  private generatePinPassword() {
    let result = '';
    for (let i = 0; i < this.pinLength; i++) {
      result += Math.floor(Math.random() * 10).toString();
    }
    this.pinPassword = result;
  }

  aboutToAppear() {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    this.loginWithHuaweiID();
  }

  /**
   * Sample code for using HUAWEI ID to log in to atomic service.
   * According to the Atomic Service Review Guide, when a atomic service has an account system,
   * the option to log in with a HUAWEI ID must be provided.
   * The following presets the atomic service to use the HUAWEI ID silent login function.
   * To enable the atomic service to log in successfully using the HUAWEI ID, please refer
   * to the HarmonyOS HUAWEI ID Access Guide to configure the client ID and fingerprint certificate.
   */
  private loginWithHuaweiID() {
    // Create a login request and set parameters
    const loginRequest = new authentication.HuaweiIDProvider().createLoginWithHuaweiIDRequest();
    // Whether to forcibly launch the HUAWEI ID login page when the user is not logged in with the HUAWEI ID
    loginRequest.forceLogin = false;
    // Execute login request
    const controller = new authentication.AuthenticationController();
    controller.executeRequest(loginRequest).then((data) => {
      const loginWithHuaweiIDResponse = data as authentication.LoginWithHuaweiIDResponse;
      const authCode: string = loginWithHuaweiIDResponse.data?.authorizationCode as string;
      // Send authCode to the backend in exchange for unionID, session

    }).catch((error: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', 'error: %{public}s', JSON.stringify(error));
      if (error.code === authentication.AuthenticationErrorCode.ACCOUNT_NOT_LOGGED_IN) {
        // HUAWEI ID is not logged in, it is recommended to jump to the login guide page

      }
    });
  }
}