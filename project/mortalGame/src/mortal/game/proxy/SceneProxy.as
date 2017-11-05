package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IFight_collect;
	import Message.Game.AMI_IFight_dispelBuffSelf;
	import Message.Game.AMI_IFight_fight;
	import Message.Game.AMI_IFight_setFightMode;
	import Message.Game.AMI_IMap_convey;
	import Message.Game.AMI_IMap_diversion;
	import Message.Game.AMI_IMap_getCustomPoint;
	import Message.Game.AMI_IMap_jump;
	import Message.Game.AMI_IMap_jumpPoint;
	import Message.Game.AMI_IMap_move;
	import Message.Game.AMI_IMap_pass;
	import Message.Game.AMI_IMap_pickup;
	import Message.Game.AMI_IMap_revival;
	import Message.Game.AMI_IMap_saveCustomPoint;
	import Message.Game.AMI_IMap_somersault;
	import Message.Game.EPassType;
	import Message.Game.SFightOper;
	import Message.Public.SEntityId;
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import com.gengine.debug.Log;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.ErrorCodeConfig;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.skill.SkillInfo;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;

	/**
	 * 
	 * @author Administrator
	 */
	public class SceneProxy extends Proxy
	{
		/**
		 * 
		 */
		public function SceneProxy()
		{
			
		}
		
		private var _mapMove:AMI_IMap_move = new AMI_IMap_move();
		private var _mapDiversion:AMI_IMap_diversion = new AMI_IMap_diversion();
		
		/**
		 * 使用小飞鞋 
		 * @param mapId
		 * @param p
		 * 
		 */		
		public function covey(passTo:SPassTo):void
		{
			_lastCovey = passTo;
			rmi.iMapPrx.convey_async(new AMI_IMap_convey(null, coveyFailHandler), passTo.mapId, passTo.toPoint);
		}
		private var _lastCovey:SPassTo;
		private function coveyFailHandler(ex:Exception):void
		{
			MsgManager.showRollTipsMsg(ErrorCodeConfig.instance.getErrorStringByCode(ex.code));
//			NetDispatcher.dispatchCmd(ServerCommand.AI_FlyBootFail, _lastCovey);
			
		}
		
		public function saveCustomMapPoint(index:int, name:String, mapId:int, p:SPoint):void
		{
			rmi.iMapPrx.saveCustomPoint_async(new AMI_IMap_saveCustomPoint(), index, name, mapId, p);
		}
		
		public function getCustomMapPoint():void
		{
			rmi.iMapPrx.getCustomPoint_async(new AMI_IMap_getCustomPoint(onGetCustomMapPoint));
		}
		private function onGetCustomMapPoint(obj:Object, data:Array):void
		{
			cache.smallmap.initCustomMapPoints(data);
			NetDispatcher.dispatchCmd(ServerCommand.SmallMapCustomMapPointGot, null);
		}
		
		/**
		 * 最后一次发给服务器的点 用于避免重复发送相同坐标 
		 */		
		protected var lastPoint:SPoint;
		
		public function clearLastPoint():void
		{
			lastPoint = null;
		}
		
		/**
		 * 移动人物角色
		 * @param points
		 */
		public function move( points:Array ):void
		{
			//去掉之前发过的点
//			var firstPoint:SPoint = points[0] as SPoint;
//			if(lastPoint && firstPoint.x == lastPoint.x && firstPoint.y == lastPoint.y)
//			{
//				points.shift();
//			}
//			if(points.length > 0)
//			{
//				lastPoint = points[points.length - 1];
				rmi.iMapPrx.move_async(_mapMove,points);
//				for(var i:int = 0;i < points.length;i++)
//				{
//					Log.debug("开始发送给服务器移动：",(points[i] as SPoint).x,(points[i] as SPoint).y,getTimer());
//				}
//			}
		}
		
		/**
		 * 角色转向 
		 * @param points
		 * 
		 */
		public function diversion( points:Array ):void
		{
			//去掉之前发过的点
//			var firstPoint:SPoint = points[0] as SPoint;
//			if(lastPoint && firstPoint.x == lastPoint.x && firstPoint.y == lastPoint.y)
//			{
//				points.shift();
//				move(points);
//			}
//			else if(points.length > 0)
//			{
//				lastPoint = points[points.length - 1];
				rmi.iMapPrx.diversion_async(_mapDiversion,points);
//				for(var i:int = 0;i < points.length;i++)
//				{
//					Log.debug("开始发送给服务器转向移动：",(points[i] as SPoint).x,(points[i] as SPoint).y,getTimer());
//				}
//				Log.debug("开始发送给服务器移动：",);
//			}
		}
		
		/**
		 * 复活 
		 * @param reliveType
		 * 
		 */		
		public function relive(reliveType:int):void
		{
			rmi.iMapPrx.revival_async(new AMI_IMap_revival(), reliveType);
		}
		
		/**
		 * 跳跃， 往上跳等
		 * @param point
		 * 
		 */		
		public function jump(point:SPoint):void
		{
			rmi.iMapPrx.jump_async(new AMI_IMap_jump(),point);
		}
		
		/**
		 * 跳跃点， 通过跳跃点走到另外一个地图点
		 * @param point
		 * 
		 */		
		public function jumpPoint(point:SPoint):void
		{
			rmi.iMapPrx.jumpPoint_async(new AMI_IMap_jumpPoint(),point);
		}
		
		/**
		 * 翻滚 
		 * @param point
		 * 
		 */		
		public function somersault(point:SPoint):void
		{
			var p:SPoint = new SPoint();
			p.x = RolePlayer.instance.x2d;
			p.y = RolePlayer.instance.y2d;
			var pointArray:Array = [p,point];
			rmi.iMapPrx.somersault_async(new AMI_IMap_somersault(),pointArray);
		}
		
		/**
		 * 传送 
		 * @param type
		 * @param fromCode
		 * @param toCode
		 * @param point
		 * 
		 */		
		public function pass(type : EPassType , fromCode : int , toCode : int , point : SPoint):void
		{
			rmi.iMapPrx.pass_async(new AMI_IMap_pass(),type,fromCode,toCode,point);
		}
		
		/**
		 * 攻击请求 
		 * @param entityIds 对象id数组
		 * @param skillID 技能id
		 * @param spoint 对象逻辑坐标
		 * @param op 技能释放类型 参考ESkillUseSkillOp.as
		 * 
		 */
		public function fight( entityIds:Array,skillID:int=0,spoint:SPoint = null,op:int=0,uid:String = ""):void
		{
//			Log.debug("开始请求攻击",getTimer());
			var fightTo:SFightOper = new SFightOper();
			
			fightTo.toEntitys = entityIds;
			fightTo.skillId = skillID;
			fightTo.op = op;
			fightTo.uid = uid;
			
			var info:SkillInfo = cache.skill.getSkill(skillID);
			if(info)
			{
				if(info.tSkill.name == "防御状态")
				{
					Log.system("...");
				}
				Log.system("....  使用了技能:" + info.tSkill.name);
			}
			
			if( spoint == null )
			{
				fightTo.mousePoint = new SPoint();
			}
			else 
			{
				fightTo.mousePoint = spoint;
			}
			//Log.debug("发送攻击请求");
			rmi.iFightPrx.fight_async(new AMI_IFight_fight(),fightTo);
			
//			if(false) //Global.isDebugModle)
//			{
//				var skill:TSkill = SkillConfig.instance.getInfoByName(skillID);
//				if(skill)
//				{
//					MsgManager.showRollTipsMsg("攻击请求：" + skillID + "--" + getTimer()+ "--" +  skill.skillName);
//				}
//				else
//				{
//					MsgManager.showRollTipsMsg("攻击请求：" + skillID + "--" + getTimer()+ "--" +  "普通攻击");
//				}
//			}
		}
		
		public function collect(id:SEntityId, isBegin:Boolean=true):void
		{
			rmi.iFightPrx.collect_async(new AMI_IFight_collect, id, isBegin);
		}
		
		/**
		 * 拾取掉落物品 
		 * @param entityId
		 * 
		 */
		public function pickup(entityId:SEntityId):void
		{
			rmi.iMapPrx.pickup_async(new AMI_IMap_pickup(),entityId);
		}
		
		public function dispelBuffSelf():void
		{
			rmi.iFightPrx.dispelBuffSelf_async(new AMI_IFight_dispelBuffSelf());
		}
		
		public function changeFightMode(type:int):void
		{
			rmi.iFightPrx.setFightMode_async(new AMI_IFight_setFightMode(),type);
		}
		
	}
}
