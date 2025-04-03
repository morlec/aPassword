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

  build() {
    Column() {
      Text('本应用可生成安全的随机密码，请选择字符类型并调整长度后点击生成按钮。长按密码可复制使用')
        .fontSize(20)
        .margin({ top: 15, bottom: 10 })
        .fontColor(Color.Gray)
        .padding(10)
        .backgroundColor('rgba(0,0,0,0.05)')
        .borderRadius(8)
        .width('90%')

      Text('密码生成器')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 30 })

      Column() {
        Text('密码长度: ' + this.passwordLength)
          .fontSize(16)
          .margin({ bottom: 10 })
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
            .onChange((value: number) => {
              this.passwordLength = value;
            })

          Text(this.passwordLength.toString())
            .fontSize(16)
            .margin({ left: 10 })
        }
        .width('90%')
        .margin({ bottom: 20 })
      }
      .margin({ bottom: 10 })
      Text(`密码长度：${this.passwordLength}`)
        .margin(10)

        Column() {
          Text('字符类型')
            .fontSize(16)
            .margin({ bottom: 10 })
            .alignSelf(ItemAlign.Start)

          Row() {
            Column() {
              Row() {
                Toggle({ type: ToggleType.Switch, isOn: this.includeNumbers })
                  .width(40)
                  .height(24)
                  .onChange(checked => this.includeNumbers = checked)
                Text('数字').margin({ left: 5 })
              }.width('100%')

              Row() {
                Toggle({ type: ToggleType.Switch, isOn: this.includeSymbols })
                  .width(40)
                  .height(24)
                  .onChange(checked => this.includeSymbols = checked)
                Text('符号').margin({ left: 5 })
              }.width('100%').margin({ top: 10 })
            }.width('45%')

            Column() {
              Row() {
                Toggle({ type: ToggleType.Switch, isOn: this.includeLowercase })
                  .width(40)
                  .height(24)
                  .onChange(checked => this.includeLowercase = checked)
                Text('小写').margin({ left: 5 })
              }.width('100%')

              Row() {
                Toggle({ type: ToggleType.Switch, isOn: this.includeUppercase })
                  .width(40)
                  .height(24)
                  .onChange(checked => this.includeUppercase = checked)
                Text('大写').margin({ left: 5 })
              }.width('100%').margin({ top: 10 })
            }.width('45%')
          }
          .width('90%')
          .justifyContent(FlexAlign.SpaceBetween)
          .margin({ bottom: 20 })
        }
        .width('100%')

        Text(this.password)
          .fontSize(24)
          .margin({ top: 20, bottom: 20 })
          .padding(15)
          .borderRadius(8)
          .backgroundColor('#F5F5F5')
          .width('90%')
          .textAlign(TextAlign.Center)

        Row() {
          Button('复制密码')
            .width('45%')
            .height(48)
            .backgroundColor('#0A59F7')
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
            .width('45%')
            .height(48)
            .backgroundColor('#0A59F7')
            .onClick(() => this.generatePassword())
        }
        .width('90%')
        .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .height('100%')
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