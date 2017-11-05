package mortal.game.view.common.alertwins
{
	import com.mui.controls.Alert;
	import com.mui.controls.GAlertWin;
	import com.mui.controls.GButton;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.BaseWindow;
	import mortal.component.window.WindowEvent;
	
	public class NotAutoCloseAlertWin extends CheckBoxWin
	{
		public static var curInstance:NotAutoCloseAlertWin;
		public function NotAutoCloseAlertWin(stageWidth:Number, stageHeight:Number)
		{
			super(stageWidth, stageHeight);
			curInstance=this;
			this.showCloseBtn()
		}
		protected override function buttonClickHandler(event:MouseEvent):void
		{
			if (closeHandler != null)
			{
				if(extendObj != null)
				{
					closeHandler(Number(event.target.name.substr(4)),extendObj,checkBox.selected);
				}
				else
				{
					closeHandler(Number(event.target.name.substr(4)),checkBox.selected);
				}
			}
		}
		override protected function onCloseBtnClickHandler(event:MouseEvent):void
		{
			if(closeHandler != null)
			{
				if(extendObj != null)
				{
					closeHandler(Alert.CLOSE,extendObj,checkBox.selected);
				}
				else
				{
					closeHandler(Alert.CLOSE,checkBox.selected);
				}
				closeHandler = null;
			}
			
			super.onCloseBtnClickHandler(event);
		}
		public function closeWin():void
		{
			if(!this.parent)return;
			for (var i:int; i < allButtons.length; i++)
			{
				allButtons[i].removeEventListener(MouseEvent.CLICK, buttonClickHandler);
			}
			removeDragHandleer();
			this.parent.removeChild(this);
		}
	}
}