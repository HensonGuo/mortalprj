/**
 * @date 2012-5-10 下午03:30:15
 * @author cjx
 */
package mortal.game.view.copy
{
	import Message.DB.Tables.TCopy;

	public interface ICopyController
	{
		function enterCopy(copy:TCopy):void;
		function leaveCopy():void;
		function stageResize():void;
		function updateCopyProcess():void;
	}
}