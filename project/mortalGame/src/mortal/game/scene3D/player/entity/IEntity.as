package mortal.game.scene3D.player.entity
{
	import flash.events.IEventDispatcher;
	
	import mortal.game.scene3D.layer3D.SLayer3D;
	import mortal.game.scene3D.player.info.EntityInfo;

	public interface IEntity extends IEventDispatcher,IGame2D
	{
		function get entityID():String;
		
		function get type():int;
		
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		
		function get entityInfo():EntityInfo;
		
//		function set actionState( value:String ):void;  //设置动作
//		function get actionState():String;  //设置动作
		
		function setAction(actionType:String,actionName:String,isForce:Boolean = false):void
		function get actionName():String;
		
		function walking(pointAry:Array):void;
//		function attack():void;
		
		function hurt( value:int ):void;
			
		function get isDead():Boolean;
		function set isDead(value:Boolean):void;
		
		function updateHeadContainer():void;
			
		function talk(value:String,time:Number = 5000):void;
		function clearTalk():void;
		function updateTalkXY():void;
			
		function addToStage( layer:SLayer3D ):Boolean;
		function removeFromStage( layer:SLayer3D ):Boolean;
			
		function get toRoleDistance():Number;
	}
}