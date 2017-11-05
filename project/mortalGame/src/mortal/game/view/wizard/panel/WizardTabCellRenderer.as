package mortal.game.view.wizard.panel
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import flash.geom.Rectangle;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.wizard.data.WizardData;
	
	public class WizardTabCellRenderer extends GCellRenderer
	{
		private var _wizardIcon:GBitmap; //精灵图标
		
		private var _currentWizard:WizardData;
		
		public function WizardTabCellRenderer()
		{
			super();
		}
		
		protected override function initSkin():void
		{
			var emptyBmp:GBitmap = new GBitmap;
			
			var selectSkin:ScaleBitmap = GlobalClass.getScaleBitmap(ImagesConst.TabBule_selectSkin,new Rectangle(38,26,1,1));
			var overSkin:ScaleBitmap =  GlobalClass.getScaleBitmap(ImagesConst.TabBule_overSkin,new Rectangle(38,26,1,1));
			var upSkin:ScaleBitmap =  GlobalClass.getScaleBitmap(ImagesConst.TabBule_upSkin,new Rectangle(38,26,1,1));
			
			this.setStyle("downSkin",overSkin);
			this.setStyle("overSkin",overSkin);
			this.setStyle("upSkin",upSkin);
			this.setStyle("selectedDownSkin",selectSkin);
			this.setStyle("selectedOverSkin",selectSkin);
			this.setStyle("selectedUpSkin",selectSkin);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_wizardIcon = UIFactory.gBitmap("",18,0,this);
			
			this.buttonMode = true;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_wizardIcon.dispose(isReuse);
			_wizardIcon = null;
		}
		
		override public function set data(arg0:Object):void
		{
			_currentWizard = arg0.data;
			
			if(_currentWizard)
			{
				_wizardIcon.bitmapData = GlobalClass.getBitmapData("wizardBtn" + _currentWizard.soulId + "_upSkin");
				
				if(_currentWizard.isHasWizard)
				{
					this.filters = [];
				}
				else
				{
					this.filters = [FilterConst.colorFilter2];
				}
			}
		}
		
	}
}