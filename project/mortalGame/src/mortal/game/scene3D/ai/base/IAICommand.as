/**
 * 2013-12-16
 * @author chenriji
 **/
package mortal.game.scene3D.ai.base
{
	import mortal.game.scene3D.ai.data.AIData;

	public interface IAICommand
	{
		function set data($data:AIData):void;
		function get data():AIData;
		function start(onEnd:Function=null):void;
		function stop():void; 
		function get stopable():Boolean;
	}
}