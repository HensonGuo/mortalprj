package mortal.game.view.pack
{
	import Message.Public.EPrictUnit;
	
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.common.net.CallLater;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.CursorManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.button.TimeButton;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.common.display.TextBox;
	import mortal.game.view.common.util.MoneyUtil;
	import mortal.game.view.effect.AttriAddEffect;
	import mortal.mvc.core.Dispatcher;
	
	public class PackBottomPart extends GSprite
	{
		//显示对象
		private var _bmpYuanbao:GBitmap;
		private var _bmpTongqian:GBitmap;
		private var _bmpYuanbaoBind:GBitmap;
		private var _bmpTongqianBind:GBitmap;
		
		private var _goldTextBox:TextBox;
		private var _coinTextBox:TextBox;
		private var _goldBindTextBox:TextBox;
		private var _coinBindTextBox:TextBox;
		
		private var _btnShop:GButton;
		private var _btnCan:GButton;
		private var _btnFix:GButton;
		private var _btnJishou:GButton;
		private var _btnChushou:GButton;
		private var _btnHebing:TimeButton;
		private var _btnZhengli:TimeButton;
		
		private var _CapacityTxt:BitmapNumberText;
		
		//数据
		
		
		public function PackBottomPart()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this.pushUIToDisposeVec( UIFactory.bg(-1,35,333,43,this,ImagesConst.PanelBg));
			
			var tf:GTextFormat = GlobalStyle.textFormatAnHuan;
			tf.size = 11;
			
			_goldTextBox = createTextBox(0,0);
			_bmpYuanbao = UIFactory.bitmap(ImagesConst.Yuanbao,141,97,this);
			this.pushUIToDisposeVec(UIFactory.gTextField(GameDefConfig.instance.getEPrictUnitName(
				EPrictUnit._EPriceUnitGold) + " :",8,91,80,20,this,tf));
			
			_coinTextBox = createTextBox(1,0);
			_bmpTongqian = UIFactory.bitmap(ImagesConst.Jinbi,140,120,this);
			this.pushUIToDisposeVec(UIFactory.gTextField(GameDefConfig.instance.getEPrictUnitName(
				EPrictUnit._EPriceUnitCoin) + " :",8,118,80,20,this,tf));
			
			_goldBindTextBox = createTextBox(0,1);
			_goldBindTextBox.textField.x = 61;
			_bmpYuanbaoBind = UIFactory.bitmap(ImagesConst.Yuanbao_bind,306,97,this);
			this.pushUIToDisposeVec(UIFactory.gTextField(GameDefConfig.instance.getEPrictUnitName(
				EPrictUnit._EPriceUnitGoldBind) + " :",175,91,80,20,this,tf));
			
			_coinBindTextBox = createTextBox(1,1);
			_coinBindTextBox.textField.x = 61;
			_bmpTongqianBind = UIFactory.bitmap(ImagesConst.Jinbi_bind,305,120,this);
			this.pushUIToDisposeVec(UIFactory.gTextField(GameDefConfig.instance.getEPrictUnitName(
				EPrictUnit._EPriceUnitCoinBind) + " :",175,118,80,20,this,tf));
			
			var tfm:TextFormat = new TextFormat();
			tfm.color = 0xf8eacd;
			this.pushUIToDisposeVec(UIFactory.gTextField(Language.getString(30062),5,46,65,20,this,tfm,true,false));
			tfm.color = 0xffffff;
//			this.pushUIToDisposeVec(UIFactory.gTextField("/",85,45,65,22,this,tfm,true,false));
			
			_CapacityTxt = UIFactory.bitmapNumberText(67,51, "RoleInfoNum.png", 8, 10, -1, this,14);
			
			var index:int = 0;
			
			_btnShop = UIFactory.gButton(Language.getString(30064),117,43,25,25,this,"PackButton");
			
			_btnCan = UIFactory.gButton(Language.getString(30064),147,43,25,25,this,"PackButton");
			
			_btnFix = UIFactory.gButton(Language.getString(30064),177,43,25,25,this,"PackButton");
			
			_btnZhengli = UIFactory.timeButton(Language.getString(30063), 207, 43, 25, 25, this, "ZhengliBeibao","PackButton");//UICompomentPool.getUICompoment(TimeButton) as TimeButton;
			_btnZhengli.cdTime = 10000;
			
			_btnJishou = UIFactory.gButton(Language.getString(30064),237,43,25,25,this,"PackButton");
			
			_btnChushou = UIFactory.gButton(Language.getString(30003),267,43,25,25,this,"PackButton");
			
			_btnHebing = UIFactory.timeButton(Language.getString(30065), 297, 43, 25, 25, this, "HebingBeibao","PackButton");
			_btnHebing.cdTime = 10000;
			
			this.configEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_bmpYuanbao.dispose(isReuse);
			_bmpTongqian.dispose(isReuse);
			_bmpYuanbaoBind.dispose(isReuse);
			_bmpTongqianBind.dispose(isReuse);
			_goldTextBox.dispose(isReuse);
			_coinTextBox.dispose(isReuse);
			_goldBindTextBox.dispose(isReuse);
			_coinBindTextBox.dispose(isReuse);
			
			_CapacityTxt.dispose(isReuse);
			
			_btnJishou.dispose(isReuse);
			_btnChushou.dispose(isReuse);
			
			_btnJishou = null;
			_btnChushou = null;
			_CapacityTxt = null;
			
			if(_btnZhengli)
			{
				DisplayUtil.removeMe(_btnZhengli);
				_btnZhengli.dispose(isReuse);
				_btnZhengli = null;
			}
			if(_btnHebing)
			{
				DisplayUtil.removeMe(_btnHebing);
				_btnHebing.dispose(isReuse);
				_btnHebing = null;
			}
			
			super.disposeImpl(isReuse);
		}
		
		
		
		private function createTextBox(row:int,col:int):TextBox
		{
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.align = AlignMode.LEFT;
			var textbox:TextBox = UICompomentPool.getUICompoment(TextBox);
			textbox.createDisposedChildren();
			textbox.setbgStlye(ImagesConst.PanelBg,tf);
			textbox.textField.x = 40;
			textbox.textField.y = 3;
			textbox.textFieldHeight = 15;
			textbox.textFieldWidth = 80;
			textbox.bgHeight = 27;
			textbox.bgWidth = 165;
			textbox.x = col*166;
			textbox.y = 88+row*26;
			this.addChild(textbox);
			
			return textbox;
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var targetGButton:GButton = e.target as GButton;
			
			switch(targetGButton)
			{
				case _btnZhengli:
					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Tity));
					//					SoundManager.instance.soundPlay(SoundTypeConst.BackpackFinishing);
					break;
				case _btnChushou:
					CursorManager.currentCurSorType = CursorManager.SELL;
					CursorManager.showCursor(CursorManager.SELL);
					break;
				case _btnHebing:
					break;
				
			}
		}
		
		public function setCoinAmount(value:int):void
		{
			var txt:String = MoneyUtil.getFormatInt(value);
			if(txt == _coinTextBox.htmlText)
			{
				return;
			}
			_coinTextBox.htmlText = MoneyUtil.getFormatInt(value);
		}
		
		public function setCoinBindAmount(value:int):void
		{
			var txt:String = MoneyUtil.getFormatInt(value);
			if(txt == _coinBindTextBox.htmlText)
			{
				return;
			}
			_coinBindTextBox.htmlText = MoneyUtil.getFormatInt(value);
		}
		
		public function setGoldAmount(value:int):void
		{
			var txt:String = MoneyUtil.getFormatInt(value);
			if(txt == _goldTextBox.htmlText)
			{
				return;
			}
			_goldTextBox.htmlText = MoneyUtil.getFormatInt(value);
		}
		
		public function setGoldBindAmount(value:int):void
		{
			var txt:String = MoneyUtil.getFormatInt(value);
			if(txt == _goldBindTextBox.htmlText)
			{
				return;
			}
			_goldBindTextBox.htmlText = MoneyUtil.getFormatInt(value);
		}
		
		public function setCapacity():void
		{
			var val:int = Cache.instance.pack.backPackCache.itemLength;
			var capacity:int = Cache.instance.pack.backPackCache.capacity;
			_CapacityTxt.text = val + "/" + capacity;
		}
		
	}
}