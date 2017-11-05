/**
 * @heartspeak
 * 2014-2-24 
 */   	
package mortal.game.manager
{
	import com.gengine.global.Global;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.mvc.core.View;
	import mortal.mvc.interfaces.ILayer;
	
	public class SmallIconLayer extends View implements ILayer
	{
		private const HorizenGap:int = 35;
		
		private var vcDisplaObject:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private var _iconContainer:Sprite;
		public var isTween:Boolean = true;
		
		public function SmallIconLayer()
		{
			super();
			tabChildren = false;
			mouseEnabled = false;
			createChildren();
		}
		
		private function createChildren():void
		{
			_iconContainer = new Sprite();
			_iconContainer.mouseEnabled = false;
			this.addChild(_iconContainer);
		}
		
		private function tweenAtIndex(index:int):void
		{
			var i:int = 0;
			vcDisplaObject[i].y = 0;
			if(index == vcDisplaObject.length - 1)
			{
				vcDisplaObject[index].x = HorizenGap * index + 120;
				TweenMax.to(vcDisplaObject[index],1,{x:HorizenGap * index});
			}
			else
			{
				for(i = index;i < vcDisplaObject.length;i++)
				{
					var ary:Array = TweenMax.getTweensOf(vcDisplaObject[i]);
					if(ary.length)
					{
						(ary[0] as TweenMax).kill();
					}
					else
					{
						vcDisplaObject[i].x = HorizenGap * i + 120;
					}
					TweenMax.to(vcDisplaObject[i],1,{x:HorizenGap * i});
				}
			}
		}
		
		//移除的缓动
		private function tweenRemoveAtIndex(index:int):void
		{
			var i:int = 0;
			if(vcDisplaObject.length >= 1)
			{
				vcDisplaObject[i].y = 0;
				for(i = index;i < vcDisplaObject.length;i++)
				{
					var ary:Array = TweenMax.getTweensOf(vcDisplaObject[i]);
					if(ary.length)
					{
						(ary[0] as TweenMax).kill();
					}
					TweenMax.to(vcDisplaObject[i],1,{x:HorizenGap * i});
				}
			}
		}
		
		public function addPopUp(displayObject:DisplayObject, modal:Boolean=false):void
		{
			if( displayObject && this.contains(displayObject) == false )
			{		
				_iconContainer.addChild(displayObject);
				vcDisplaObject.push(displayObject);
				tweenAtIndex(vcDisplaObject.length - 1);
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
			if( _iconContainer.contains(displayObject) )
			{
				return _iconContainer.getChildIndex( displayObject ) == _iconContainer.numChildren-1;
			}
			return false;
		}
		
		public function removePopup(displayObject:DisplayObject,tweenable:Boolean=true):void
		{
			if( _iconContainer.contains(displayObject) )
			{
				_iconContainer.removeChild(displayObject);
				var index:int = vcDisplaObject.indexOf(displayObject);
				if(index >= 0)
				{
					vcDisplaObject.splice(index,1);
				}
				tweenRemoveAtIndex(index);
			}
		}
		
		public function isPopup(displayObject:DisplayObject):Boolean
		{
			return _iconContainer.contains(displayObject);
		}
		
		public function setTop(displayObject:DisplayObject):void
		{
			if( _iconContainer.contains(displayObject) )
			{
				if( _iconContainer.getChildIndex(displayObject) != _iconContainer.numChildren -1 )
				{
					_iconContainer.setChildIndex(displayObject,_iconContainer.numChildren - 1);
				}
			}
		}
		
		override public function stageResize():void
		{
			this.x = 500;
			this.y = SceneRange.display.height - 160;
		}
	}
}