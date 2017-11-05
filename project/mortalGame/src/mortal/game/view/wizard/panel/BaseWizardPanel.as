package mortal.game.view.wizard.panel
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.core.GlobalClass;
	
	import mortal.common.display.LoaderHelp;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	
	public class BaseWizardPanel extends GSprite
	{
		public function BaseWizardPanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
		}
		
	}
}