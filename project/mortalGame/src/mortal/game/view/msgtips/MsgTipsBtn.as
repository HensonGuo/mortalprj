/**
 * @date	2011-3-30 下午05:28:36
 * @author  宋立坤
 * 
 */	
package mortal.game.view.msgtips
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.core.GlobalClass;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.GameManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.ModuleType;
	import mortal.mvc.core.Dispatcher;
	
	public class MsgTipsBtn extends Sprite implements IToolTipItem
	{
		private var _openIcon:Bitmap;
		private var _closeIcon:Bitmap;
		private var _status:int;//当前状态 1=关闭 -1=开启
		
		private static const OpenTipStr:String = HTMLUtil.addColor(Language.getString(20640),"#00ff00");//隐藏系统历史记录
		private static const CloseTipStr:String = HTMLUtil.addColor(Language.getString(20641),"#00ff00");//"显示系统历史记录"
		
		public function MsgTipsBtn()
		{
			super();
			
			buttonMode = true;
			mouseChildren = false;
			
			ToolTipsManager.register(this);
			
			_closeIcon = GlobalClass.getBitmap(ImagesConst.TreeOpenIcon_up);
			_openIcon = GlobalClass.getBitmap(ImagesConst.TreeCloseIcon);
			
			close();
			
			addEventListener(MouseEvent.CLICK,onMouseClick);
			Dispatcher.addEventListener(EventName.SysHistoryOpen,onSysHistoryOpen);
			Dispatcher.addEventListener(EventName.SysHistoryClose,onSysHistoryClose);
		}
		
		/**
		 * 开启 
		 * 
		 */
		private function open():void
		{
			if(_closeIcon.parent)
			{
				removeChild(_closeIcon);
			}
			if(!_openIcon.parent)
			{
				addChild(_openIcon);
			}
			_status = -1;
			
			_tooltipData = OpenTipStr;
		}
		
		/**
		 * 关闭 
		 * 
		 */
		private function close():void
		{
			if(_openIcon.parent)
			{
				removeChild(_openIcon);
			}
			if(!_closeIcon.parent)
			{
				addChild(_closeIcon);
			}
			_status = 1;
			
			_tooltipData = CloseTipStr;
		}
		
		/**
		 * 鼠标点击
		 * @param event
		 * 
		 */
		private function onMouseClick(event:MouseEvent):void
		{
			GameManager.instance.popupWindow(ModuleType.SysTips);
		}
		
		/**
		 * 打开系统历史记录 
		 * @param event
		 * 
		 */
		private function onSysHistoryOpen(event:DataEvent):void
		{
			open();
		}
		
		/**
		 * 关闭系统历史记录 
		 * @param event
		 * 
		 */
		private function onSysHistoryClose(event:DataEvent):void
		{
			close();
		}
		
		private var _tooltipData:*;
		public function get toolTipData():*
		{
			return _tooltipData;
		}
		
		public function set toolTipData(value:*):void
		{
			_tooltipData = value;
		}
	}
}