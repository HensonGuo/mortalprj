/**
 * @heartspeak
 * 2014-1-6 
 */   	
package mortal.game.scene3D.layer3D.utils
{
	import Message.Public.SPoint;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.game.Game;
	import mortal.game.resource.StaticResUrl;
	import mortal.game.scene3D.layer3D.JumpDictionary;
	import mortal.game.scene3D.layer3D.PlayerLayer;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.item.JumpPlayer;
	
	public class JumpUtil extends EntityLayerUtil
	{
		private var _map:JumpDictionary = new JumpDictionary();
		
		
		public function JumpUtil($layer:PlayerLayer)
		{
			super($layer);
		}
		
		public function getJump(x:int,y:int):JumpPlayer
		{
			return _map.getJump(x,y);
		}
		
		/**
		 * 添加单个特效
		 * 
		 */		
		public function addJump( p:SPoint ):JumpPlayer
		{
			var src:String = StaticResUrl.Jump;
			var jump:JumpPlayer = _map.getJump(p.x,p.y) as JumpPlayer;
			if( jump == null )
			{
				jump = ObjectPool.getObject(JumpPlayer) as JumpPlayer;
				_map.addJump(p.x,p.y,jump);
			}
			jump.updatePoint(p);
			Log.debug("增加跳跃点:",p.x,p.y);
			layer.addChild( jump );
			return jump;
		}
		
		public function removeJump( x:int,y:int ):void
		{
			var jump:JumpPlayer = _map.removeJump(x,y);
			if( jump )
			{
				jump.dispose();
			}
		}
		
		public function addToStage( jump:JumpPlayer):void
		{
			layer.addChild(jump);
		}
		
		override public function removeAll():void
		{
			_map.removeAll();
		}
		
		override public function updateEntity():void
		{
			if (!Game.sceneInfo)
			{
				return;
			}
			var ary:Array = Game.sceneInfo.jumpPoints;
			if (ary.length < 1)
				return;
			var jump:JumpPlayer;
			var point:Point;
			for each (var p:SPoint in ary)
			{
				//在场景范围内
				if (SceneRange.isInEffectRange(p.x, p.y))
				{
					jump = getJump(p.x,p.y);
					if (jump == null)
					{
						jump = addJump(p);
					}
					else
					{
						if (jump.parent == null)
						{
							addToStage(jump);
						}
					}
				}
				else
				{
					removeJump(p.x,p.y);
				}
			}
		}
	}
}
