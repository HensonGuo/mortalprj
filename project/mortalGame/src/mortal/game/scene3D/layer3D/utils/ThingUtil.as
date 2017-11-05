package mortal.game.scene3D.layer3D.utils
{
	import Message.Game.AMI_ITest_getThreatList;
	
	import baseEngine.core.Pivot3D;
	
	import com.gengine.global.Global;
	
	import mortal.game.Game;
	import mortal.game.net.rmi.GameRMI;
	import mortal.game.scene3D.fight.FightEffectUtil;
	import mortal.game.scene3D.layer3D.PlayerLayer;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.entity.Game2DPlayer;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;

	public class ThingUtil
	{
		//是否改变场景显示
		public static var isEntitySort:Boolean = false;
		//人物所在和平区域什么的变更  组队  仙盟变更
		private static var _isNameChange:Boolean = false;
		//主角坐标发生改变
		private static var _isMoveChange:Boolean = false;
		
		public static var distanceQueueChange:Boolean = false;
		//主角和怪物
		public static var entityUtil:EntityUtil;
		
		//更新玩家数据
//		public static var userUtil:UserUtil;
		//战斗
		public static var fightUtil:FightEffectUtil;
		//NPC
		public static var npcUtil:NPCUtil;
		//场景特效
		public static var effectUtil:EffectUtil;
		//传送阵
		public static var passUtil:PassUtil;
		//跳跃点
		public static var jumpUtil:JumpUtil;
		//掉落
		public static var dropItemUtil:DropItemUtil;
		
		
		//选择的对象
		private static var _selectEntity:IEntity;
		
		public static var overEntity:Game2DPlayer;
		
		public function ThingUtil()
		{
			
		}
		
		public static function get isNameChange():Boolean
		{
			return _isNameChange;
		}

		public static function set isNameChange(value:Boolean):void
		{
			_isNameChange = value;
			if(value)
			{
				ThingUtil.isEntitySort = true;
			}
		}
		
		public static function get isMoveChange():Boolean
		{
			return _isMoveChange;
		}

		public static function set isMoveChange(value:Boolean):void
		{
			_isMoveChange = value;
			if(value)
			{
				ThingUtil.isEntitySort = true;
			}
		}

		public static function iniThing( layer:PlayerLayer):void
		{
			entityUtil = new EntityUtil(layer);
			fightUtil = new FightEffectUtil();
//			userUtil = new UserUtil(layer);
			effectUtil = new EffectUtil(layer);
			npcUtil = new NPCUtil(layer);
			passUtil = new PassUtil(layer);
			jumpUtil = new JumpUtil(layer);
			dropItemUtil = new DropItemUtil(layer);
		}
		
		public static function removeAll():void
		{
			entityUtil.removeAll();
			effectUtil.removeAll();
			npcUtil.removeAll();
			passUtil.removeAll();
			jumpUtil.removeAll();
			dropItemUtil.removeAll();
		}

		public static function get selectEntity():IEntity
		{
			return _selectEntity;
		}
		
		public static function get sceneEntityList():Vector.<Pivot3D>
		{
			return Game.scene.playerLayer.children;
		}
		
		/**
		 * 更新鼠标当前选择的对象 
		 * 
		 */		
		public static function onMouseOver(mx:Number, my:Number):void
		{
			if(ThingUtil.overEntity)
			{
				if(ThingUtil.overEntity.hoverTest(SceneRange.display.x,SceneRange.display.y,mx,my))
				{
					return;
				}
				else
				{
					ThingUtil.overEntity.onMouseOut();
				}
			}
			var tempEntity:Game2DPlayer = getOverObject(mx,my);
			ThingUtil.overEntity = tempEntity;
			if(tempEntity)
			{
				if(tempEntity)
				{
					tempEntity.onMouseOver();
				}
			}
		}
		
		private static function getOverObject(mouseX:Number, mouseY:Number):Game2DPlayer
		{
			var disPlayX:Number = SceneRange.display.x;
			var disPlayY:Number = SceneRange.display.y;
			var tempPlayer:Game2DPlayer;
			var overPlayer:Game2DPlayer;
			var list:Vector.<Pivot3D> = ThingUtil.sceneEntityList;
			for each(var p3D:Pivot3D in list)
			{
				if(p3D is Game2DPlayer)
				{
					tempPlayer = p3D as Game2DPlayer;
					if(tempPlayer.hoverTest(disPlayX,disPlayY,mouseX,mouseY))
					{
						if(!overPlayer)
						{
							overPlayer = tempPlayer;
						}
						else if(tempPlayer.overPriority > overPlayer.overPriority)
						{
							overPlayer = tempPlayer;
						}
						else if(tempPlayer.overPriority == overPlayer.overPriority && tempPlayer.y2d > overPlayer.y2d )
						{
							overPlayer = tempPlayer;
						}
					}
				}
			}
			return overPlayer;
		}
		
		public static function set selectEntity(value:IEntity):void
		{
			if(_selectEntity == value)
			{
				return;
			}
			if(_selectEntity)
			{
				_selectEntity.selected = false;
			}
			_selectEntity = value;
			if(_selectEntity)
			{
				_selectEntity.selected = true;
			}
			
			
			CONFIG::Debug
			{
				// 测试boss仇恨值
				if(ThingUtil.selectEntity != null && ThingUtil.selectEntity.entityInfo != null && (ThingUtil.selectEntity is MonsterPlayer))
				{
					GameRMI.instance.iTestPrx.getThreatList_async(new AMI_ITest_getThreatList(), ThingUtil.selectEntity.entityInfo.entityInfo.entityId);
				}
			}
		}

		public static function isNPC(value:String):Boolean
		{
			return value.indexOf(NPCUtil.NPCPlayerLink) == 0;
		}
		
		public static function isPass(value:String):Boolean
		{
			return false;
//			return value.indexOf(NPCUtil.NPCPlayerLink) == 0;
		}
		
		/**
		 * 删除对象 
		 * 
		 */		
		public static function removeEntity():void
		{
			
		}
	}
}
