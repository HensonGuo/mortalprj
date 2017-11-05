/**
 * @heartspeak
 * 2014-4-3 
 */   	

package mortal.game.scene3D.model.data
{
	import flash.utils.Dictionary;
	
	import mortal.game.resource.GameDefConfig;

	public class ActionName
	{
		//站立动作
		public static const Stand:String = "stand";  	//$站立
		public static const FightWait:String = "fightwait";  	//攻击等待
		public static const SwimStand:String = "swimStand";//游泳站立
		public static const RoleMountStand:String = "mountStand01";  	//普通骑乘动作
		
		//移动动作
		public static const Walking:String = "run";  //$走动
		public static const FightRun:String = "fightrun";  	//攻击移动
		public static const Swim:String = "swim";//游泳
		public static const RoleMountWalk:String = "mountWalk01";  	//普通骑乘动作
		
		//攻击动作  在gameDef里面读取
		//吟唱起手动作 在gamedef里面读取
		//吟唱持续动作 在gamedef里面读取
		
		//受伤
		public static const Injury:String = "hurt";	// 受伤
		
		//死亡
		public static const Death:String = "die"; 	// 死亡
		
		//跳跃
		public static const Jump:String = "jump";//跳跃
		public static const Somersault:String = "jump2";//翻滚
		
		//特殊动作旋风斩
		public static const Tornado:String = "tornado";//旋风斩
		
		//NPC动作名
		public static const Standing:String = "standing";//NPC特殊待机
		
		//坐骑动作名
		public static const MountStand:String = "mountStand";  	// 坐骑站立
		public static const MountWalk:String = "mountWalk";  	// 坐骑走动
		
		//站立动作列表
		public static const standActionList:Array = [Stand,FightWait,SwimStand,RoleMountStand];
		//移动动作列表
		public static const walkingActionList:Array = [Walking,FightRun,Swim,RoleMountWalk];
		//死亡动作列表
		public static const deathActionList:Array = [Injury];
		//跳跃
		public static const jumpActionList:Array = [Jump,Somersault];
		//受伤
		public static const injuryActionList:Array = [Injury];
		//攻击动作列表
		private static var _attackActionList:Array;//攻击动作列表
		//吟唱起始动作 以及 吟唱持续动作
		private static var _leadActionDic:Dictionary;//引导动作字典 key为起始动作、value为持续播放的动作
		
		/**
		 * 获取攻击动作列表 
		 * @return 
		 * 
		 */		
		public static function get attackActionList():Array
		{
			if(!_attackActionList)
			{
				_attackActionList = new Array();
				_attackActionList = GameDefConfig.instance.getItem("PlayerAttackAction",1).text.split(",")
			}
			//读取配置
			return _attackActionList;
		}
		
		/**
		 * 获取吟唱动作字典 
		 * @return 
		 * 
		 */		
		public static function get leadActionDic():Dictionary
		{
			if(!_leadActionDic)
			{
				_leadActionDic = new Dictionary();
				//读取配置
				var ary:Array = GameDefConfig.instance.getLeadActions();
				for each(var item:Object in ary)
				{
					_leadActionDic[item.text] = item.text1;
				}
			}
			return _leadActionDic;
		}
	}
}