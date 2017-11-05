package mortal.game.manager
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.mvc.core.View;
	import mortal.mvc.interfaces.ILayer;
	import mortal.mvc.interfaces.IStageResize;
	
	public class MainUILayer extends View implements ILayer
	{
		private var vcDisplaObject:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
//		private var dicDisplayObjectIndex:Dictionary = new Dictionary();
		
		public function MainUILayer()
		{
			super();
		}
		
		public function addPopUp(displayObject:DisplayObject, modal:Boolean=false):void
		{
			if( displayObject && this.contains(displayObject) == false )
			{		
				this.addChild(displayObject);
				if(displayObject is View)
				{
					(displayObject as View).stageResize();
				}
				vcDisplaObject.push(displayObject);
			}
		}
		
		public function centerPopup(displayObject:DisplayObject):void
		{
		}
		
		public function setPosition(displayObject:DisplayObject, x:int, y:int):void
		{
		}
		
		public function isTop(displayObject:DisplayObject):Boolean
		{
			if( this.contains(displayObject) )
			{
				return this.getChildIndex( displayObject ) == this.numChildren-1;
			}
			return false;
		}
		
		public function removePopup(displayObject:DisplayObject,tweenable:Boolean=true):void
		{
			if( this.contains(displayObject) )
			{
				this.removeChild(displayObject);
				var index:int = vcDisplaObject.indexOf(displayObject);
				if(index >= 0)
				{
					vcDisplaObject.splice(index,1);
				}
			}
		}
		
		public function isPopup(displayObject:DisplayObject):Boolean
		{
			return this.contains(displayObject);
		}
		
		public function setTop(displayObject:DisplayObject):void
		{
			if( this.contains(displayObject) )
			{
				if( this.getChildIndex(displayObject) != this.numChildren -1 )
				{
					this.setChildIndex(displayObject,this.numChildren - 1);
				}
			}
		}
		
		public var isSmallSize:Boolean = false;
		
		public var isSmallHeight:Boolean = false;
		
		/**
		 * stageResize 
		 * 
		 */		
		override public function stageResize():void
		{
			isSmallSize = SceneRange.display.width < 1200;
			isSmallHeight = SceneRange.display.height < 700;

			var length:int = vcDisplaObject.length;
			var i:int;
			for(i = 0;i < length;i++)
			{
				if(vcDisplaObject[i] is IStageResize)
				{
					(vcDisplaObject[i] as View).stageResize();
				}
			}
		}

	}
}