package mortal.game.view.mount.panel
{
	import Message.Public.EMountState;
	
	import com.gengine.global.Global;
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.manager.ToolTipSprite;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.MountUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.BitmapText;
	import mortal.game.view.mount.MountCache;
	import mortal.game.view.mount.data.MountData;
	import mortal.game.view.mount.data.MountToolData;
	import mortal.mvc.core.Dispatcher;
	
	public class MountInfoPanel extends Mount3DPanel
	{
		//右边
		private var _mountAtrribuitePanel:MountAtrribuitePanel;
		
		private var _equipmentBtn:GButton;
		
		//左边
		private var _toolTipSp:ToolTipSprite;
		
		private var _selectMountBtn:GButton;
		
		private var _totalScore:GBitmap;
		
		private var _level:GTextFiled;
		
		private var _lineage:GTextFiled;
		
		private var _leftBtn:GLoadedButton;
		
		private var _rightBtn:GLoadedButton;
		
		public function MountInfoPanel(window:Window)
		{
			super(window);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
//			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountPanel,0,0,this));
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountLevel,22,284,_window.contentTopOf3DSprite));
			this.pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountLineage,369,284,_window.contentTopOf3DSprite));
			
			//左边
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.align = AlignMode.CENTER;
			
			_level = UIFactory.gTextField("Lv.0",23,317,80,20,_window.contentTopOf3DSprite,tf);
			
			_lineage = UIFactory.gTextField("0",375,317,80,20,_window.contentTopOf3DSprite,tf);
			
			
			_equipmentBtn = UIFactory.gButton("", 609, 106, 45, 25, _window.contentTopOf3DSprite);
			_equipmentBtn.label = Language.getString(30303);
			_equipmentBtn.configEventListener(MouseEvent.CLICK,equipHandler);
			
			_selectMountBtn = UIFactory.gButton(Language.getString(30306), 184, 317, 112, 30, _window.contentTopOf3DSprite,"MountBtn");
			_selectMountBtn.configEventListener(MouseEvent.CLICK,selectRideMount);
			
			
			_toolTipSp = UICompomentPool.getUICompoment(ToolTipSprite);
			_toolTipSp.x = 404;
			_toolTipSp.y = 100;
			_toolTipSp.buttonMode = true;
			_toolTipSp.mouseChildren = false;
			_window.contentTopOf3DSprite.addChild(_toolTipSp);
			
			_totalScore = UIFactory.gBitmap(ImagesConst.TotalScore, 0, 0, _toolTipSp);
			
			//右边
			_mountAtrribuitePanel = UICompomentPool.getUICompoment(MountAtrribuitePanel);
			_mountAtrribuitePanel.createDisposedChildren();
			_mountAtrribuitePanel.x = -22;
			_mountAtrribuitePanel.y = -74;
			this.addChild(_mountAtrribuitePanel);
			
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30307),471,98,80,20,_window.contentTopOf3DSprite,GlobalStyle.textFormatAnjin));
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30308),471,118,80,20,_window.contentTopOf3DSprite,GlobalStyle.textFormatAnjin));
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_equipmentBtn.dispose(isReuse);
			_level.dispose(isReuse);
			_lineage.dispose(isReuse);
			_mountAtrribuitePanel.dispose(isReuse);
			_selectMountBtn.dispose(isReuse);
			_toolTipSp.dispose(isReuse);
			_totalScore.dispose(isReuse);
		
			
			_equipmentBtn = null;
			_level = null;
			_lineage = null;
			_mountAtrribuitePanel = null;
			_selectMountBtn = null;
			_toolTipSp = null;
			_totalScore = null;
		
			
			super.disposeImpl(isReuse);
		}
		
		/**
		 * 选择要骑乘的坐骑 
		 * @param e
		 * 
		 */		
		private function selectRideMount(e:MouseEvent):void
		{
			if(e.target == _selectMountBtn && _mountData && _mountData.isOwnMount)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.ChangeRideMount,_mountData.sPublicMount.uid));
			}
		}
		
		/**
		 * 装备和卸下 
		 * @param e
		 * 
		 */		
		private function equipHandler(e:MouseEvent):void
		{
			if(!Cache.instance.mount.isHasMount)   //没有坐骑则点击无效
			{
				MsgManager.showRollTipsMsg(Language.getString(30315));
				return;
			}
			var obj:Object;
			switch(Cache.instance.mount.state)
			{
				case EMountState._EMountStateDress:
					obj = {"uid":"" , "state":EMountState._EMountStateUndress};
					break;
				case EMountState._EMountStateUndress:
					obj = {"uid":"" , "state":EMountState._EMountStateDress};
					break;
				case 0:
					obj = {"uid":"" , "state":EMountState._EMountStateDress};
					break;
//				default:
//					obj = {"uid":"" , "state":EMountState._EMountStateUndress};
//					break;
			}
			if(obj)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.SetMountState,obj));
			}

		}
		
			
		override public function setMountInfo(mountData:MountData):void
		{
			super.setMountInfo(mountData);
			
			if(_mountAtrribuitePanel)
			{
				_mountAtrribuitePanel.setMountInfo(mountData);
			}
			
			setInfo();
			
			setEquipBtn();
		}
		
		override public function clearWin():void
		{
			super.clearWin();
			_level.text = "Lv.0";
			_lineage.text = "0";
			_mountAtrribuitePanel.clearWin();
		}
		
		override public function setInfo():void
		{
//			if(_mountData && _mountData.isOwnMount)
//			{
//				updateRoleModel();
//			}
//			else
//			{
//				clearWin();
//				return;
//			}
			
			super.setInfo();
			if(_mountData && _mountData.sPublicMount )
			{
				_level.text = "Lv." + _mountData.sPublicMount.level.toString();
				
				if(Cache.instance.mount.isCurrentMount(_mountData.itemMountInfo.code))
				{
					_selectMountBtn.label = Language.getString(30305);
					_selectMountBtn.enabled = false;
				}
				else
				{
					_selectMountBtn.label = Language.getString(30306);
					_selectMountBtn.enabled = true;
				}
			}
			
			var totalLevel:int;
			for each(var i:MountToolData in _mountData.toolList)
			{
				totalLevel += i.level;
			}
			
			_lineage.text = totalLevel.toString();
			
			_mountAtrribuitePanel.setInfo();
		}

		
		public function setAllMountsAtrribuite():void
		{
			if(_mountAtrribuitePanel && Cache.instance.mount.isHasMount)
			{
				_mountAtrribuitePanel.setAllMountsAtrribuite();
			}
		
		}
		
		public function setEquipBtn():void
		{
			var mountCaChe:MountCache = Cache.instance.mount;
			if(mountCaChe.isHasMount)
			{
				switch(mountCaChe.state)
				{
					case EMountState._EMountStateDress:
						_equipmentBtn.label = Language.getString(30303);
						break;
					case EMountState._EMountStateUndress:
						_equipmentBtn.label = Language.getString(30302);
						break;
				}
			}
			else
			{
				_equipmentBtn.label = Language.getString(30302);
			}
			
		}
		
		public function setSelectMountBtn():void
		{
			if(_mountData)
			{
				if(Cache.instance.mount.isCurrentMount(_mountData.itemMountInfo.code))
				{
					_selectMountBtn.label = Language.getString(30305);
					_selectMountBtn.enabled = false;
				}
				else
				{
					_selectMountBtn.label = Language.getString(30306);
					_selectMountBtn.enabled = true;
				}
			}
			else
			{
				_selectMountBtn.label = Language.getString(30306);
				_selectMountBtn.enabled = true;
			}
		}
	}
}