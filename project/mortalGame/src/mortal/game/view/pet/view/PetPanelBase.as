/**
 * @heartspeak
 * 2014-3-3 
 */   	

package mortal.game.view.pet.view
{
	import Message.Game.SPet;
	
	import com.gengine.core.IDispose;
	import com.mui.controls.GSprite;
	
	import flash.display.DisplayObject;
	
	import mortal.component.window.Window;
	
	public class PetPanelBase extends GSprite
	{
		protected var _pet:SPet;
		protected var _window:Window;
		protected var _isLoadComplete:Boolean = false;
		
		public function PetPanelBase(window:Window)
		{
			_window = window;
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl()
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
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
			
			while(_window.contentTopOf3DSprite.numChildren > 0)
			{
				child = _window.contentTopOf3DSprite.getChildAt(targetIndex);
				if (child is IDispose)
				{
					(child as IDispose).dispose(true);
					child = null;
				}
			}
			_isLoadComplete = false;
		}
		
		/**
		 * 更新宠物 
		 * @param pet
		 * 
		 */		
		public function updateMsg(pet:SPet):void
		{
			_pet = pet;
		}
		
		/**
		 * 更新宠物属性 
		 * @param uid
		 * 
		 */
		public function updatePetAttribute(uid:String):void
		{
			
		}
	}
}