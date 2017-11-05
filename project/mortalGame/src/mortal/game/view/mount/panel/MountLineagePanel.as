package mortal.game.view.mount.panel
{
	import Message.DB.Tables.TMountUp;
	import Message.Game.ERand;
	import Message.Public.EPrictUnit;
	
	import com.gengine.core.IDispose;
	import com.gengine.utils.ObjectUtils;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.core.IFrUIContainer;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.tableConfig.MountConfig;
	import mortal.game.utils.MountUtil;
	import mortal.game.view.common.ClassTypesUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.GLabelButton;
	import mortal.component.ui.GConsumeBox;
	import mortal.game.view.mount.data.CultureData;
	import mortal.game.view.mount.data.MountData;
	import mortal.game.view.mount.data.MountToolData;
	import mortal.mvc.core.Dispatcher;
	

	public class MountLineagePanel extends MountBasePanel
	{
		private var _oldMountToolList:Vector.<MountToolData> = new Vector.<MountToolData>;  //用于比较是否等级上升了
		
		private var _scoreArr:Array; //显示结果的显示列表数组
		
		private var _multiple:int;  //倍数
		
		//左边
		private var _autoBuyBox:GCheckBox;
		
		private var _nomalBtn:GLabelButton;
		
		private var _moneyBtn:GLabelButton;
		
		private var _lineageTileList:GTileList;
		
		private var _mount_777:Mount_777;
		
		private var _bg:GBitmap;
		
		private var _consumeBox:GConsumeBox;
		
		
		//右边
		private var _vcAttributeName:Vector.<String> = new Vector.<String>();
		private var _vcAttributeName2:Vector.<String> = new Vector.<String>();
		private var _vcAttributeNameText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		private var _vcAttributeAddValueText:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		
		

		public function MountLineagePanel()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_scoreArr = new Array();
			
			//左边
			_bg = UIFactory.gBitmap("",0,0,this);
			
//			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30314),10,277,80,25,this));
			
			_consumeBox = UIFactory.gConsumeBox(Language.getString(30314),10,277,55,this);
			_consumeBox.addItem(110000002,2);
			_consumeBox.addMoney(EPrictUnit._EPriceUnitCoin,2000);
			_consumeBox.addItem(110000003,2);
			
//			_autoBuyBox = UIFactory.checkBox(Language.getString(30313),307,275,130,25,this);
//			_autoBuyBox.configEventListener(Event.CHANGE,autoBuy);
			
			_nomalBtn = UIFactory.gLabelButton(ImagesConst.MountBtnTxt_1, GLabelButton.gLoadedButton, ImagesConst.MountBtn_upSkin, 116, 238, 98, 38, this);
			_nomalBtn.paddingBottom = 6;
			_nomalBtn.configEventListener(MouseEvent.CLICK,improveMount);
			_nomalBtn.mouseChildren = true;
			
			_moneyBtn = UIFactory.gLabelButton(ImagesConst.MountBtnTxt_2, GLabelButton.gLoadedButton, ImagesConst.MountBtn_upSkin, 226, 238, 98, 38, this);
			_moneyBtn.paddingBottom = 6;
			_moneyBtn.configEventListener(MouseEvent.CLICK,improveMount);
			_moneyBtn.mouseChildren = true;
			
			_lineageTileList = UIFactory.tileList(42,5,360,80,this);
			_lineageTileList.rowHeight = 60;
			_lineageTileList.columnWidth = 70;
			_lineageTileList.horizontalGap = 3;
			_lineageTileList.verticalGap = 3;
			_lineageTileList.setStyle("cellRenderer", LineageCellRenderer);
			this.addChild(_lineageTileList);
			
			_mount_777 = UICompomentPool.getUICompoment(Mount_777);
			_mount_777.horizontalGap = 78;
			_mount_777.verticalGap = 26;
			_mount_777.showWide = 206;
			_mount_777.showHight = 74;
			_mount_777.x = 120;
			_mount_777.y = 88;
			this.addChild(_mount_777);
			_mount_777.configEventListener("Mount777End",mount777End);
			
			
			//右边
			//右边属性
			pushUIToDisposeVec(UIFactory.bg(443, -1, 208, 303, this));
			pushUIToDisposeVec(UIFactory.bg(443, 0, 208, 26, this, ImagesConst.TextBg2));
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountText2,451,6,this));
			
			_vcAttributeName.length = 0;
			_vcAttributeName2.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_vcAttributeName.push("attack", "life","physDefense", "magicDefense", "penetration", "jouk", "hit", "crit", "toughness", "block", "expertise");
			_vcAttributeName2.push("attack","life", "physDefense", "magicDefense", "addPenetration", "addJouk", "addHit", "addCrit", "addToughness", "addBlock", "addExpertise");
			var tempTextField:GTextFiled;
			var tempBitmap:GBitmap;
			for (var i:int ; i < _vcAttributeName.length; i++)
			{
				//属性名
				tempTextField = UIFactory.gTextField(GameDefConfig.instance.getAttributeName(_vcAttributeName[i]), 451, 33 + 24 * i, 55, 20, this, GlobalStyle.textFormatAnjin);
				_vcAttributeNameText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性数值
				tempTextField = UIFactory.gTextField("0", 515, 33 + 24 * i, 60, 20, this, GlobalStyle.textFormatPutong);
				_vcAttributeValueText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
				
				//属性加成值
				tempTextField = UIFactory.gTextField("", 580, 33 + 24 * i, 60, 20, this, GlobalStyle.textFormatItemGreen);
				_vcAttributeAddValueText.push(tempTextField);
				pushUIToDisposeVec(tempTextField);
			}
			
			LoaderHelp.addResCallBack(ResFileConst.mountLineAge, showSkin);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			disposeResultArr();
			
			_nomalBtn.dispose(isReuse);
			_moneyBtn.dispose(isReuse);
			_consumeBox.dispose(isReuse);
			
			_lineageTileList.dispose(isReuse);
			_mount_777.dispose(isReuse);
			_bg.dispose(isReuse);
			
			_nomalBtn = null;
			_moneyBtn = null;
			_consumeBox = null;
	
			
			_lineageTileList = null;
			_mount_777 = null;
			_bg = null;
			
			_vcAttributeName.length = 0;
			_vcAttributeName2.length = 0;
			_vcAttributeNameText.length = 0;
			_vcAttributeValueText.length = 0;
			_vcAttributeAddValueText.length = 0;
			_oldMountToolList.length = 0;
			_scoreArr.length = 0;
			
			_multiple = 0;
			
		}
		
		private var isLoaded:Boolean;
		private function showSkin():void
		{
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountText6,562,6,this));
			
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.MountStopBg,99,112,this));
			
			_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.LineageBg);
			
			var bg777:GBitmap;
			for(var i:int ; i < 3; i++)
			{
				bg777 = UIFactory.gBitmap(ImagesConst.Mount_777bg,99 + i*80,91,this);
				this.pushUIToDisposeVec(bg777);
				this.setChildIndex(bg777,1);
				bg777 = null;
			}
			
			
			if(!isLoaded && _mountData && _mountData.isOwnMount)
			{
				setInfo();
				set777Data();
				isLoaded = true;
			}
		
		}
		
		override public function setMountInfo(mountData:MountData):void
		{
			if(mountData != _mountData)  //不是同一匹坐骑的时候
			{
				_oldMountToolList.length = 0;
				disposeResultArr();
				_moneyBtn.mouseChildren = true;
				_nomalBtn.mouseChildren = true;
			}
			
			super.setMountInfo(mountData);
			
			if(_mountData == null || !_mountData.isOwnMount)
			{
				return ;
			}
			
			if(isLoaded)
			{
				setInfo();
				set777Data();
			}
			
		}
		
		override public function clearWin():void
		{
			super.clearWin();
			for (var i:int = 0; i < _vcAttributeName.length; i++)
			{
				_vcAttributeValueText[i].text = "0";
				_vcAttributeAddValueText[i].text = "";
			}
			
			_lineageTileList.dataProvider = getDataProvider();
		}
		
		override public function setInfo():void
		{
			super.setInfo();
			
			_lineageTileList.dataProvider = getDataProvider();
			
			for (var i:int = 0; i < _vcAttributeName.length; i++)
			{
				var extr:int = 0;
				var addExtr:int = 0;
				var tmountUp:TMountUp = (MountConfig.instance.mountUpDec[_mountData.sPublicMount.level] as TMountUp);
				
				if(tmountUp.hasOwnProperty(_vcAttributeName[i]))
				{
					//计算本级属性
					extr += tmountUp[_vcAttributeName[i]];
					
//					//计算下级属性
//					nextExtr = (MountConfig.instance.mountUpDec[_mountData.sPublicMount.level + 1] as TMountUp)[_vcAttributeName[i]] - (MountConfig.instance.mountUpDec[_mountData.sPublicMount.level] as TMountUp)[_vcAttributeName[i]];
				}
				
				for (var n:String in _mountData.toolList)  //计算777属性加成
				{
					if(_mountData.toolList[n].name.toLocaleLowerCase() == "add" + _vcAttributeName[i])
					{
						//计算血统附加值
						extr += int((MountConfig.instance.getMountToolLevel(_mountData.toolList[n].level).add / 10000)*_mountData.itemMountInfo[_mountData.toolList[n].name]);
					
						//计算是否升级了,是的话就显示增加的数值
						if(_oldMountToolList.length && _oldMountToolList[n].level != _mountData.toolList[n].level)  
						{
//							addExtr = ((MountConfig.instance.getMountToolLevel(_mountData.toolList[n].level).add - MountConfig.instance.getMountToolLevel(_oldMountToolList[n].level).add) / 10000)*_mountData.itemMountInfo[_mountData.toolList[n].name];
							addExtr = int((MountConfig.instance.getMountToolLevel(_mountData.toolList[n].level).add / 10000)*_mountData.itemMountInfo[_mountData.toolList[n].name]) - int((MountConfig.instance.getMountToolLevel(_oldMountToolList[n].level).add / 10000)*_mountData.itemMountInfo[_mountData.toolList[n].name]);
						}
					}
					
				}
				
				_vcAttributeValueText[i].text = String(_mountData.itemMountInfo[_vcAttributeName[i]] + extr);
				_vcAttributeAddValueText[i].text = addExtr == 0? "":"(+" + addExtr + ")";
			}
			
		}
		
		private function hidAddValue():void
		{
			for (var i:int = 0; i < _vcAttributeName.length; i++)
			{
				_vcAttributeAddValueText[i].text = "";
			}
		}
		
		private function set777Data():void
		{
			if(_mountData == null && !_mountData.isOwnMount)
			{
				return;
			}
			
			if(MountUtil.isExistMount(_mountData))
			{
				return;
			}
			
			var arr:Array = new Array();
			for each(var i:MountToolData in _mountData.toolList)
			{
				arr.push(i.name);
			}
			arr.push(ImagesConst.Mount_all);
			arr.push(ImagesConst.Mount_none);
			
			_mount_777.setData(arr);
		}
		
		private function getDataProvider():DataProvider
		{
			var dataProvider:DataProvider = new DataProvider();
			
			if(_mountData && _mountData.isOwnMount)
			{
				for each(var i:MountToolData in _mountData.toolList)
				{
					var obj:Object = new Object();
					obj.data = i;
					dataProvider.addItem(obj);
				}
			}
			
			return dataProvider;
		}
		
		/**
		 * 提升坐骑宝具 
		 * @param e
		 * 
		 */		
		private function improveMount(e:MouseEvent):void
		{
			if(_mountData == null)
			{
				return;
			}
			else if(MountUtil.isExistMount(_mountData))
			{
				MsgManager.showRollTipsMsg(Language.getString(30317));
				return;
			}
			else if(MountUtil.isToolMaxLevel(_mountData))
			{
				MsgManager.showRollTipsMsg("坐骑宝具已满级");
				return;
			}
			
			
			var cultureData:CultureData = new CultureData();
			cultureData.uid = _mountData.sPublicMount.uid;
			
			if(MountUtil.isHasLineageItem())
			{
				cultureData.type = 1;
			}
			else
			{
				cultureData.type = 2;
			}
			
			if((e.target as GLoadedButton).parent == _moneyBtn)  //10倍
			{
				if(!MountUtil.isEnougthToLineage(10))
				{
					return ;
				}
				
				if(cultureData.type == 1)
				{
					cultureData.itemCount = 10;
				}
				else
				{
					cultureData.goldCount = 10;
				}
				
				
				Dispatcher.dispatchEvent(new DataEvent(EventName.CultureLinageMount,cultureData));
			}
			else if((e.target as GLoadedButton).parent == _nomalBtn)  //普通
			{
				if(!MountUtil.isEnougthToLineage(1))
				{
					return ;
				}
				
				if(cultureData.type == 1)
				{
					cultureData.itemCount = 1;
				}
				else
				{
					cultureData.goldCount = 1;
				}
				
				Dispatcher.dispatchEvent(new DataEvent(EventName.CultureLinageMount,cultureData));
			}
			
			_moneyBtn.mouseChildren = false;
			_nomalBtn.mouseChildren = false;
//	
		}
		
		public function startRuning(obj:Object):void
		{
			var arr:Array = obj.valueArr;
			_multiple = obj.num;
			
            //保存本次升级前道具的等级,让下级可以判断是否有升级
			_oldMountToolList.length = 0;
			for each(var m:MountToolData in _mountData.toolList)
			{
				var obj:Object = {"exp":m.exp,"tl":m.level,"t":m.index};
				_oldMountToolList.push(new MountToolData(m.name,obj));
			}
			
			hidAddValue();  //隐藏上次数值
			
			_scoreArr.length = 0;
			for each(var i:int in arr)
			{
				if(i == 0)
				{
					MsgManager.showRollTipsMsg("全部");
					_scoreArr.push(ImagesConst.Mount_all);
				}
				else if(i == 6)
				{
					MsgManager.showRollTipsMsg("无");
					_scoreArr.push(ImagesConst.Mount_none);
				}
				else
				{
					MsgManager.showRollTipsMsg(_mountData.toolList[i - 1].name);
					_scoreArr.push( _mountData.toolList[i - 1].name);
				}
				
			}
			
			disposeResultArr();
			
			_mount_777.startRuning(_scoreArr)
		}
		
		/**
		 *  显示777结果的显示对象数组
		 */		
		private var _resultArr:Vector.<IDispose>;
		public function mount777End(e:Event):void
		{
			_moneyBtn.mouseChildren = true;
			_nomalBtn.mouseChildren = true;
			
			setInfo();
			
			var dic:Dictionary = new Dictionary();
			var arr:Array = new Array();
			_resultArr = new Vector.<IDispose>;
			
			for each(var i:String in _scoreArr)
			{
				dic[i] = int(dic[i]) + 1;
				
				if(arr.indexOf(i) == -1)
				{
					arr.push(i);
				}
			}
			
			var maxValue:int = 0;
			var index:int = 0;
			var _scoreBg:GBitmap = UIFactory.gBitmap("",61,172,this);
			var box:GSprite = UICompomentPool.getUICompoment(GSprite);
			box.y = 185;
		    addChild(box);
			
			_resultArr.push(box);
			_resultArr.push(_scoreBg);
			
			for (var n:String in arr)
			{
				if(arr[n] != ImagesConst.Mount_none)
				{
					var name:GBitmap = UIFactory.gBitmap(arr[n],120*index,0,box);
					var value:GTextFiled = UIFactory.gTextField("经验+" + Math.pow(4,dic[arr[n]] - 1)*100*_multiple,name.x + name.width - 2,3,72,20,box);
					_resultArr.push(name,value);
					index++;
					
					if(dic[arr[n]] > maxValue)
					{
						maxValue = dic[arr[n]];
					}
				}
				
				if(maxValue == 3 && arr[n] == ImagesConst.Mount_all )
				{
					maxValue = 4;
				}
			}
			
			box.x = (440 - box.width)/2;
			_scoreBg.bitmapData = GlobalClass.getBitmapData("MountScoBg_" + maxValue);
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.Mount777End));
			
		}
		
		private function disposeResultArr():void
		{
			if(_mount_777.isRuning)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.Mount777End));
			}
			
			if(_resultArr == null)
			{
				return ;
			}
			
			for each(var i:IDispose in _resultArr)
			{
				i.dispose(true);
			}
			_resultArr.length = 0;
			
		}
		
	}
}