/**
 * @heartspeak
 * 2014-1-10 
 */   	

package mortal.game.scene3D.player.entity
{
	import baseEngine.core.Pivot3D;
	
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Rectangle;
	
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;

	public class Game2DPlayer extends Pivot3D implements IGame2D
	{
		
		protected var _y2d:Number = 0;
		
		protected var _x2d:Number = 0;
		
		protected var _overPriority:int = 0;
		
		protected var _displayRec:Rectangle = new Rectangle();
		
		public function Game2DPlayer()
		{
			super("");
		}
		
		public function set x2d(value:Number):void
		{
			_x2d = value;
			this.x = Scene3DUtil.change2Dto3DX(int(value));
		}
		
		public function get x2d():Number
		{
			return _x2d;
		}
		
		public function set y2d(value:Number):void
		{
			_y2d = value;
			this.z = Scene3DUtil.change2Dto3DY(int(value));
		}
		
		public function get y2d():Number
		{
			return _y2d;
		}
		
		public function hoverTest(disPlayX:Number,disPlayY:Number,mouseX:Number,mouseY:Number):Boolean
		{
			return false;
		}
		
		public function onMouseOver():void
		{
			
		}
		
		public function onMouseOut():void
		{
			
		}
		
		public function set direction(value:Number):void {};
		public function get direction():Number {return 0};
		
		protected function disposeObject():void
		{
			ObjectPool.disposeObject(this);
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			_y2d = 0;
			_x2d = 0;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			if(isReuse)
			{
				disposeObject();
			}
			//super.dispose(isReuse);
		}

		public function get overPriority():int
		{
			return _overPriority;
		}

		public function set overPriority(value:int):void
		{
			_overPriority = value;
		}

	}
}