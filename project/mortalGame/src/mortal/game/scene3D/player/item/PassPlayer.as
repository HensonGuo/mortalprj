package mortal.game.scene3D.player.item
{
	import Message.Public.SPassPoint;
	
	import baseEngine.core.Pivot3D;
	
	import com.gengine.global.Global;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.component.gconst.FilterConst;
	import mortal.game.resource.StaticResUrl;
	import mortal.game.scene3D.display3d.text3d.dynamicText3d.Text3D;
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;
	import mortal.game.scene3D.player.entity.Game2DOverPriority;
	import mortal.game.scene3D.player.entity.IGame2D;

	/**
	 * 传送阵  一个特效加一个名字
	 * 
	 */
	public class PassPlayer extends BasePlayer
	{
		private var _passPoint:SPassPoint;
		
		private var _text3D:Text3D;
		
		public function PassPlayer()
		{
			super();
			overPriority = Game2DOverPriority.Pass;
		}
		
		public function get passPoint():SPassPoint
		{
			return _passPoint;
		}
		
		override protected function disposeObject():void
		{
			ObjectPool.disposeObject(this,PassPlayer);
		}
		
		public function updatePassPoint(value:SPassPoint):void
		{
			_passPoint = value;
			this.x2d = value.point.x;
			this.y2d = value.point.y;
			
			this.url = value.effectName;
			setTitle(value.name);
		}
		
		override public function hoverTest(disPlayX:Number,disPlayY:Number,mouseX:Number,mouseY:Number):Boolean
		{
			var recWidth:Number = 130;
			var recHeight:Number = 150;
			_displayRec.x = this.x2d - disPlayX - recWidth/2;
			_displayRec.y = this.y2d - disPlayY - 110;
			_displayRec.width = recWidth;
			_displayRec.height = recHeight;
			return _displayRec.contains(mouseX,mouseY);
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			_passPoint = null;
			super.dispose(isReuse);
		}
	}
}
