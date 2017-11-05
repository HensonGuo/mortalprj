package mortal.game.view.wizard
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GImageButtonTabBar;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import fl.controls.CheckBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import mortal.common.GTextFormat;
	import mortal.common.display.LoaderHelp;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.WizardConfig;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.game.view.common.SecTimerView;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.wizard.data.WizardData;
	import mortal.game.view.wizard.panel.BaseWizardPanel;
	import mortal.game.view.wizard.panel.SoulPanel;
	import mortal.game.view.wizard.panel.WizardTabCellRenderer;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class WizardModule extends BaseWindow
	{
		//数据
		private var _currentWizardData:WizardData;
		
		private var _isLoaded:Boolean = false;
		
		private var _loadCallBackDic:Dictionary;
		
		//显示对象
		/**分组导航*/
		private var _tabBar:GTileList;
		
		private var _tabBar2:GTabarNew;
		
		//左边
		/** 进度条 */
		private var _progressBar:BaseProgressBar;
		
		private var _upgradeBtn:GLoadingButton;
		
		private var _leftTime:SecTimerView;
		
		private var _powerBg:GBitmap;
		
		private var _name:GBitmap;
		
		private var _soulPanel:SoulPanel;
		
		/** 进度点 */
		private var _progressPoint:GBitmap;
		
		//右边
		private var _vcAttributeName:Vector.<String> = new Vector.<String>();
		private var _vcAttributeName2:Vector.<String> = new Vector.<String>();
		private var _vcAttributeNameText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeAddValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeAddValueBitMap:Vector.<GBitmap> = new Vector.<GBitmap>();
		
		private var _selsetBtn:GButton;
		
		private var _fastUpgrade:GCheckBox;
		
		
		public function WizardModule($layer:ILayer=null)
		{
			super($layer);
			init();
		}
		
		private function init():void
		{
			setSize(786,525);
			this.layer = LayerManager.windowLayer3D;
			title = Language.getString(30400);
			titleIcon = ImagesConst.PackIcon;
			_titleHeight = 90;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_tabBar = UIFactory.tileList(10,33,650,60,this);
			_tabBar.rowHeight = 58;
			_tabBar.columnWidth = 92;
			_tabBar.horizontalGap = 0;
			_tabBar.verticalGap = 0;
			_tabBar.setStyle("skin", new Bitmap());
			_tabBar.setStyle("cellRenderer", WizardTabCellRenderer);
			_tabBar.addEventListener(Event.CHANGE,tabBarChangeHandler);
			
			
			var arr:Array = [{name: "page1", label: "1", pageIndex: 0}, {name: "page2", label: "2", pageIndex: 1}, 
				{name: "page3", label: "3", pageIndex: 2}, {name: "page4", label: "4", pageIndex: 3}];
			_tabBar2 = UICompomentPool.getUICompoment(GTabarNew);
			_tabBar2.x = 400;
			_tabBar2.y = 45;
			_tabBar2.dataProvider = arr;
			_tabBar2.buttonHeight = 30;
			_tabBar2.buttonWidth = 80;
			_tabBar2.setWidth(400);
			addChild(_tabBar2);
			
			//中间
			_soulPanel = UICompomentPool.getUICompoment(SoulPanel);
			_soulPanel.x = 18;
			_soulPanel.y = 98;
			this.addChild(_soulPanel);
			
			//左边
			pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30402),30, 468, 120, 20, this._content3DSprite));
			pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30403),30, 487, 120, 20, this._content3DSprite));
			
			_upgradeBtn = UIFactory.gLoadingButton(ResFileConst.WizardUpgrade,235,445,111,60,this._content3DSprite);
			_upgradeBtn.drawNow();
			_upgradeBtn.configEventListener(MouseEvent.CLICK,upgradeHandler);
			
			_fastUpgrade = UIFactory.checkBox(Language.getString(30404),446,487,120,20,this._content3DSprite);
			_fastUpgrade.configEventListener(Event.CHANGE,fastUpgradeHandler);
			
			var textFormat:GTextFormat = GlobalStyle.textFormatItemGreen;
			textFormat.align = TextFormatAlign.LEFT;
			
			_leftTime = UICompomentPool.getUICompoment(SecTimerView);
			_leftTime.autoSize = TextFieldAutoSize.LEFT;
			_leftTime.mouseEnabled = false;
			_leftTime.defaultTextFormat = textFormat;
