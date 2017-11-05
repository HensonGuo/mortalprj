package mortal.game.view.pack
{
	import com.mui.controls.GButton;
	import com.mui.events.DragEvent;
	import com.mui.manager.IDragDrop;
	
	public class CanDropButton extends GButton implements IDragDrop
	{
		public function CanDropButton()
		{
			super();
//			addEvent();
		}
		
//		private var _dragOver:Function;
//		
////		private function addEvent():void
////		{
////			this.addEventListener(DragEvent.Event_Move_Over,DragOver);
////		}
//		
//		public function DragOver(e:DragEvent):void
//		{
//			if(_dragOver)
//			{
//				_dragOver.call(null,e.dragItem);
//			}
//		}
		
//		public function set dragOver(value:Function):void
//		{
//			this._dragOver = fun;
//		}
		
		public function get dragSource():Object
		{
			return null;
		}
		
		public function set dragSource(value:Object):void
		{
		}
		
		public function get isDragAble():Boolean
		{
			return true;
		}
		
		public function get isDropAble():Boolean
		{
			return true;
		}
		
		public function get isThrowAble():Boolean
		{
			return false;
		}
		
		public function canDrop(dragItem:IDragDrop, dropItem:IDragDrop):Boolean
		{
			return false;
		}
	}
}