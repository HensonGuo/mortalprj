package mortal.game.view.guild.tabpanel
{
	import com.gengine.core.IDispose;
	import com.mui.controls.GSprite;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mortal.common.display.LoaderHelp;
	import mortal.component.window.Window;
	
	public class GuildBasePanel extends GSprite
	{
		protected var _isLoadComplete:Boolean = false;
		protected var _uiRes:String;
		
		public function GuildBasePanel(uiRes:String)
		{
			_uiRes = uiRes;
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			configEventListener(MouseEvent.CLICK, onMouseClick);
			LoaderHelp.addResCallBack(_uiRes, onResLoadComplete);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			quickDispose();
			_isLoadComplete = false;
		}
		
		private function onResLoadComplete():void
		{
			_isLoadComplete = true;
			layoutUI();
			update();
		}
		
		/**
		 * 是否加载完成
		 *
		 */
		public function get isLoadComplete():Boolean
		{
			return _isLoadComplete;
		}
		
		
		/**
		 * 布局
		 *
		 */
		protected function layoutUI():void
		{
		}
		
		/**
		 * 刷新
		 *
		 */
		public function update():void
		{
		}
		
		/**
		 * 鼠标点击
		 *
		 */
		protected function onMouseClick(event:MouseEvent):void
		{
			
		}
		
		/**
		 * 快速销毁
		 *
		 */
		private function quickDispose():void
		{
			var targetIndex:int = 0;
			while(this.numChildren > 0)
			{
				var child:DisplayObject = this.getChildAt(targetIndex);
				if (child is IDispose)
				{
					(child as IDispose).dispose(true);
					child = null;
				}
				else
					targetIndex ++;
				if (targetIndex == this.numChildren - 1)
					break;
			}
			removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
	}
}