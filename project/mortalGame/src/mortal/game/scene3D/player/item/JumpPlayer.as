package mortal.game.scene3D.player.item
{
	import Message.Public.SPoint;
	
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Rectangle;
	
	import mortal.game.resource.StaticResUrl;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.entity.Game2DOverPriority;
	
	/**
	 * 跳跃点  一个特效加一个名字
	 * 
	 */
	public class JumpPlayer extends BasePlayer
	{
		protected var _spoint:SPoint;
		
		public function JumpPlayer()
		{
			super();
			overPriority = Game2DOverPriority.Jump;
		}
		
		override protected function disposeObject():void
		{
			ObjectPool.disposeObject(this,JumpPlayer);
		}
		
		public function updatePoint(value:SPoint):void
		{
			_spoint = value;
			this.x2d = value.x;
			this.y2d = value.y;
			
			this.url = StaticResUrl.Jump;
			setTitle("跳跃点");
		}
		
		override public function hoverTest(disPlayX:Number,disPlayY:Number,mouseX:Number,mouseY:Number):Boolean
		{
			var recWidth:Number = 80;
			var recHeight:Number = 80;
			_displayRec.x = this.x2d - disPlayX - recWidth/2;
			_displayRec.y = this.y2d - disPlayY - recHeight/2;
			_displayRec.width = recWidth;
			_displayRec.height = recHeight;
			return _displayRec.contains(mouseX,mouseY);
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			_spoint = null;
			super.dispose(isReuse);
		}

		public function get spoint():SPoint
		{
			return _spoint;
		}

	}
}
