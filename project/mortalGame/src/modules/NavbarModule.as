package modules
{
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.display.ScaleBitmap;
	
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mortal.game.view.pack.PackController;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.GameController;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.View;
	
	public class NavbarModule extends View
	{
		private var btnContainer:Sprite;
		
		private var roleBtn:GLoadedButton;
		
		private var packBtn:GLoadedButton;
		
		private var skillBtn:GLoadedButton;
		
		private var petBtn:GLoadedButton;
		
		private var mountsBtn:GLoadedButton;
		
		private var dailyBtn:GLoadedButton;
		
		private var forgeBtn:GLoadedButton;
		
		private var setBtn:GLoadedButton;
		
		private var clanBtn:GLoadedButton;
		
		private var upBtn:GLoadedButton;
		
		private var dowmBtn:GLoadedButton;
		
		private var shopBtn:GLoadedButton;
		
		public function NavbarModule()
		{
			super();
			this.layer = LayerManager.uiLayer;
//			this.mouseEnabled = false;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
//			var bg:ScaleBitmap = ObjCreate.createBg(0,5,950,52,this,ImagesConst.FunctionBar);
//			bg.scale9Grid = new Rectangle(85,0,137,52);
			UIFactory.bitmap(ImagesConst.FunctionBar,0,0,this);

//			var progress:BaseProgressBar = new BaseProgressBar();
//			progress.y = 57;
//			this.addChild(progress);
//			progress.setBg(ImagesConst.expBarBg,true,950,13);
//			progress.setProgress(ImagesConst.expBar,true,31,4,888,6);
//			progress.setLabel(BaseProgressBar.ProgressBarTextNumber,350,0,200,20,null,"经验值：{0}");
//			progress.setValue(5876,10000);
			
//			var expBarBg:ScaleBitmap = ObjCreate.createBg(0,57,950,13,this,ImagesConst.ExpBg);
//			expBarBg.scale9Grid = new Rectangle(43,1,70,4);
//			
//			var expBar:Bitmap = ObjCreate.createBitmap(ImagesConst.ExpBar,31,61,this);
			
			btnContainer = UIFactory.sprite();
			this.addChild(btnContainer);
			btnContainer.x = 0;
			btnContainer.y = 0;
			
			roleBtn = UIFactory.gLoadedButton(ImagesConst.NavRole_upSkin,27,30,43,44,btnContainer);
			
			dailyBtn = UIFactory.gLoadedButton(ImagesConst.NavDaily_upSkin,24,78,43,44,btnContainer); 
			
			skillBtn = UIFactory.gLoadedButton(ImagesConst.NavSkill_upSkin,20,123,43,44,btnContainer);
			
			packBtn = UIFactory.gLoadedButton(ImagesConst.NavPack_upSkin,18,169,43,44,btnContainer);  //19,349
			packBtn.name = ModuleType.Pack;
			
			mountsBtn = UIFactory.gLoadedButton(ImagesConst.NavMounts_upSkin,17,215,43,44,btnContainer);
			
			forgeBtn = UIFactory.gLoadedButton(ImagesConst.NavForge_upSkin,18,259,43,44,btnContainer);
			
			petBtn = UIFactory.gLoadedButton(ImagesConst.NavPet_upSkin,19,304,43,44,btnContainer);
			
			clanBtn = UIFactory.gLoadedButton(ImagesConst.NavClan_upSkin,19,349,43,44,btnContainer);
			
			setBtn = UIFactory.gLoadedButton(ImagesConst.NavSet_upSkin,23,397,43,44,btnContainer);
			
			shopBtn = UIFactory.gLoadedButton(ImagesConst.NavShop_upSkin,22,454,43,44,btnContainer);
			
			
			this.addEventListener(MouseEvent.CLICK,openWinHandeler);
		}
		
		private function openWinHandeler(e:MouseEvent):void
		{
			var btn:Object = e.target;
			switch(btn)
			{
				case packBtn:
					GameManager.instance.popupWindow(ModuleType.Pack);
					break;
				case roleBtn:
					GameManager.instance.popupWindow(ModuleType.Players);
					break;
				case skillBtn:
					GameManager.instance.popupWindow(ModuleType.Skills);
					break;
				case shopBtn:
					GameManager.instance.popupWindow(ModuleType.ShopMall);
					break;
				case clanBtn:
					GameManager.instance.popupWindow(ModuleType.Group);
					break;
				case forgeBtn:
					GameManager.instance.popupWindow(ModuleType.Build);
					break;
				case mountsBtn:
					GameManager.instance.popupWindow(ModuleType.Mounts);
					break;
				case petBtn:
					GameManager.instance.popupWindow(ModuleType.Pets);
					break;
				case setBtn:
					GameManager.instance.popupWindow(ModuleType.SysSet);
					break;
			}
			
		}
		
		/**
		 * 获取NavBar任何一个icon的Global坐标
		 */
		public function getNavbarIconGlobalPoint(iconName:String):Point
		{
			var icon:DisplayObject = btnContainer.getChildByName(iconName) as DisplayObject;
			if(icon != null)
			{
				return icon.localToGlobal(new Point(0, 0));
			}
			return new Point(0, 0);
		}
		
		override public function stageResize():void
		{
			this.x = SceneRange.display.width - 72;
			if(LayerManager.uiLayer.isSmallHeight)
			{
				this.y = 80;
			}
			else
			{
				this.y = GameController.mapNavBar.view.y + GameController.mapNavBar.view.height ;
			}
			
		}
	}
}