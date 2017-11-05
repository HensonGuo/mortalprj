package mortal.game.manager.mouse
{
	import flash.display.InteractiveObject;

	public interface IMouseRule
	{
		//添加囘調		
		function addCall(callBack:Function):void;
		//開始規則
		function startRule():void;
		//結束規則
		function endRule():void;
		//設置鼠標規則針對的對象
		function set target(obj:InteractiveObject):void;
	}
}