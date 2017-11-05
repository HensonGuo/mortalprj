/**
 * 2014-4-4
 * @author chenriji
 **/
package mortal.game.view.skill.panel.data
{
	import Message.DB.Tables.TRune;

	public class RuneItemData
	{
		public function RuneItemData()
		{
		}
		
		public var actived:Boolean=false;
		public var canUpgrade:Boolean=false;
		public var info:TRune;
	}
}