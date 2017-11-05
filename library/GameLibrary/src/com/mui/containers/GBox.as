package com.mui.containers
{
	import com.mui.containers.globalVariable.GBoxDirection;
	
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	
	public class GBox extends Container
	{
		public function GBox()
		{
			super();
		}
		
		public var layChildChanged:Boolean = false;
		
		protected var _numChildChanged:Boolean = false;
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			_numChildChanged = true;
			
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			_numChildChanged = true;
			
			return super.addChildAt(child,index);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			_numChildChanged = true;
			
			return super.removeChild(child);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			_numChildChanged = true;
			
			return super.removeChildAt(index);
		}
		
		private var _direction:String = GBoxDirection.HORIZONTAL;
		
		public function get direction():String
		{
			return _direction;
		}
		public function set direction(value:String):void
		{
			if (_direction == value)
				return;
			
			_direction = value;
			
			invalidate(InvalidationType.ALL);
		}
		
		private var _horizontalGap:Number = 0;
		
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}
		public function set horizontalGap(value:Number):void
		{
			if(_horizontalGap == value)
				return;
			
			_horizontalGap = value;
			invalidate(InvalidationType.ALL);
		}
		
		private var _verticalGap:Number = 0;
		
		public function get verticalGap():Number
		{
			return _verticalGap;
		}
		public function set verticalGap(value:Number):void
		{
			if(_verticalGap == value)
				return;
			
			_verticalGap = value;
			invalidate(InvalidationType.ALL);
		}
		
		/**
		 *  强制更新位置
		 * 
		 */		
		public function resetPosition2():void
		{
			resetPosition();
		}
		
		protected function resetPosition():void
		{
			var i:int, len:int = 0;
			const numChildren:int = this.numChildren;
			var o:DisplayObject;
			
			if (this.direction == GBoxDirection.VERTICAL)
			{
				for (i = 0; i < numChildren; i++)
				{
					o = this.getChildAt(i);
					o.x = 0;
					o.y = len + verticalGap;
					if(o.visible)
					{
						len = o.y + o.height;
					}
				}
			}
			else if (this.direction == GBoxDirection.HORIZONTAL)
			{
				for (i = 0; i < numChildren; i++)
				{
					o = this.getChildAt(i);
					o.x = len + horizontalGap;
					o.y = 0;
					if(o.visible)
					{
						len = o.x + o.width;
					}
				}
			}
		}
		
		override protected function updateDisplayList():void
		{
			if(_numChildChanged || layChildChanged)
			{
				_numChildChanged = false;
				layChildChanged = false;
				resetPosition();
			}
				
			super.updateDisplayList();
		}
		
		override public function get height():Number
		{
			if(this.direction == GBoxDirection.HORIZONTAL)
			{
				return super.height;
			}
			else if(this.direction == GBoxDirection.VERTICAL)
			{
				if(this.numChildren > 0)
				{
					var lastObj:DisplayObject = this.getChildAt(this.numChildren - 1);
					return lastObj.y + lastObj.height;
				}
				return 0;
			}
			return super.height;
		}
		
		override public function get width():Number
		{
			if(this.direction == GBoxDirection.HORIZONTAL)
			{
				if(this.numChildren > 0)
				{
					var lastObj:DisplayObject = this.getChildAt(this.numChildren - 1);
					return lastObj.x + lastObj.width;
				}
				return 0;
			}
			else if(this.direction == GBoxDirection.VERTICAL)
			{
				return super.width;
			}
			return super.width;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			_direction = GBoxDirection.HORIZONTAL;
			disposeChild(isReuse);
			super.dispose(isReuse);
		}
	}
}