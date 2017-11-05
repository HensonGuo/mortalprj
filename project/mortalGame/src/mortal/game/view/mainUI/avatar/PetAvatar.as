/**
 * @heartspeak
 * 2014-3-17 
 */   	

package mortal.game.view.mainUI.avatar
{
	import com.mui.utils.UICompomentPool;
	
	import mortal.game.view.mainUI.roleAvatar.BuffPanel;

	public class PetAvatar extends EntityAvatar
	{
		public function PetAvatar()
		{
			super();
		}
		
		override protected function addBuff():void
		{
			_buffPanel = UICompomentPool.getUICompoment(BuffPanel);
			_buffPanel.createDisposedChildren();
			_buffPanel.x = 63;
			_buffPanel.y = 37;
			this.addChild(_buffPanel);
		}
	}
}