//			_leftTime.filters = [FilterConst.glowFilter];
			_leftTime.setParse(Language.getString(30083));//HH:mm:ss
			_leftTime.configEventListener(EventName.SecViewTimeChange,onSecViewTimeChangeHandler);
			_leftTime.x = 405;
			_leftTime.y = 424;
			this._content3DSprite.addChild(_leftTime);
			
			_progressBar = UICompomentPool.getUICompoment(BaseProgressBar);
		    _progressBar.setBg(ImagesConst.StrengthenBarBg, true, 214, 5);
			_progressBar.setProgress(ImagesConst.StrengthenBar, true, 0, 0, 214, 5);
			_progressBar.setLabel(BaseProgressBar.ProgressBarTextNone, 20, -2, 60, 12);
			_progressBar.setValue(0, 10000);
			_progressBar.x = 186;
			_progressBar.y = 431;
			addChild(this._progressBar);
			
			_progressPoint = UIFactory.gBitmap(ImagesConst.StrengthenBarPoint,0,-5,_progressBar);
			updateProgressBar(0,100);
			
			_powerBg = UIFactory.gBitmap("",30,104,this);
			
			_name = UIFactory.gBitmap("",201,103,this._content3DSprite);
			
			
			//右边属性
			pushUIToDisposeVec(UIFactory.bg(566, 97, 208, 413, this));
			pushUIToDisposeVec(UIFactory.bg(566, 98, 208, 26, this, ImagesConst.RegionTitleBg));
			pushUIToDisposeVec(UIFactory.bg(566, 398, 208, 26, this, ImagesConst.RegionTitleBg));
			
			_selsetBtn = UIFactory.gButton(Language.getString(30401),640,480,63,23,this);
			
			_vcAttributeName.length = 0;
			_vcAttributeName2.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_vcAttributeAddValueBitMap.length = 0;
			_vcAttributeName.push("attack", "physDefense", "magicDefense", "penetration", "jouk", "hit", "crit", "toughness", "block", "expertise", "damageReduce");
			var tempTextField:GTextFiled;
			var tempBitmap:GBitmap;
			for (var i:int ; i < _vcAttributeName.length; i++)
			{
				//属性名
				tempTextField = UIFactory.gTextField(GameDefConfig.instance.getAttributeName(_vcAttributeName[i]), 574, 130 + 24 * i, 55, 20, this, GlobalStyle.textFormatAnjin);
				_vcAttributeNameText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性数值
				tempTextField = UIFactory.gTextField("0", 638, 130 + 24 * i, 60, 20, this, GlobalStyle.textFormatPutong);
				_vcAttributeValueText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性加成值
				tempTextField = UIFactory.gTextField("0", 730, 130 + 24 * i, 60, 20, this, GlobalStyle.textFormatItemGreen);
				_vcAttributeAddValueText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性增加图标
				tempBitmap = UIFactory.gBitmap("",715,134 + 24 * i,this);
				_vcAttributeAddValueBitMap.push(tempBitmap);
				pushUIToDisposeVec(tempBitmap);
			}
			
			_loadCallBackDic = new Dictionary();
			
			LoaderHelp.addResCallBack(ResFileConst.wizardTab, showTabSkin);  //设置tab皮肤
			
			LoaderHelp.addResCallBack(ResFileConst.wizard, showSkin);
			
			updateLeftTime();
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_tabBar.dispose(isReuse);
			_tabBar = null;
			
			_soulPanel.dispose(isReuse);
			_soulPanel = null;
			
			_upgradeBtn.dispose(isReuse);
			_upgradeBtn = null;
			
			_leftTime.dispose(isReuse);
			_leftTime = null;
			
			_selsetBtn.dispose(isReuse);
			_selsetBtn = null;
			
			_fastUpgrade.dispose(isReuse);
			_fastUpgrade = null;
			
			_progressBar.dispose(isReuse);
			_progressBar = null;
			
			_progressPoint.dispose(isReuse);
			_progressPoint = null;
			
			_name.dispose(isReuse);
			_name = null;
			
			if(_powerBg)
			{
				_powerBg.dispose(isReuse);
				_powerBg = null;
			}
			
			_vcAttributeName.length = 0;
			_vcAttributeName2.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_vcAttributeAddValueBitMap.length = 0;
			
			_loadCallBackDic = null;
		}
		
		private function showTabSkin():void
		{
			_tabBar.dataProvider = getDateProvider();
			_tabBar.selectedIndex = 0;
			tabBarChangeHandler();
		}
		
		private function showSkin():void
		{
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.WizardText_1,574,104,this));
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.WizardText_2,715,104,this));
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.WizardText_3,574,405,this));
			
			_powerBg.bitmapData = GlobalClass.getBitmapData(ImagesConst.ReikiBg);
			
			if(!_isLoaded && _currentWizardData)
			{
				_name.bitmapData = GlobalClass.getBitmapData("wizardName_" + _currentWizardData.soulId);
			}
			
			_isLoaded = true;
