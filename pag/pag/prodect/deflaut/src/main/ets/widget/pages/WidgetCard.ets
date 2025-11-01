import { ControlButtonParameter, BottomItem } from '../viewmodel/ControlButtonParameter';
import { ControlButtonComponent } from '../view/ControlButtonComponent';

@Entry
@Component
struct WidgetCard {
  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';
  /*
   * The ability name.
   */
  readonly ABILITY_NAME: string = 'EntryAbility';
  /*
   * The message.
   */
  readonly MESSAGE: string = 'add detail';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';
  private bottomItemList: BottomItem[] = [
    {
      formLinkParam: {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: {
          message: this.MESSAGE
        }
      },
      title: $r('app.string.widget_explored'),
      icon: $r('app.media.ic_widget_explored')
    },
    {
      formLinkParam: {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: {
          message: this.MESSAGE
        }
      },
      title: $r('app.string.widget_study'),
      icon: $r('app.media.ic_widget_study')
    },
    {
      formLinkParam: {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: {
          message: this.MESSAGE
        }
      },
      title: $r('app.string.widget_activity'),
      icon: $r('app.media.ic_widget_activity')
    },
    {
      formLinkParam: {
        action: this.ACTION_TYPE,
        abilityName: this.ABILITY_NAME,
        params: {
          message: this.MESSAGE
        }
      },
      title: $r('app.string.widget_mine'),
      icon: $r('app.media.ic_widget_mine')
    }
  ];
  @State controlButtonParameter: ControlButtonParameter = new ControlButtonParameter(
    this.bottomItemList, BlurStyle.COMPONENT_ULTRA_THIN, undefined, $r('app.media.ic_widget_background'),
    ImageSize.Cover, $r('app.string.card_list_title'), Color.White, 1, undefined, $r('app.string.card_list_content'),
    Color.White, 1, undefined, $r('app.media.startIcon'), undefined, $r('app.string.widget_more'), Color.White, 1,
    undefined,
    {
      color: Color.White,
      width: $r('app.float.border_width')
    }, true, undefined, undefined, undefined);

  build() {
    FormLink({
      action: this.ACTION_TYPE,
      abilityName: this.ABILITY_NAME,
      params: {
        message: this.MESSAGE
      }
    }) {
      Row() {
        ControlButtonComponent({ controlButtonParameter: this.controlButtonParameter })
      }
      .height(this.FULL_HEIGHT_PERCENT)
    }
  }
}