package mortal.game.scene3D.layer3D.utils
{
	import Message.Public.SPoint;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Point;
	
	import mortal.game.Game;
	import mortal.game.cache.Cache;
	import mortal.game.model.NPCInfo;
	import mortal.game.resource.SceneConfig;
	import mortal.game.rules.EntityType;
	import mortal.game.scene3D.layer3D.NPCDictionary;
	import mortal.game.scene3D.layer3D.PlayerLayer;
	import mortal.game.scene3D.layer3D.utils.EntityLayerUtil;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.map3D.util.MapFileUtil;
	import mortal.game.scene3D.player.entity.NPCPlayer;

	public class NPCUtil extends EntityLayerUtil
	{
		private var _npcMap:NPCDictionary = new NPCDictionary();
		
		public function NPCUtil(  $layer:PlayerLayer )
		{
			super($layer);
		}
		
		public static function get NPCPlayerLink():String
		{
			return EntityType.NPC + EntityUtil.LinkStr;
		}
		
		/**
		 * 通过npcId获取Npc名字
		 * @param npcId
		 * @return 
		 * 
		 */		
		public static function getNPCPlayerName(npcId:int):String
		{
			return NPCUtil.NPCPlayerLink + npcId;
		}
		
		/**
		 * 通过NPC身体名字获取npcId 
		 * @param playerName
		 * @return 
		 * 
		 */		
		public static function getNPCPlayerId(playerName:String):int
		{
			return int(playerName.split(NPCUtil.NPCPlayerLink)[1]);
		}
		
		/**
		 * 添加单个NPC 
		 * 
		 */
		public function addNPC( npcInfo:NPCInfo ):NPCPlayer
		{
			var npc:NPCPlayer = _npcMap.getNpc(npcInfo.snpc.npcId) as NPCPlayer
			if( npc == null )
			{
				npc = ObjectPool.getObject(NPCPlayer) as NPCPlayer;
				_npcMap.addNpc(npcInfo.snpc.npcId,npc);
			}
			npc.updateInfo(npcInfo);
			
//			Log.debug("增加NPC:" + npcInfo.snpc.name + "name:"+ npc.name+"  " +[npcInfo.snpc.point.x,npcInfo.snpc.point.y]);
			layer.addChild( npc );
			return npc;
		}
		
		public function removeNPC( npcID:int ):void
		{
			var npc:NPCPlayer = _npcMap.removeNpc(npcID);
			if( npc )
			{
				npc.dispose();
			}
		}
		
		override public function removeAll():void
		{
			_npcMap.removeAll();
		}
		
		public function getNpc( npcid:int ):NPCPlayer
		{
			return _npcMap.getNpc(npcid);
		}
		
		override public function updateEntity():void
		{
			if (!Game.sceneInfo)
			{
				return;
			}
			var ary:Array=Game.sceneInfo.npcInfos;
			if (ary.length < 1)
			{
				return;
			}
			var npc:NPCPlayer;
			var point:SPoint;
			var isHideNPC:Boolean;//是否屏蔽npc
			for each (var npcInfo:NPCInfo in ary)
			{
				point = npcInfo.snpc.point;
				//在场景范围内
				if (SceneRange.isInEntityRange(point.x, point.y,npcInfo.width,npcInfo.height) && npcInfo.isAddStage )
				{
					isHideNPC = isHideNPCInCrossSpy( npcInfo );// || npcInfo.snpc.npcId != 1020004;
					npc = getNpc(npcInfo.snpc.npcId);
					if( npc == null )
					{
						if( !isHideNPC )
						{
							npc = addNPC(npcInfo);
						}
					}
					else
					{
						if (npc.parent == null && !isHideNPC )
						{
							layer.addChild(npc);
						}
					}
					if( npc && layer.contains( npc ) && isHideNPC )
					{
						removeNPC(npcInfo.snpc.npcId);
					}
				}
				else
				{
					removeNPC(npcInfo.snpc.npcId);
				}
			}
		}
		
		private function isHideNPCInCrossSpy( $value:NPCInfo ):Boolean
		{
			return false;
		}
		
		/**
		 * 更新NPC是否被添加到场景 
		 * @param npcId
		 * @param isAdd
		 * @param mapId
		 * 
		 */
		public function updateNpcIsAddToStage(npcId:int,isAdd:Boolean,mapId:int = -1):void
		{
			var npcInfo:NPCInfo = SceneConfig.instance.getNpcInfo(npcId,mapId);
			if(npcInfo && npcInfo.isAddStage != isAdd)
			{
				npcInfo.isAddStage = isAdd;
				
				if(mapId == -1 || mapId == MapFileUtil.mapID)
				{
					ThingUtil.isMoveChange = true;
				}
			}
		}
		
		/**
		 * 更新npc名字 
		 * 
		 */		
		public function updateAllNpcName():void
		{
			var npc:NPCPlayer;
			for each(npc in _npcMap.map)
			{
				npc.updateName();
			}
		}
		
	}
}