//			callBack();
		}
		
//		private function callBack():void
//		{
//			for (var key:String in _loadCallBackDic)
//			{
//				setCallBack(key,_loadCallBackDic[key]);
//			}
//		}
//		
//		private function setCallBack(key:String,...arg):void
//		{
//			if(_isLoaded)
//			{
//				switch( arg.length )
//				{
//					case 0:
//						this[key]();
//						break;
//					case 1:
//						this[key]( arg[0] );
//						break;
//					case 2:
//						this[key]( arg[0], arg[1] );
//						break;
//					case 3:
//						this[key]( arg[0], arg[1], arg[2] );
//						break;
//				}
//			}
//			else
//			{
//				_loadCallBackDic[key] = arg;
//			}
//		}
		
		private function getDateProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			var arr:Vector.<WizardData> = Cache.instance.wizard.soulList;
			
			for each(var i:WizardData in arr)
			{
				var obj:Object = {"data":i};
				dataProvider.addItem(obj);
			}
			
			return dataProvider;
		}
		
		/**
		 *剩余时间改变 
		 * @param e
		 * 
		 */		
		private function onSecViewTimeChangeHandler(e:DataEvent):void
		{
			var leftTime:int = e.data as int;
		}
		
		
		private function upgradeHandler(e:MouseEvent):void
		{
			if(!_currentWizardData.isHasWizard)
			{
				MsgManager.showRollTipsMsg("该精灵尚未激活");
				return;
			}
		    Dispatcher.dispatchEvent(new DataEvent(EventName.UpgradeSoul,_currentWizardData));
		}
		
		private function tabBarChangeHandler(e:Event = null):void
		{
			_soulPanel.setWizardInfo(_tabBar.selectedItem.data as WizardData);
			data = _tabBar.selectedItem.data as WizardData;
		}
		
		private function set data(value:WizardData):void
		{
			_currentWizardData = value;
			
			if(_isLoaded)
			{
				_name.bitmapData = GlobalClass.getBitmapData("wizardName_" + _currentWizardData.soulId);
			}
			
		    if(_currentWizardData.isHasWizard)
			{
				_upgradeBtn.mouseEnabled = true;
				_upgradeBtn.filters = [];
			}
			else
			{
				_upgradeBtn.mouseEnabled = false;
				_upgradeBtn.filters = [FilterConst.colorFilter2];
			}
			
		}
		
		private function fastUpgradeHandler(e:Event):void
		{
			
		}
		
		/**
		 * 更新进度条 
		 * @param currValue  当前进度值
		 * @param totalValue 总进度值
		 */
		public function updateProgressBar(currValue:Number,totalValue:Number):void
		{
			this._progressBar.setValue(currValue,totalValue);
			this._progressPoint.x = this._progressBar.lastWidth - 3;// 设置进度点位置
		}
		
		public function updateWizardList():void
		{
			LoaderHelp.addResCallBack(ResFileConst.wizardTab, showTabSkin);  //设置tab皮肤
		}
		
		public function updateLeftTime():void
		{
//			var cdData:CDData;
//			
//			var leftSeconds:int;
//			if(_currentWizardData && _currentWizardData.isHasWizard)   //判断是否有剩余时间
//			{
//				cdData = Cache.instance.cd.getCDData("WiardTiem",CDDataType.backPackLock) as CDData;
//				if(cdData)
//				{
//					leftSeconds = cdData.leftTime/1000;
//				}
//				else
//				{
//					leftSeconds = 0;
//					_leftTime.stop();
//				}
//			}
//			else
//			{
//				leftSeconds = 0;
//				_leftTime.stop();
//			}
//			
//			_leftTime.setLeftTime(leftSeconds);
		}
		
		
	}
}