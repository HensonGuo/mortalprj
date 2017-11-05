package mortal.game.scene3D.map3D
{
	import Message.Public.EMapInstanceType;
	
	import mortal.game.resource.SceneConfig;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;

	/**
	 * 保存当前地图的类型 
	 * @author jianglang
	 * 
	 */	
	public class MapState
	{
		
		/**
		 * 是否是普通地图
		 * 
		 */
		public var isUniqueMap:Boolean;
		
		
		public function MapState()
		{
			
		}
		public function initMapId( mapId:int):void//, proxyId:int, serverId:int):void
		{
			var mapInfo:SceneInfo = SceneConfig.instance.getSceneInfo(mapId);
			restMap();
			
			if( mapInfo )
			{
				var instanceType:int = mapInfo.sMapDefine.instanceType.__value;
				switch( mapInfo.sMapDefine.instanceType.__value )
				{
					case EMapInstanceType._EMapInstanceTypeNormal: //普通地图
					{
						isUniqueMap = true;
						break;
					}
				}
			}
		}
		
		public function restMap():void
		{
			isUniqueMap = false;
		}
	}
}