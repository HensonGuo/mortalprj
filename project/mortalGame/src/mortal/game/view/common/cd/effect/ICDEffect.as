/**
 * 2014-1-10
 * @author chenriji
 **/
package mortal.game.view.common.cd.effect
{
	import mortal.game.view.common.cd.ICDData;

	public interface ICDEffect
	{	
		function onTimer(timerValue:int):void;
		function get cdEffectTimerType():String;
		function get registed():Boolean;
		function set registed(value:Boolean):void;
		function reset():void;
	}
}