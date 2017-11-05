/**
 * @date	2011-3-14 下午03:23:33
 * @author  jianglang
 * 
 */	

package mortal.game.resource
{
	import com.gengine.resource.ConfigManager;
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ImageInfo;
	
	import extend.language.Language;
	
	import flash.utils.Dictionary;
	
	import mortal.common.global.PathConst;
	import mortal.game.model.NPCInfo;
	import mortal.game.scene3D.map3D.sceneInfo.SceneEffectData;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;

	public class SceneConfig
	{
		private static var _instance:SceneConfig;
		
		private var _rankStr:String = Language.getString(11063);
		
		private var _map:Dictionary = new Dictionary();
		//地图文件配置
		private var _mapArray:Array;//[100101,100102,100103,200101,200102,200103,300101,300102,300103,400101,400102,500101,500102,600101,700101,700102,700103,700104,700201,800101,800102];
		//刷怪文件配置
		private var _refreshMap:Array;//[100101,100102,100103,200101,200102,200103,300101,300102,300103,400101,400102,500101,700101,700102,800101,800102];
		//场景特效文件配置
		private var _sceneEffect:Array;
		
		private var _npcMap:Dictionary = new Dictionary();
		
		public function SceneConfig()
		{
			if( _instance != null )
			{
				throw new Error(" SceneConfig 单例 ");
			}
			
			_mapArray =  GameDefConfig.instance.getLoadMapConfig(1);
			var mapID:int;
			for( var i:int =0;i<_mapArray.length;i++ )
			{
				mapID = int(_mapArray[i]);
				addMiniMapInfo(mapID);
				_mapArray[i] = mapID;
			}
			
			_refreshMap = GameDefConfig.instance.getLoadMapConfig(2);
			for( var j:int =0 ;j<_refreshMap.length ;j++)
			{
				_refreshMap[j] = int(_refreshMap[j]);
			}
			
			_sceneEffect = GameDefConfig.instance.getLoadMapConfig(3);
			for(var k:int =0 ;k<_sceneEffect.length ;k++)
			{
				_sceneEffect[k] = int(_sceneEffect[k]);
			}
			
			init();
		}
		
		private function addMiniMapInfo( mapID:int ):void
		{
			var name:String = mapID+"_mini.jpg";
			var url:String =  mapID+"/"+name;
			var path:String =  PathConst.mapPath + url;
			var info:ImageInfo = new ImageInfo({ name:name,type:".JPG",time:GameMapConfig.instance.getVersionById(mapID),path:path});
			info.loaclPath = PathConst.mapLocalPath + url;
			ResourceManager.addResource(info);
		}
		
		public function get allMap():Dictionary
		{
			return _map;
		}

		public static function get instance():SceneConfig
		{
			if( _instance == null )
			{
				_instance = new SceneConfig();
			}
			return _instance;
		}
		
		public function init():void
		{
			var len:uint = _mapArray.length;
			for (var i:uint = 0 ; i < len ; i ++)
			{
				var mapid:int = _mapArray[i];// as int;
				_map[mapid] = initSceneInfo(mapid);
			}
		}
		
		/**
		 * 获得指定地图的场景信息 
		 * @param mapid
		 * @return 
		 */		
		public function getSceneInfo(mapid:int):SceneInfo
		{
			return _map[mapid] as SceneInfo;
		}
		
		/**
		 * 获得指定地图名字 
		 * @param mapid
		 * @return 
		 * 
		 */		
		public function getMapName(mapid:int):String
		{
			var info:SceneInfo = _map[mapid] as SceneInfo;
			if(info)
			{
				return info.sMapDefine.name;
			}
			return "";
		}
		
		protected function initSceneInfo( mapID:Object ):SceneInfo
		{
			var info:SceneInfo = _map[mapID] as SceneInfo;
			if( info == null )
			{
				var jsonObj:Object = ConfigManager.instance.getJSONByFileName(mapID+"_scene.json");
				if(jsonObj)
				{
					info = new SceneInfo();
					info.readObj(jsonObj);
					if(_refreshMap.indexOf(mapID) != -1)
					{
						info.readBossRefreshPoint( ConfigManager.instance.getJSONByFileName(mapID+"_BossRefreshPoint.json") );
					}
					
					if(_sceneEffect.indexOf(mapID) != -1)
					{
						info.readSceneEffect(ConfigManager.instance.getJSONByFileName(mapID+"_sceneEffect.json"));
					}
				}
				else
				{
					throw new Error("未知的地图编码：" + mapID);
				}
			}
			return info;
		}
		
//		/**
//		 * 初始化NPC是否添加到舞台 
//		 * 
//		 */		
//		private function initNPCIsAddToStage():void
//		{
//			var ary:Array = GameDefConfig.instance.getNPCNotAddToStageArray();
//			for each(var obj:Object in ary)
//			{
//				var npcId:int = obj.id;
//				var mapId:int = obj.text;
//				setNpcIsAddStage(npcId,false);
//			}
//		}
		
		public function getSceneInfoByNpcId(npcId:int):SceneInfo
		{
			var sceneInfo:SceneInfo;
			var sceneId:int;
			var npcInfo:NPCInfo;
			for each(sceneId in _mapArray)
			{
				sceneInfo = getSceneInfo(sceneId);
				for each(npcInfo in sceneInfo.npcInfos)
				{
					if(npcInfo.tnpc!=null && npcInfo.tnpc.code == npcId)
					{
						return sceneInfo;
					}
				}
			}
			return null;
		}

		/**
		 * 根据场景特效返回场景 
		 * @param effectId
		 * @return 
		 * 
		 */
		public function getSceneInfoByEffectKey(key:String):SceneInfo
		{
			var sceneInfo:SceneInfo;
			var sceneId:int;
			var effectInfo:SceneEffectData;
			for each(sceneId in _mapArray)
			{
				sceneInfo = getSceneInfo(sceneId);
				for each(effectInfo in sceneInfo.effectInfos)
				{
					if(effectInfo.key == key)
					{
						return sceneInfo;
					}
				}
			}
			return null;
		}
		
//		public function setNpcIsAddStage( npcID:int,isAdd:Boolean ):void
//		{
//			setNpcIsAddStageByInfo(getNpcInfo(npcID),isAdd);
//		}
		
//		/**
//		 * 是否添加到场景 
//		 * @param npcInfo
//		 * @param isAdd
//		 * 
//		 */
//		public function setNpcIsAddStageByInfo(npcInfo:NPCInfo,isAdd:Boolean):void
//		{
//			if(npcInfo)
//			{
//				npcInfo.isAddStage = isAdd;	
//			}
//		}
		
		/**
		 * 是否添加到场景 
		 * @param effectInfo
		 * @param isAdd
		 * 
		 */
		public function setSceneEffectIsAddStageByInfo(effectInfo:SceneEffectData,isAdd:Boolean):void
		{
//			if(effectInfo)
//			{
//				effectInfo.isAddStage = isAdd;
//			}
		}
		
		/**
		 * 返回NPC信息 
		 * @param npcId
		 * @param sceneId
		 * @return 
		 * 
		 */
		public function getNpcInfo(npcId:int,sceneId:int = -1):NPCInfo
		{
			var sceneInfo:SceneInfo;
			if(sceneId != -1)
			{
				sceneInfo = getSceneInfo(sceneId);
				return sceneInfo.getNpcInfo(npcId);
			}
			else
			{
				var npcInfo:NPCInfo;
				for each(sceneId in _mapArray)
				{
					sceneInfo = getSceneInfo(sceneId);
					for each(npcInfo in sceneInfo.npcInfos)
					{
						if(npcInfo.tnpc != null && npcInfo.tnpc.code == npcId)
						{
							return npcInfo;
						}
					}
				}
			}
			return null;
		}
//		/**
//		 * 8000011 到 8000020 为本服1到10名的，8000021为区域第一名 
//		 * @param statue
//		 * 
//		 */		
//		public function setStatuesNpc( statues:SArenaCrossStatues ):void
//		{
//			//是否强制不显示雕像
//			if(!ParamsConst.instance.isArenaStatueShow)
//			{
//				return;
//			}
//			
//			var player:SArenaCrossStatuePlayer = statues.champion;
//			
//			//updateNpcInfo(player,8000021); //更新区冠军
//			var npcInfo:NPCInfo = getNpcInfo(8000021);
//			if( npcInfo )
//			{
//				npcInfo.isAddStage = true;
//				npcInfo.isClcik = false;
//				if( npcInfo.tnpc )
//				{
//					npcInfo.tnpc.name = "";
//					npcInfo.tnpc.career = null;
//					npcInfo.statuePlayer = player;
//					//调试模式显示1服的
//					if(Global.isDebugModle)
//					{
//						npcInfo.tnpc.modelId = "statue_1.swf";
//					}
//					else if(ParamsConst.instance.isArenaStatueSpecial)
//					{
//						npcInfo.tnpc.modelId = "statue_1.swf";
//					}
//					else if( EntityUtil.isSameProxyByRole(player.entityId) )
//					{
//						npcInfo.tnpc.modelId = "statue_"+statues.crossServerId+".swf";
//					}
//					else
//					{
//						npcInfo.tnpc.modelId = "statue_proxy_"+statues.crossServerId+".swf";
//					}
//				}
//			}
//			//更新本服前 10名
//			for each( player in statues.bestPlayers )
//			{
//				updateNpcInfo(player,player.rank+8000010,false,"dx000001");
//			}
//			ThingUtil.isMoveChange = true;
//		}
//		
//		public function setCrossFlowerNpc(statues:SCrossFlowerToplistStatues):void
//		{
//			for each( var player:SArenaCrossStatuePlayer in statues.bestPlayers )
//			{
//				if(player.sex == ESex._ESexMan)
//				{
//					updateNpcInfo(player,player.rank+8000030,true,"dx000002");
//				}
//				else
//				{
//					updateNpcInfo(player,player.rank+8000040,true,"dx000002");
//				}
//				
//			}
//			ThingUtil.isMoveChange = true;
//		}
//		
//		private function updateNpcInfo(player:SArenaCrossStatuePlayer, id:int,isClcik:Boolean = true,modelID:String = "dx000001" ):void
//		{
//			var npcInfo:NPCInfo = getNpcInfo(id);
//			if( npcInfo )
//			{
//				npcInfo.isAddStage = true;
//				npcInfo.isClcik = isClcik;
//				npcInfo.statuePlayer = player;
//				if( npcInfo.tnpc )
//				{
//					npcInfo.tnpc.name = player.name;
//					npcInfo.tnpc.career = StringHelper.substitute( _rankStr , player.rank);//"第"++"名";
//					npcInfo.tnpc.modelId = SWFModelConfig.instance.getSwfUrl(modelID,player.sex,CareerType.getCareer(player.career));
//				}
//			}
//		}
		
		/**
		 * 返回场景特效信息 
		 * @param npcId
		 * @param sceneId
		 * @return 
		 * 
		 */
		public function getEffectInfo(effectName:String,sceneId:int = -1):SceneEffectData
		{
			var sceneInfo:SceneInfo;
			if(sceneId != -1)
			{
				sceneInfo = getSceneInfo(sceneId);
				return sceneInfo.getEffectData(effectName);
			}
			else
			{
				var effectInfo:SceneEffectData;
				for each(sceneId in _mapArray)
				{
					sceneInfo = getSceneInfo(sceneId);
					for each(effectInfo in sceneInfo.effectInfos)
					{
						if(effectInfo.effectName == effectName)
						{
							return effectInfo;
						}
					}
				}
			}
			return null;
		}
	}
}
