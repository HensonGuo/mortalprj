/**
 * 2014-3-21
 * @author chenriji
 **/
package mortal.game.view.copy.group.view.data
{
	import Message.Public.SPublicPlayer;

	public class CopyTeamateData
	{
		public function CopyTeamateData()
		{
		}
		
		public var player:SPublicPlayer;
		public var isCaptin:Boolean = false;
		public var amICaptin:Boolean = false;
		public var todayNum:int;
		public var maxNum:int;
		public var isInRange:Boolean;
	}
}