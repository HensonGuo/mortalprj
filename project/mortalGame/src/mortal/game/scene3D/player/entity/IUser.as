package mortal.game.scene3D.player.entity
{
	import Message.BroadCast.SEntityInfo;
	import Message.Public.SPoint;

	public interface IUser extends IEntity
	{
		function updateClothes( value:int ):void; //衣服
		function updateWeapons(value:int):void;//武器
		function updateMount( value:int ):void; //坐骑
		function updateStatus( value:int,isInit:Boolean=true ):void; //状态 比如：采集
		function updateLife( life:int,maxLife:int):void; // 更新生命
		function updateMana(  mana:int,maxMana:int ):void; //  更新魔法
		function updateSpeed( value:int ):void; // 更新速度
		function updateFightMode( value:int ):void; //更新战斗模式
		function updateLevel( value:int,update:Boolean ):void; //更新等级
		function updateCCS( info:SEntityInfo ,isUpdate:Boolean = false):void //更新阵营 职业 性别
		function updateName( value:String=null ,isUpdate:Boolean = true):void; //更新名称
		function updateInfo( info:Object,isAllUpdate:Boolean = true):void//更新信息
		function death( isEffect:Boolean=false ):void;
	}
}