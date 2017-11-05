/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.view.relive
{
	import mortal.component.window.BaseWindow;
	import mortal.mvc.interfaces.ILayer;
	
	public class ReliveLocalPanel extends ReliveGeneralPanel
	{
		public function ReliveLocalPanel($layer:ILayer=null)
		{
			super($layer);
			
			_btnRelivePointRelive.visible = false;
			_btnProRelive.x = 120;
		}
	}
}