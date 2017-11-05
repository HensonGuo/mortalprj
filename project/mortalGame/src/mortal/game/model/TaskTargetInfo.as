/**
 * @date	2011-3-15 下午03:53:52
 * @author  宋立坤
 * 
 */	
package mortal.game.model
{
	import mortal.game.rules.EntityType;
//	import mortal.game.scene.layer.utils.EntityUtil;

	public class TaskTargetInfo
	{
		/**
		 * 为NPC时为NPC的id
		 * 为怪物时代表怪物的code
		 * 操作道具时为道具code 
		 */		
		public var id:int;
		public var mapId:int;
		public var x:int;
		public var y:int;
		public var proxyId:int;	//
		public var serverId:int;
		
		/**
		 * 如果是entity 参考EntityType.as
		 * 如果是操作 参考GuideOptType.as
		 */		
		public var targetType:int;
		
		public var name:String = "null";
		public var mapName:String = "null";
		public var camp:int;		//阵营
		public var pathGuide:Boolean;//是否需要路径引导
		
		public var curValue:int;
		public var totalValue:int;
		public var mapType:int;	//目标地图的类型 参考 EMapInstanceType.as
		
		public function TaskTargetInfo()
		{
		}
		
		/**
		 * 检查目标点是否合法 
		 * @return 
		 * 
		 */
		public function checkTargetPoint():Boolean
		{
			if(mapId > 0)
			{
				if(x > 0 && y > 0 || targetType == EntityType.Scene)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 数量是否足够 
		 * @return 
		 * 
		 */
		public function checkValue():Boolean
		{
			return curValue != 0 && curValue >= totalValue;
		}
		
		/**
		 * 目标是否跨服国家地图 
		 * @return 
		 * 
		 */		
		public function isCrossCountryMap():Boolean
		{
//			if(proxyId != 0 || serverId != 0)
//			{
//				if(!EntityUtil.isSameServerByProxyAndServer(proxyId,serverId))
//				{
//					return true;
//				}
//			}
			return false;
		}
		
		public function toString():String
		{
			return id+"-"+mapId+"-"+x+"-"+y;
		}
		
		public function clone(inst:TaskTargetInfo=null):TaskTargetInfo
		{
			if(inst == null)
			{
				inst = new TaskTargetInfo();
			}
			inst.targetType = this.targetType;
			inst.mapId = this.mapId;
			inst.id = this.id;
			inst.x = this.x;
			inst.y = this.y;
			inst.proxyId = this.proxyId;
			inst.serverId = this.serverId;
			inst.name = this.name;
			inst.mapName = this.mapName;
			inst.camp = this.camp;
			return inst;
		}
	}
}