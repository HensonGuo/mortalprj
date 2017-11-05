package mortal.game.view.palyer
{
	
	import Message.Public.SFightAttribute;
	
	import com.gengine.utils.HTMLUtil;
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	
	import modules.interfaces.IPlayerModule;
	
	import mortal.common.GTextFormat;
	import mortal.common.display.BitmapDataConst;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.textBox.GTextBox;
	import mortal.component.window.BaseWindow;
	import mortal.component.window.BaseWindow2;
	import mortal.game.cache.Cache;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.GModuleEvent;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.TextBox;
	import mortal.game.view.wizard.GTabarNew;

	public class PlayerModule extends BaseWindow2 implements IPlayerModule
	{
		//数据
		private var _mode:String=GModuleEvent.Mode_Self;
		
		private var tabRole:Object = {name:"equip",label:Language.getString(30110)};
		private var tabAttribute:Object = {name:"attribute",label:Language.getString(30111)}; 
		private var tabAcupoint:Object = {name:"acupoint",label:Language.getString(30112)}; 
		private var tabExchange:Object = {name:"exchange",label:Language.getString(30113)}; 
		private var tabSkill:Object = {name:"skill",label:Language.getString(30114)}; 
		
		/**存放导航栏标题(可根据状态动态显示导航栏标题)*/
		private var _tabNameArr:Array = [tabRole,tabAttribute,tabAcupoint,tabExchange,tabSkill];
		
		
		private var _tabBarDataProvider_Self:Array = [_tabNameArr[0],_tabNameArr[1],_tabNameArr[2],_tabNameArr[3],_tabNameArr[4]];
		
		private var _tabBarIdx:int=0;
		
		//显示对象
		/**分组导航*/
		private var _tabBar:GTabarNew ; 
		
		/**人物*/
		private var _rolePanel:BaseRolePanel;
		
		private var _infoTextBox:TextBox;
		
		private var _nameTextBox:TextBox;
		
		private var _guideTextBox:TextBox;
		
		private var _signatureTextBox:TextBox;
		
		private var _signatureText:GTextInput;
		
		
		public function PlayerModule()
		{
			super();
			init();
			this.layer = LayerManager.windowLayer3D;
		}
		
		private function init():void
		{
			setSize(431,500);
//			title = Language.getString(20022);
//			titleIcon = ImagesConst.PackIcon;
			_titleHeight = 62;
		}
		
		override protected function updateWindowCenterSize(  ):void
		{
			if( _windowCenter )
			{
				var w:Number = this.width - 4;
				var h:Number = this.height  - _titleHeight - paddingBottom - blurTop - blurBottom; ;
				_windowCenter.setSize(w,h);
				_windowCenter.x = 2;
				_windowCenter.y = _titleHeight + blurTop + 16;
			}	
			
			if (_windowCenter2)
			{
				_windowCenter2.x = _windowCenter.x + 5;
				_windowCenter2.y = _windowCenter.y + 5;
				_windowCenter2.width = _windowCenter.width - 10;
				_windowCenter2.height = _windowCenter.height - 10;
			}
			
			if(_windowLine)
			{
				var k:Number = this.width - paddingLeft - paddingRight - blurLeft - blurRight;
				_windowLine.setSize(k,7);
				_windowLine.x = paddingLeft + blurLeft;
				_windowLine.y = _titleHeight + blurTop - 7;
			}
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_rolePanel = UICompomentPool.getUICompoment(BaseRolePanel,this);
			_rolePanel.createDisposedChildren();
			_rolePanel.x = -3;
			_rolePanel.y = 24;
			this.addChild(_rolePanel);
			
			
			_infoTextBox = createTextBox(1);
			
			_nameTextBox = createTextBox(2);
			
			_guideTextBox = createTextBox(3);
			_guideTextBox.htmlText = "<font color='#f8eacd'>" + "暂无公会" +"</font>";
			
			_signatureTextBox = createTextBox(1);
			_signatureTextBox.textField.autoSize = AlignMode.LEFT;
			_signatureTextBox.y = 470;
			_signatureTextBox.bgWidth = 250;
			_signatureTextBox.bgHeight = 25;
			_signatureTextBox.htmlText = "<font color='#f8eacd'>" + " 签名: " +"</font>";
			
			_signatureText = UIFactory.gTextInput(43,471,220,25,this,null);
			_signatureText.maxChars = 15;
			var bm:Bitmap = new Bitmap(GlobalClass.getBitmapData(BitmapDataConst.AlphaBMD));
			_signatureText.setStyle("upSkin",bm);
			_signatureText.setStyle("disabledSkin",bm);
			_signatureText.setStyle("focusRectSkin",bm);
			
			_tabBar = UIFactory.gTabBarNew(2,54, _tabBarDataProvider_Self,431,65,26,this,onTabBarSelectedChange,"TabButtonNew");
			_tabBar.selectedIndex=0;
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_tabBar.dispose(isReuse);
			_rolePanel.dispose(isReuse);
			_infoTextBox.dispose(isReuse);
			_nameTextBox.dispose(isReuse);
			_guideTextBox.dispose(isReuse);
			_signatureTextBox.dispose(isReuse);
			_signatureText.dispose(isReuse);
			
			_tabBar = null;
			_rolePanel = null;
			_infoTextBox = null;
			_nameTextBox = null;
			_guideTextBox = null;
			_signatureTextBox = null;
			_signatureText = null;
			
			
			super.disposeImpl(isReuse);
		}
		
		private function createTextBox(col:int = 1):TextBox
		{
			var tf:GTextFormat = GlobalStyle.textFormatHuang;
			tf.align = AlignMode.CENTER;
			var textbox:TextBox = UICompomentPool.getUICompoment(TextBox);
			textbox.createDisposedChildren();
			textbox.setbgStlye(ImagesConst.PanelBg,tf);
//			textbox.textField.x = -22;
			textbox.textField.y = 1;
			textbox.textFieldHeight = 15;
			textbox.textFieldWidth = 80;
			textbox.bgHeight = 23;
			textbox.bgWidth = 137;
			textbox.x = (col - 1)*141 + 9;
			textbox.y = 30;
			this.addChild(textbox);
			
			return textbox;
		}
		
		private function onTabBarSelectedChange(e:MuiEvent):void
		{
			changeTabBarByIndex(_tabBar.selectedIndex);
		}
		
		public function changeTabBarByIndex(index:int):void
		{
			
		}
		
		
		/**
		 * 
		 * @param value
		 */
		public function set mode(value:String):void
		{
			if(_rolePanel)
			{
				_rolePanel.mode=value;
			}
//			if(_acupointPanel)
//			{
//				_acupointPanel.mode=value;
//			}
//			if(_wuxingPanel)
//			{
//				_wuxingPanel.mode = value;
//			}
//			if(_attributePanel)
//			{
//				_attributePanel.mode = value;
//			}
			_mode=value;
			checkTabBar();
		}
		
		public function checkTabBar():void
		{
			if (_mode == GModuleEvent.Mode_Self)
			{
				_tabBar.dataProvider = _tabBarDataProvider_Self;
			}
			_tabBar.drawNow();
		}
		
		override public function show(x:int=0, y:int=0):void
		{
			super.show();
//			checkTabBar();
		}
		
		private function getCamp(type:int):String
		{
			return HTMLUtil.addColor(GameDefConfig.instance.getECamp(type).text,GameDefConfig.instance.getECamp(type).text1)
		}
		
		private function getCareer(carrer:int):String
		{
			return GameDefConfig.instance.getCarrer(carrer);
		}
		
		private function updateInfo():void
		{
			_infoTextBox.htmlText = "<font color='#f8eacd'>" + Cache.instance.role.entityInfo.level +"级 / </font>" + getCamp(Cache.instance.role.entityInfo.camp) + "<font color='#f8eacd'> / " + getCareer(Cache.instance.role.entityInfo.career) + "</font>";
		}

		
		
		/**
		 * 
		 * @param data
		 * @param baseData
		 */
		public function updateAttr():void
		{
			if(_rolePanel)
			{
				_rolePanel.updateAttr();
			}
		}
		
		public function upDateAllInfo(data:SFightAttribute):void
		{
			_rolePanel.upDateAllInfo(data);
			updateInfo();
			uodateSignature();
			updataNmae();
		}
		
		public function upDateLife(data:int):void
		{
			_rolePanel.updateLife(data);
		}
		
		public function upDateMana(data:int):void
		{
			_rolePanel.updateMana(data);
		}
		
		public function updateLevel(value:int):void
		{
			updateInfo();
		}
		
		public function updataCamp(value:int):void
		{
			updateInfo();
		}
		
		public function updataCareer(value:int):void
		{
			updateInfo();
		}
		
		public function updateEquipByType(type:int):void
		{
			_rolePanel.upDateEquipByType(type);
		}
		
		public function upDateExp(data:int):void
		{
			_rolePanel.upDateExp(data);
		}
		
		public function updateAllEquip():void
		{
			_rolePanel.upDateAllEquip();
		}
		
		public function updateComBat():void
		{
			_rolePanel.updateComBat();
		}
		
		public function updataNmae():void
		{
			_nameTextBox.htmlText = "<font color='#72f472'>" + Cache.instance.role.playerInfo.name +"</font>";
		}
		
		public function updateGuid():void
		{
			_guideTextBox.htmlText = "<font color='#f8eacd'>" + Cache.instance.guild.selfGuildInfo.selfInfo.guildName +"</font>";
		}
		
		public function uodateSignature():void
		{
			var str:String = Cache.instance.role.playerInfo.signature == ""? Language.getString(30144):Cache.instance.role.playerInfo.signature;
			_signatureText.htmlText = "<font color='#a49e91'>" + str +"</font>";
		}
	}
}