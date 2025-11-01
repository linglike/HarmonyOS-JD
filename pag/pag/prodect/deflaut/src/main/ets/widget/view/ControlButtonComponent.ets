import { BottomItem, ControlButtonParameter } from '../viewmodel/ControlButtonParameter';

@Component
export struct ControlButtonComponent {
  /**
   * The width percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';
  /**
   * Bottom row height.
   */
  readonly BOTTOM_ROW_HEIGHT: string = '40%';
  /**
   * Critical form height.
   */
  readonly CRITICAL_FORM_HEIGHT: number = 160;
  /**
   * Type of height.
   */
  readonly TYPE_HEIGHT: string = 'number';
  @Link controlButtonParameter: ControlButtonParameter;
  @State widgetHeight: boolean = true;

  build() {
    Stack() {
      Image(this.controlButtonParameter.backgroundImage)
        .width(this.FULL_WIDTH_PERCENT)
        .height(this.FULL_HEIGHT_PERCENT)

      Column() {
        Column() {
          Row() {
            Column() {
              Text(this.controlButtonParameter.title)
                .fontSize(this.widgetHeight ? $r('app.float.title_font_size_sm') : $r('app.float.title_font_size_lg'))
                .fontWeight(FontWeight.Bold)
                .fontColor(this.controlButtonParameter.titleColor)
                .opacity(this.controlButtonParameter.titleOpacity)
                .shadow(this.controlButtonParameter.titleShadow)
              if (!this.widgetHeight) {
                Text(this.controlButtonParameter.secondaryText)
                  .fontSize($r('app.float.secondary_text_size'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.controlButtonParameter.secondaryTextColor)
                  .opacity(this.controlButtonParameter.secondaryTextOpacity)
                  .shadow(this.controlButtonParameter.secondaryTextShadow)
              }
            }
            .alignItems(HorizontalAlign.Start)

            Image(this.controlButtonParameter.logo)
              .width(this.widgetHeight ? $r('app.float.logo_size_sm') : $r('app.float.logo_size_lg'))
              .height(this.widgetHeight ? $r('app.float.logo_size_sm') : $r('app.float.logo_size_lg'))
          }
          .width(this.FULL_WIDTH_PERCENT)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Top)
          .padding({
            top: $r('app.float.title_row_padding_top'),
            left: $r('app.float.title_row_padding_left'),
            right: $r('app.float.title_row_padding_right')
          })

          Row() {
            if (this.widgetHeight) {
              Column() {
                Text(this.controlButtonParameter.secondaryText)
                  .fontSize($r('app.float.secondary_text_size'))
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.controlButtonParameter.secondaryTextColor)
                  .opacity(this.controlButtonParameter.secondaryTextOpacity)
                  .shadow(this.controlButtonParameter.secondaryTextShadow)
              }
              .alignItems(HorizontalAlign.Start)
              .height(this.FULL_HEIGHT_PERCENT)
            }
            Column() {
              Row() {
                if (this.controlButtonParameter.buttonIcon) {
                  Image(this.controlButtonParameter.buttonIcon)
                    .width($r('app.float.button_icon_size'))
                    .height($r('app.float.button_icon_size'))
                }
                Text(this.controlButtonParameter.buttonText)
                  .fontSize($r('app.float.button_text_size'))
                  .fontWeight(FontWeight.Regular)
                  .fontColor(this.controlButtonParameter.buttonTextColor)
                  .opacity(this.controlButtonParameter.buttonTextOpacity)
                  .shadow(this.controlButtonParameter.buttonTextShadow)
                  .margin({
                    left: $r('app.float.button_text_margin')
                  })
              }
              .borderRadius($r('app.float.button_border_radius'))
              .border(this.controlButtonParameter.buttonBorder)
              .visibility(this.controlButtonParameter.buttonVisible ? Visibility.Visible : Visibility.Hidden)
              .padding({
                left: $r('app.float.button_padding_left_right'),
                right: $r('app.float.button_padding_left_right'),
                top: $r('app.float.button_padding_top_bottom'),
                bottom: $r('app.float.button_padding_top_bottom')
              })
            }
            .justifyContent(FlexAlign.End)
            .height(this.FULL_HEIGHT_PERCENT)
          }
          .layoutWeight(1)
          .justifyContent(this.widgetHeight ? FlexAlign.SpaceBetween : FlexAlign.End)
          .width(this.FULL_WIDTH_PERCENT)
          .padding({
            left: $r('app.float.secondary_row_padding_left'),
            right: $r('app.float.secondary_row_padding_right'),
            bottom: $r('app.float.secondary_row_padding_bottom')
          })
        }
        .layoutWeight(1)

        Row() {
          ForEach(this.controlButtonParameter.bottomItemList, (item: BottomItem) => {
            FormLink(item.formLinkParam) {
              Column() {
                Image(item.icon)
                  .width(this.widgetHeight ? $r('app.float.bottom_icon_size_sm') : $r('app.float.bottom_icon_size_lg'))
                  .height(this.widgetHeight ? $r('app.float.bottom_icon_size_sm') : $r('app.float.bottom_icon_size_lg'))
                Text(item.title)
                  .fontSize(this.widgetHeight ? $r('app.float.bottom_title_size_sm') :
                  $r('app.float.bottom_title_size_lg'))
                  .fontWeight(FontWeight.Medium)
                  .margin({ top: $r('app.float.bottom_item_text_margin') })
                  .fontColor(this.controlButtonParameter.auxiliaryTextColor ?? Color.White)
              }
            }
          }, (item: BottomItem, index: number) => index + JSON.stringify(item))
        }
        .width(this.FULL_WIDTH_PERCENT)
        .height(this.widgetHeight ? $r('app.float.bottom_row_height') : this.BOTTOM_ROW_HEIGHT)
        .padding({
          bottom: this.widgetHeight ? $r('app.float.bottom_row_padding') : 0,
          left: $r('app.float.bottom_row_padding'),
          right: $r('app.float.bottom_row_padding')
        })
        .justifyContent(FlexAlign.SpaceAround)
        .alignItems(this.widgetHeight ? VerticalAlign.Bottom : VerticalAlign.Center)
        .linearGradient({
          direction: GradientDirection.Bottom,
          repeating: false,
          colors: [[this.controlButtonParameter.linearStartColor ?? '#00000000', 0.0],
            [this.controlButtonParameter.linearEndColor ?? '#99000000', 1.0]]
        })
      }
      .height(this.FULL_HEIGHT_PERCENT)
      .width(this.FULL_WIDTH_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Center)
      .onAreaChange((oldArea: Area, newArea: Area) => {
        let height = newArea.height;
        if (typeof height === this.TYPE_HEIGHT) {
          this.widgetHeight = height < this.CRITICAL_FORM_HEIGHT;
        }
      })
      .backgroundColor(this.controlButtonParameter.backgroundColor)
    }
  }
}