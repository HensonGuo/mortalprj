package mortal.game.scene3D.layer3D.utils
{
	import Message.Public.SPassPoint;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.game.Game;
	import mortal.game.scene3D.layer3D.PassDictionary;
	import mortal.game.scene3D.layer3D.PlayerLayer;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.item.PassPlayer;

	public class PassUtil extends EntityLayerUtil
	{
		private var _passMap:PassDictionary = new PassDictionary();
		
//		private var _passList:SMapPassPointList;
		
		private var _isInitPassList:Boolean = false;
		
		public function PassUtil( $layer:PlayerLayer)
		{
			super($layer);
		}
		
		/**
		 * 添加单个传送阵 
		 * 
		 */		
		private function addPassPoint( passPoint:SPassPoint ):PassPlayer
		{
			var pass:PassPlayer = _passMap.getPass(passPoint.passPointId) as PassPlayer
			if( pass == null )
			{
				pass = ObjectPool.getObject(PassPlayer) as PassPlayer;
				_passMap.addPass(passPoint.passPointId,pass);
			}
			pass.updatePassPoint(passPoint);
			
			Log.debug("增加传送阵:" + passPoint.name + "  " +[passPoint.point.x,passPoint.point.y]);
			layer.addChild( pass );
			return pass;
		}
		
		public function initPassList():void
		{
//			if(_isInitPassList == false && _passList )
//			{
//				addMapPass( _passList );
//			}
		}
		
//		public function addMapPass( passList:SMapPassPointList ):void
//		{
//			_passList = passList;
//			if( Game.scene.isInitialize && passList.spaceId == MapFileUtil.mapID )
//			{
//				var passPoint:SPassPoint;
//				var pass:PassPlayer;
//				for each( var mappass:SMapPassPoint in passList.passPoints )
//				{
//					if( mappass.show )
//					{
//						pass = _passMap.getPass(mappass.id);
//						if( pass )
//						{
//							if( pass.parent == null )
//							{
//								layer.addChild( pass );
//							}
//						} 
//						else
//						{
//							passPoint = new SPassPoint();
//							passPoint.mapId = passList.spaceId;
//							passPoint.name = mappass.name;
//							passPoint.passPointId = mappass.id;
//							passPoint.point = mappass.point;
//							passPoint.process = -10;
//							addPassPoint(passPoint);
//						}
//					}
//					else
//					{
//						removePassPoint(mappass.id);
//					}
//				}
//				_isInitPassList = true;
//			}
//			else
//			{
//				_isInitPassList = false;
//			}
//		}
		
		public function removePassPoint( passID:int ):void
		{
			var pass:PassPlayer = _passMap.removePass(passID);
			if( pass )
			{
				pass.dispose();
			}
		}
		
		public function getPass(passId:int):PassPlayer
		{
			return _passMap.getPass(passId);
		}
		
		override public function removeAll():void
		{
			_passMap.removeAll();
			_isInitPassList = false;
		}
		
		private var notAddToStageDictionary:Dictionary = new Dictionary();
		
		/**
		 * 更新PassPlayer是否被添加到场景 
		 * @param npcId
		 * @param isAdd
		 * @param mapId
		 * 
		 */
		public function updatePassIsAddToStage(passId:int,isAdd:Boolean):void
		{
			if(!isAdd)
			{
				notAddToStageDictionary[passId] = 1;
				ThingUtil.isMoveChange = true;
			}
			else
			{
				delete notAddToStageDictionary[passId];
				ThingUtil.isMoveChange = true;
			}
		}
		
		/**
		 * 是否添加到舞台 
		 * @param passId
		 * 
		 */
		private function isAddToStage(passId:int):Boolean
		{
			return !notAddToStageDictionary[passId];
		}
		
		override public function updateEntity():void
		{
			if (!Game.sceneInfo)
			{
				return;
			}
			var ary:Array=Game.sceneInfo.passInfos;
			if (ary.length < 1)
				return;
			
			var pass:PassPlayer;
			var point:Point;
			
			for each (var passPoint:SPassPoint in ary)
			{
//				point=GameMapUtil.getPixelPoint(passPoint.point.x, passPoint.point.y);
				//在场景范围内（且符合显示规则）
				if(SceneRange.isInScene(passPoint.point.x, passPoint.point.y) && isAddToStage(passPoint.passPointId))
				{
					pass = getPass(passPoint.passPointId);
					if(pass == null)
					{
						pass = addPassPoint(passPoint);
					}
					else
					{
						if(pass.parent == null)
						{
							layer.addChild(pass);
						}
					}
				}
				else
				{
					removePassPoint(passPoint.passPointId);
				}
			}
		}
		
	}
}
