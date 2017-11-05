/**
 * 2013-12-31
 * @author chenriji
 **/
package mortal.game.view.relive
{
	import mortal.component.window.BaseWindow;
	import mortal.mvc.interfaces.ILayer;
	
	public class ReliveRelivePointPanel extends ReliveGeneralPanel
	{
		public function ReliveRelivePointPanel($layer:ILayer=null)
		{
			super($layer);
			
			_btnProRelive.visible = false;
			_btnRelivePointRelive.x = 120;
		}
	}
}