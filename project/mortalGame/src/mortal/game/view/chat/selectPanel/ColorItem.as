/**
 * @date	Mar 24, 2011 6:00:45 PM
 * @author  Administrator
 * 
 */	
package mortal.game.view.chat.selectPanel
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ResConfig;
	import mortal.game.view.common.UIFactory;
	
	public class ColorItem extends GSprite
	{
		private var _bitmap:ScaleBitmap;
		private var color:uint;
		
		public function ColorItem(color:uint)
		{
			this.color = color;
			super();
			this.mouseEnabled = true;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bitmap = ResourceConst.getScaleColor(color,0,0,30,20,this);
			this.configEventListener(MouseEvent.CLICK, onColorItemClickHandler);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_bitmap.dispose(isReuse);
			_bitmap = null;
		}
		
		private function onColorItemClickHandler(e:MouseEvent):void
		{
			dispatchEvent(new DataEvent(EventName.ChatColorSelect, color));
		}
	}
}