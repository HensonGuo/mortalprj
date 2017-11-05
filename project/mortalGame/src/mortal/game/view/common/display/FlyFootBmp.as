package mortal.game.view.common.display
{
	import com.gengine.core.IClean;
	import com.gengine.utils.HTMLUtil;
	import com.mui.core.GlobalClass;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FlyFootBmp extends Sprite implements IToolTipItem
	{
		private var _upSkin:Bitmap;
		private var _overSkin:Bitmap;
		
		public function FlyFootBmp()
		{
			super();
			
			mouseChildren = false;
			buttonMode = true;
			
			_upSkin = GlobalClass.getBitmap("FlyBoot_upSkin")
			_overSkin = GlobalClass.getBitmap("FlyBoot_overSkin");	
			addChild(_upSkin);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			update();
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			dispose();
		}
		
		/**
		 * 鼠标移上 
		 * @param event
		 * 
		 */
		private function onMouseOverHandler(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			if(this.contains(_upSkin))
			{
				this.removeChild(_upSkin);
			}
			if(!this.contains(_overSkin))
			{
				this.addChild(_overSkin);
			}
			_overSkin.y = 1;
		}
		
		/**
		 * 鼠标移出 
		 * @param event
		 * 
		 */
		private function onMouseOutHandler(event:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);
			if(this.contains(_overSkin))
			{
				this.removeChild(_overSkin);
			}
			if(!this.contains(_upSkin))
			{
				this.addChild(_upSkin);
			}
			_overSkin.y = 0;
		}
		
		private static const _toolTipTxt:String = HTMLUtil.addColor(Language.getString(20630),"#ffffff");//消耗一个『筋斗云』立即传送<br><font color='#00ff00'>VIP可免费传送</font>
		
		/**
		 * 更新 
		 * 
		 */
		public function update():void
		{
			toolTipData = _toolTipTxt;
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			ToolTipsManager.unregister(this);
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
		}
		
		public function get toolTipData():*
		{
			return _tooltipData;
		}
		
		private var _tooltipData:*;
		
		public function set toolTipData(value:*):void
		{
			if(value == null || value==""){
				ToolTipsManager.unregister(this);
			}else{
				ToolTipsManager.register(this);
			}
			_tooltipData = value;
		}
	}
}