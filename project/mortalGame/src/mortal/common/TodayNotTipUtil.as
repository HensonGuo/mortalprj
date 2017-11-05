package mortal.common
{
	import com.mui.controls.Alert;
	
	import flash.display.Sprite;
	
	import mortal.game.view.common.alertwins.CheckBoxWin;

	/**
	 * 今日不再提醒
	 */
	public class TodayNotTipUtil
	{
		public function TodayNotTipUtil()
		{
			
		}
		
		/**
		 * 
		 * @param tipsType  提示类型  在 TodayNoTipsConst 中定义
		 * @param callBack  点击“确定”后的回调
		 * @param text  在 Alert 控件中显示的文本字符串。此文本将在警告对话框中居中显示。
		 * @param title  标题栏中显示的文本字符串。此文本左对齐。
		 * @param flags   Alert 控件中放置的按钮。有效值为 Alert.OK、Alert.CANCEL、Alert.YES 和 Alert.NO。默认值为 Alert.OK。使用按位 OR 运算符可显示多个按钮。
		 *                例如，传递 (Alert.YES | Alert.NO) 显示“是”和“否”按钮。
		 *                 无论按怎样的顺序指定按钮，它们始终按照以下顺序从左到右显示：“确定”、“是”、“否”、“取消”。 
		 * @param parent Alert 控件在其上居中的对象。
		 * @param closeHandler  按下 Alert 控件上的任意按钮时将调用的事件处理函数。传递给此处理函数的事件对象是 CloseEvent 的一个实例；
		 *                      此对象的 detail 属性包含 Alert.OK、Alert.CANCEL、Alert.YES 或 Alert.NO 值。 
		 * @param iconClass     位于 Alert 控件中文本左侧的图标的类。
		 * @param defaultButtonFlag  defaultButtonFlag 指定默认按钮的位标志。您可以指定一个值，并且只能是 Alert.OK、Alert.CANCEL、Alert.YES 或 Alert.NO 中的一个值。默认值为 Alert.OK。
		 * 							按 Enter 键触发默认按钮，与单击此按钮的效果相同。按 Esc 键触发“取消”或“否”按钮，与选择相应按钮的效果相同。 
		 * @param _alertWinRenderer  弹框渲染器，可以自定义
		 * @param rest
		 */
		public static function toDayNotTip(tipsType:String,callBack:Function,text:String = "", title:* = null, flags:uint = 0x4, parent:Sprite = null, closeHandler:Function = null, iconClass:Class = null, defaultButtonFlag:uint = 0x4,_alertWinRenderer:Class = null,...rest):void
		{
			var isNeedAlert:Boolean = !PulseSharedObject.isTodayNotTips(tipsType);
			if(isNeedAlert)
			{
				if(_alertWinRenderer == null)
				{
					Alert.alertWinRenderer = CheckBoxWin;
				}
				else
				{
					Alert.alertWinRenderer = _alertWinRenderer;
				}
				Alert.show(text,title,flags,parent,innerCloseHandler,iconClass,defaultButtonFlag);
				function innerCloseHandler(index:int,selected:Boolean,exObj:Object = null):void
				{
					if(index == Alert.OK)
					{
						if(rest && rest.length > 0)
						{
							callBack(rest);
						}
						else
						{
							callBack();
						}
					}
					if(selected)
					{
						PulseSharedObject.save(tipsType,true);
					}
					if(closeHandler != null)
					{
						closeHandler(index,selected);
					}
				}
			}
			else
			{
				if(rest && rest.length > 0)
				{
					callBack(rest);
				}
				else
				{
					callBack();
				}
			}
		}
	}
}