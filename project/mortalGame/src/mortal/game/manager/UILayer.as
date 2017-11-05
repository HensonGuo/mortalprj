/**
 * @date	2011-3-4 下午06:33:46
 * @author  jianglang
 * 
 */	

package mortal.game.manager
{
	import com.gengine.global.Global;
	
	import flash.display.DisplayObject;
	
	import mortal.mvc.core.View;
	import mortal.mvc.interfaces.ILayer;
	import mortal.mvc.interfaces.IView;

	public class UILayer extends View implements ILayer
	{
		public function UILayer()
		{
			tabChildren = false;
			mouseEnabled = false;
		}
		
		public function addPopUp( displayObject:DisplayObject , modal:Boolean = false ):void
		{
			if( displayObject && this.contains(displayObject) == false )
			{			
				this.addChild(displayObject);
				layerChange();
			}
		}
			
		public function centerPopup( displayObject:DisplayObject ):void
		{
			displayObject.x = (Global.stage.stageWidth - displayObject.width)/2;
			displayObject.y = (Global.stage.stageHeight - displayObject.height)/2;
		}
		
		public function setPosition( displayObject:DisplayObject,x:int,y:int ):void
		{
			displayObject.x = x;
			displayObject.y = y;
		}
		
		public function isTop( displayObject:DisplayObject ):Boolean
		{
			if( this.contains(displayObject) )
			{
				return this.getChildIndex( displayObject ) == this.numChildren-1;
			}
			return false;
		}
		
		public function removePopup( displayObject:DisplayObject,tweenable:Boolean=true):void
		{
			if( this.contains(displayObject) )
			{
				this.removeChild(displayObject);
				layerChange();
			}
		}
		
		public function isPopup( displayObject:DisplayObject  ):Boolean
		{
			return this.contains(displayObject);
		}
		
		public function setTop( displayObject:DisplayObject ):void
		{
			if( this.contains(displayObject) && displayObject.parent == this)
			{
				if( this.getChildIndex(displayObject) != this.numChildren -1 )
				{
					this.setChildIndex(displayObject,this.numChildren - 1);
					layerChange();
				}
			}
		}
		
		public function resize( sw:Number , sh:Number ):void
		{
			var display:DisplayObject;
			for( var i:int=0;i<numChildren;i++ )
			{
				display = this.getChildAt(i);
				if(display is IView)
				{
					display.x *=sw;
					display.y *=sh;
				}
			}
		}
		
		protected function layerChange():void
		{
			
		}
	}
}
