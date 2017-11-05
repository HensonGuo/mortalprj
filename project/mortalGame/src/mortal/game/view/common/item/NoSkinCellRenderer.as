package mortal.game.view.common.item
{
	import com.mui.controls.GCellRenderer;
	
	import flash.display.Bitmap;
	
	public class NoSkinCellRenderer extends GCellRenderer
	{
		
		public function NoSkinCellRenderer()
		{
			super();
			inits();
		}
		
		/**
		 * 初始化 
		 * 
		 */
		protected function inits():void
		{
			initMouseEnabled();
		}
		
		/**
		 * 鼠标是否可以点击 
		 * 
		 */		
		protected function initMouseEnabled():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		/**
		 * 复写设置文本 
		 * @param arg0
		 * 
		 */		
		override public function set label(arg0:String):void
		{
			
		}
	}
}