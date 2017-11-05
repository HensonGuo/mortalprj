package mortal.game.view.market.sale
{
	import Message.Game.SMoney;
	import Message.Public.EPrictUnit;
	
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.TextBox;
	import mortal.game.view.common.util.MoneyUtil;
	import mortal.mvc.core.NetDispatcher;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class MktMoneys extends GSprite
	{
		private var _bmpYuanbao:GBitmap;
		private var _bmpTongqian:GBitmap;
		private var _bmpYuanbaoBind:GBitmap;
		private var _bmpTongqianBind:GBitmap;
		
		private var _goldTextBox:TextBox;
		private var _coinTextBox:TextBox;
		private var _goldBindTextBox:TextBox;
		private var _coinBindTextBox:TextBox;
		
		public function MktMoneys()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			// TODO Auto Generated method stub
			super.createDisposedChildrenImpl();
			
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.size = 11;
			
			_goldTextBox = createTextBox(0,0);
			_bmpYuanbao = UIFactory.bitmap(ImagesConst.Yuanbao,97,7,this);
			this.pushUIToDisposeVec(UIFactory.gTextField(GameDefConfig.instance.getEPrictUnitName(
				EPrictUnit._EPriceUnitGold) + " :",3,2,80,20,this,tf));
			
			_coinTextBox = createTextBox(1,0);
			_bmpTongqian = UIFactory.bitmap(ImagesConst.Jinbi,96,30,this);
			this.pushUIToDisposeVec(UIFactory.gTextField(GameDefConfig.instance.getEPrictUnitName(
				EPrictUnit._EPriceUnitCoin) + " :",3,27,80,20,this,tf));
			
			_goldBindTextBox = createTextBox(0,1);
			_bmpYuanbaoBind = UIFactory.bitmap(ImagesConst.Yuanbao_bind,216,7,this);
			this.pushUIToDisposeVec(UIFactory.gTextField(GameDefConfig.instance.getEPrictUnitName(
				EPrictUnit._EPriceUnitGoldBind) + " :",122,2,80,20,this,tf));
			
			_coinBindTextBox = createTextBox(1,1);
			_bmpTongqianBind = UIFactory.bitmap(ImagesConst.Jinbi_bind,215,30,this);
			this.pushUIToDisposeVec(UIFactory.gTextField(GameDefConfig.instance.getEPrictUnitName(
				EPrictUnit._EPriceUnitCoinBind) + " :",122,27,80,20,this,tf));
			
			
			NetDispatcher.addCmdListener(ServerCommand.MoneyUpdate, updateMoney);
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		protected function onAddToStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			updateMoney();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.disposeImpl(isReuse);
			
			NetDispatcher.removeCmdListener(ServerCommand.MoneyUpdate, updateMoney);
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			
			_bmpYuanbao.dispose(isReuse);
			_bmpTongqian.dispose(isReuse);
			_bmpYuanbaoBind.dispose(isReuse);
			_bmpTongqianBind.dispose(isReuse);
			_goldTextBox.dispose(isReuse);
			_coinTextBox.dispose(isReuse);
			_goldBindTextBox.dispose(isReuse);
			_coinBindTextBox.dispose(isReuse);
			
			_bmpYuanbao = null;
			_bmpTongqian = null;
			_bmpYuanbaoBind = null;
			_bmpTongqianBind = null;
			_goldTextBox = null;
			_coinTextBox = null;
			_goldBindTextBox = null;
			_coinBindTextBox = null;
		}
		
		private function createTextBox(row:int,col:int,width:int = 117,height:int = 23):TextBox
		{
			var tf:GTextFormat = GlobalStyle.textFormatHuang;
			tf.align = AlignMode.RIGHT;
			
			var textbox:TextBox = UICompomentPool.getUICompoment(TextBox);
			textbox.createDisposedChildren();
			textbox.defaultTextFormat = tf;
			textbox.textFieldHeight = 18;
			textbox.bgHeight = height;
			textbox.bgWidth = width;
			textbox.textField.y = 2;
			textbox.textFieldWidth = 92;
			textbox.x = col*120;
			textbox.y = row*26;
			
			//textbox.setbgStlye("InputDisablBg",textFormat);
			this.addChild(textbox);
			
			return textbox;
		}
		
		/**
		 *更新金钱
		 * @param obj
		 */
		private function updateMoney(obj:Object = null):void
		{
			var smoney:SMoney=Cache.instance.role.money;
			setCoinAmount(smoney.coin);
			setCoinBindAmount(smoney.coinBind);
			setGoldAmount(smoney.gold);
			setGoldBindAmount(smoney.goldBind);
		}
		
		public function setCoinAmount(value:int):void
		{
			if(this.parent == null)
			{
				return;
			}
			
			var txt:String = MoneyUtil.getCoinHtml(value);
			if(txt == _coinTextBox.htmlText)
			{
				return;
			}
			_coinTextBox.htmlText = MoneyUtil.getCoinHtml(value);
		}
		
		public function setCoinBindAmount(value:int):void
		{
			if(this.parent == null)
			{
				return;
			}
			
			var txt:String = MoneyUtil.getCoinHtml(value);
			if(txt == _coinBindTextBox.htmlText)
			{
				return;
			}
			_coinBindTextBox.htmlText = MoneyUtil.getCoinHtml(value);
		}
		
		public function setGoldAmount(value:int):void
		{
			if(this.parent == null)
			{
				return;
			}
			
			var txt:String = MoneyUtil.getCoinHtml(value);
			if(txt == _goldTextBox.htmlText)
			{
				return;
			}
			_goldTextBox.htmlText = MoneyUtil.getGoldHtml(value);
		}
		
		public function setGoldBindAmount(value:int):void
		{
			if(this.parent == null)
			{
				return;
			}
			
			var txt:String = MoneyUtil.getCoinHtml(value);
			if(txt == _goldBindTextBox.htmlText)
			{
				return;
			}
			_goldBindTextBox.htmlText = MoneyUtil.getGoldHtml(value);
		}
	}
}