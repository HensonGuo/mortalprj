package mortal.component.window
{
	import flash.events.MouseEvent;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.interfaces.ILayer;
	
	public class BaseWindow2 extends BaseWindow
	{
		public function BaseWindow2($layer:ILayer=null)
		{
			super($layer);
		}
		
		override protected function setWindowBgName():void
		{
			_windowBgName = ImagesConst.WindowBg2;
		}
		
		override protected function addCloseButton():void
		{
			_closeBtn = UIFactory.gLoadedButton(ImagesConst.Close_upSkin,0,0,31,22,null);
			_closeBtn.focusEnabled = true;
			_closeBtn.name = "Window_Btn_Close";
			_closeBtn.configEventListener(MouseEvent.CLICK,closeBtnClickHandler);
			this.addChild(_closeBtn);
		}
		
		
		override protected function setWindowCenter():void
		{
			_windowCenter = ResourceConst.getScaleBitmap("SelsetBg");
		}
		
		override protected function addWindowLine():void
		{
		}
		
		override protected function addWindowCenter2():void
		{
		}
		
		override protected function updateBtnSize():void
		{
			if( _closeBtn )
			{
				_closeBtn.x = this.width - _closeBtn.width - 15;
				_closeBtn.y = 3;
			}
		}
		
	}
}