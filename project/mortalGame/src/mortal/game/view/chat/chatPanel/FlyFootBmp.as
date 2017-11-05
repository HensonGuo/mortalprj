/**
 * @date 2011-6-8 下午05:51:20
 * @author  宋立坤
 * 
 */  
package mortal.game.view.chat.chatPanel
{
	import com.mui.core.GlobalClass;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.game.resource.ImagesConst;
	
	public class FlyFootBmp extends Sprite
	{
		private var _upSkin:Bitmap;
		private var _overSkin:Bitmap;
		
		public function FlyFootBmp()
		{
			super();
			
			mouseChildren = false;
			buttonMode = true;
			
			_upSkin = GlobalClass.getBitmap(ImagesConst.MapBtnFlyBoot_upSkin)
			_overSkin = GlobalClass.getBitmap(ImagesConst.MapBtnFlyBoot_overSkin);	
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
		
		/**
		 * 更新 
		 * 
		 */
		public function update():void
		{
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);
		}
	}
}