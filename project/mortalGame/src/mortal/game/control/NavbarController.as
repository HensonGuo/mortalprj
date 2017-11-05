package mortal.game.control
{
	import modules.NavbarModule;
	
	import mortal.mvc.core.Controller;
	import mortal.mvc.interfaces.IView;
	
	public class NavbarController extends Controller
	{
		private var _navbarModule:NavbarModule;
		
		public function NavbarController()
		{
			super();
		}
		
		override protected function initView():IView
		{
			if(!_navbarModule)
			{
				_navbarModule = new NavbarModule();
			}
			return _navbarModule;
		}
	}
}