package modules.interfaces
{
	import Message.Public.SFightAttribute;
	
	import flash.events.Event;
	
	import mortal.mvc.interfaces.IView;

	public interface IPlayerModule extends IView
	{
		function updateAttr():void;
		function upDateAllInfo(data:SFightAttribute):void;
		function upDateLife(data:int):void;
		function upDateMana(data:int):void;
		function upDateExp(data:int):void;
		function updateLevel(data:int):void;
		function updateEquipByType(type:int):void;
		function updateAllEquip():void;
		function updateComBat():void
		
			
			
	}
}