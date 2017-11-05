package mortal.game.view.guild.otherpanel
{
	import com.gengine.core.IDispose;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mortal.common.display.LoaderHelp;
	import mortal.component.window.SmallWindow;
	import mortal.game.resource.ResFileConst;
	import mortal.mvc.interfaces.ILayer;
	
	public class GuildOtherBasePanel extends SmallWindow
	{
		private var _isLoadComplete:Boolean = false;
		
		public function GuildOtherBasePanel($layer:ILayer=null)
		{
			super($layer);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			configEventListener(MouseEvent.CLICK, onMouseClick);
			LoaderHelp.addResCallBack(ResFileConst.guildOtherPanel, onResLoadComplete);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
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
			if (!isLoadComplete)
				return;
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