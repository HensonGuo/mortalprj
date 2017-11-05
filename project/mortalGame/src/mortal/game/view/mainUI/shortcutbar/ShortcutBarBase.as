/**
 * @date 2011-4-14 上午09:50:03
 * @author  cHao
 * 
 */  
package mortal.game.view.mainUI.shortcutbar
{
	import com.mui.controls.GUIComponent;
	import com.mui.manager.IDragDrop;
	
	import mortal.mvc.interfaces.ILayer;
	import mortal.mvc.interfaces.IView;
	
	public class ShortcutBarBase extends GUIComponent implements IDragDrop, IView
	{
		public function ShortcutBarBase()
		{
			super();
		}
		
		public function get dragSource():Object
		{
			return null;
		}
		
		public function set dragSource(value:Object):void
		{
		}
		
		public function get isDragAble():Boolean
		{
			return false;
		}
		
		public function get isDropAble():Boolean
		{
			return false;
		}
		
		public function get isThrowAble():Boolean
		{
			return false;
		}
		
		public function canDrop(dragItem:IDragDrop, dropItem:IDragDrop):Boolean
		{
			return false;
		}
		
		
		
		public function update(data:Object, ...parameters):void
		{
		}
		
		public function hide():void
		{
		}
		
		public function show(x:int=0,y:int=0):void
		{
		}
		
		public function set layer(value:ILayer):void
		{
		}
		
		public function get layer():ILayer
		{
			return null;
		}
		
		public function get isHide():Boolean
		{
			return false;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
		}
	}
}