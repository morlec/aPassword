import { authentication } from '@kit.AccountKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import promptAction from '@ohos.promptAction';
import pasteboard from '@ohos.pasteboard';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State password: string = '点击生成';
  @State passwordLength: number = 8;
  @State includeLowercase: boolean = true;
  @State includeUppercase: boolean = false;
  @State includeNumbers: boolean = false;
  @State includeSymbols: boolean = false;
  @State currentIndex: number = 0;

  build() {
    Column() {
      Column() {
        Text('功能强大的强密码生成器，\n保障您的在线账户安全。')
          .fontSize(19)
          .fontColor('#666666')
          .margin({ bottom: 40 })
          .textAlign(TextAlign.Start)
      }
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 20, right: 20 })
      .width('100%')

      Column() {
        Text('选择密码类型')
          .fontSize(16)
          .fontColor('#666666')
          .margin({ bottom: 8 })
          .alignSelf(ItemAlign.Start)
          .padding({ left: 20 })

        Row() {
          ForEach(['随机', '容易记住', 'PIN'], (title: string, index: number) => {
            Column() {
              Row() {
                if (title === '随机') {
                  Text('⟳')
                    .fontSize(18)
                    .fontColor(this.currentIndex === index ? '#0A59F7' : '#666666')
                    .margin({ right: 4 })
                } else if (title === '容易记住') {
                  Text('💡')
                    .fontSize(16)
                    .fontColor(this.currentIndex === index ? '#0A59F7' : '#666666')
                    .margin({ right: 4 })
                } else if (title === 'PIN') {
                  Text('⚅')
                    .fontSize(18)
                    .fontColor(this.currentIndex === index ? '#0A59F7' : '#666666')
                    .margin({ right: 4 })
                }
                Text(title)
                  .fontColor(this.currentIndex === index ? '#0A59F7' : '#666666')
                  .fontSize(16)
                  .fontWeight(this.currentIndex === index ? FontWeight.Medium : FontWeight.Regular)
              }
              .justifyContent(FlexAlign.Center)
            }
            .width('33.33%')
            .height(45)
            .backgroundColor(this.currentIndex === index ? '#F5F7FF' : '#FFFFFF')
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              this.currentIndex = index;
            })
          })
        }
        .width('100%')
        .backgroundColor('#FFFFFF')

        if (this.currentIndex === 0) {
          Column() {
            Column() {

              Column() {
                Text('密码长度: ' + this.passwordLength)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 15 })
                  .fontColor('#333333')
                  .alignSelf(ItemAlign.Start)

                Row() {
                  Slider({
                    value: this.passwordLength,
                    min: 4,
                    max: 32,
                    step: 1,
                    style: SliderStyle.OutSet
                  })
                    .width('85%')
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

                Row() {
                  ForEach(this.password.split(''), (char: string) => {
                    Text(char)
                      .fontSize(28)
                      .fontWeight(FontWeight.Medium)
                      .fontColor(this.getCharColor(char))
                  })
                }
                .margin({ bottom: 30 })
                .padding(20)
                .borderRadius(12)
                .backgroundColor('#F5F7FF')
                .width('100%')
                .justifyContent(FlexAlign.Center)

                Button('复制密码')
                  .width('100%')
                  .height(50)
                  .backgroundColor('#0A59F7')
                  .borderRadius(10)
                  .onClick(() => {
                    if (this.password === '点击生成' || this.password === '请选择至少一个选项') {
                      promptAction.showToast({ message: '请先生成密码' });
                      return;
                    }
                    let systemPasteboard = pasteboard.getSystemPasteboard();
                    let pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, this.password);
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
                  .onClick(() => this.generatePassword())
              }
              .width('100%')
              .padding(20)
              .backgroundColor('#FFFFFF')
              .borderRadius(16)
            }
            .width('99%')
            .margin({ top: 20 })
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#F5F7FF')
          .padding({ left: 20, right: 20 })
        } else if (this.currentIndex === 1) {
          Column() {
            Text('容易记住的密码生成器即将推出...')
              .fontSize(16)
              .fontColor('#666666')
              .margin({ top: 20 })
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#F5F7FF')
          .justifyContent(FlexAlign.Center)
        } else {
          Column() {
            Text('PIN码生成器即将推出...')
              .fontSize(16)
              .fontColor('#666666')
              .margin({ top: 20 })
          }
          .width('100%')
          .height('100%')
          .backgroundColor('#F5F7FF')
          .justifyContent(FlexAlign.Center)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  private getCharColor(char: string): string {
    if (/[0-9]/.test(char)) {
      return '#0A59F7'; // 数字显示为蓝色
    } else if (/[!@#$%^&*()]/.test(char)) {
      return '#FF4D4F'; // 特殊字符显示为红色
    }
    return '#333333'; // 其他字符保持原来的颜色
  }

  private generatePassword() {
    let charset = '';
    if (this.includeLowercase) charset += 'abcdefghijklmnopqrstuvwxyz';
    if (this.includeUppercase) charset += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (this.includeNumbers) charset += '0123456789';
    if (this.includeSymbols) charset += '!@#$%^&*()';

    if (!charset) {
      this.password = '请选择至少一个选项';
      return;
    }

    let result = '';
    for (let i = 0; i < this.passwordLength; i++) {
      result += charset.charAt(Math.floor(Math.random() * charset.length));
    }
    this.password = result;
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