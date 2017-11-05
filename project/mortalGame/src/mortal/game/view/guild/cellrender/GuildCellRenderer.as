package mortal.game.view.guild.cellrender
{
	import com.gengine.core.IDispose;
	import com.mui.controls.GCellRenderer;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class GuildCellRenderer extends GCellRenderer
	{
		public function GuildCellRenderer()
		{
			super();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			quickDispose();
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
		}
		
	}
}