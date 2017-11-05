/**
 * @heartspeak
 * 2014-3-18 
 */   	

package mortal.game.view.chat.chatTrumpet
{
	import Message.DB.Tables.TShopSell;
	
	import com.gengine.keyBoard.KeyCode;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GNumericStepper;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.SmallWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.ShopConfig;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.chat.ChatArea;
	import mortal.game.view.chat.selectPanel.ColorSelector;
	import mortal.game.view.chat.selectPanel.FacePanel;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.item.MoneyItem;
	import mortal.game.view.shopMall.data.ShopItemData;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	public class ChatTrumpetSendWindow extends SmallWindow
	{
		private const itemCode:int = 180040000;
		
		protected var _tiSend:GTextInput;
		
		protected var _cbClose:GCheckBox;
		
		protected var _btnFace:GLoadingButton;
		
		protected var _btnColor:GLoadingButton;
		
		protected var _btnSend:GButton;
		
		protected var _numericStepper:GNumericStepper;//调节数量组件
		
//		protected var _maxNumBtn:GLoadedButton;
		
		protected var _color:int;
		
		public function ChatTrumpetSendWindow($layer:ILayer=null)
		{
			super($layer);
			title = "提示";
			setSize(283,261);
		}
		
		private static var _instance:ChatTrumpetSendWindow;
		
		public static function get instance():ChatTrumpetSendWindow
		{
			if(!_instance)
			{
				_instance = new ChatTrumpetSendWindow();
			}
			return _instance;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			var itemData:ItemData = new ItemData(itemCode);
			
			pushUIToDisposeVec(UIFactory.bg(15,34,263,108,this,ImagesConst.WindowBgC));
			
			var nameText:GTextFiled;
			nameText = UIFactory.gTextField("",35,38,80,20,this);
			nameText.htmlText = ItemsUtil.getItemName(itemData);
			pushUIToDisposeVec(nameText);
			
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.VIP_3,102,43,this));
			pushUIToDisposeVec(UIFactory.gTextField("5次",127,38,40,20,this,GlobalStyle.textFormatAnjin));
				
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.VIP_2,157,43,this));
			pushUIToDisposeVec(UIFactory.gTextField("3次",182,38,40,20,this,GlobalStyle.textFormatAnjin));
				
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.VIP_1,212,43,this));
			pushUIToDisposeVec(UIFactory.gTextField("1次",237,38,40,20,this,GlobalStyle.textFormatAnjin));
			
			pushUIToDisposeVec(UIFactory.bg(29,59,237,2,this,"SplitLine"));
			
			pushUIToDisposeVec(UIFactory.gBitmap(ImagesConst.ShopItemBg,27,64,this));
			pushUIToDisposeVec(UIFactory.baseItem(28,63,60,60,this,itemData));
			
			pushUIToDisposeVec(UIFactory.gTextField("今日免费:",107,68,65,20,this));
			pushUIToDisposeVec(UIFactory.gTextField("5次",175,68,65,20,this,GlobalStyle.textFormatAnjin));
			
			pushUIToDisposeVec(UIFactory.gTextField("单    价:",107,90,65,20,this));
			pushUIToDisposeVec(UIFactory.gTextField("",175,90,65,20,this,GlobalStyle.textFormatAnjin));
			
			var moneyItem:MoneyItem = UICompomentPool.getUICompoment(MoneyItem);
			var shopSell:TShopSell = ShopConfig.instance.getShopSellInfoById(itemCode);
			moneyItem.update(shopSell.offer,2);
			UIFactory.setObjAttri(moneyItem,200,88,-1,-1,this);
			pushUIToDisposeVec(moneyItem);
			
			_numericStepper = UIFactory.gNumericStepper(106,113,50,20,this,99,1,"NumericStepper",GlobalStyle.textFormatBai);
			_numericStepper.value = 1;
			
//			_maxNumBtn = UIFactory.gLoadedButton(ImagesConst.numMax_upSkin,156,113,20,20,this);
//			_maxNumBtn.drawNow();
//			_maxNumBtn.configEventListener(MouseEvent.CLICK,clickHandler);
			
			var buyBtn:GLoadingButton = UIFactory.gLoadingButton(ResFileConst.ShopBuy,180,112,49,23,this);
			buyBtn.configEventListener(MouseEvent.CLICK,onClickBuyBtn);
			pushUIToDisposeVec(buyBtn);
			
			_tiSend = UIFactory.gTextInput(16,144,261,72,this);
			_tiSend.maxChars = 50;
			_tiSend.configEventListener(KeyboardEvent.KEY_DOWN,onKeySend);
			pushUIToDisposeVec(_tiSend);
			
			_cbClose = UIFactory.checkBox("发送后自动关闭",16,228,120,28,this);
			pushUIToDisposeVec(_cbClose);
			
			_btnFace = UIFactory.gLoadingButton(ResFileConst.ChatTrumpetFaceBtn,146,229,24,24,this);
			FacePanel.registBtn(_btnFace,selectFace);
			pushUIToDisposeVec(_btnFace);
			
			_btnColor = UIFactory.gLoadingButton(ResFileConst.ChatTrumpetColorBtn,170,229,24,24,this);
			ColorSelector.registBtn(_btnColor,selectColor);
			pushUIToDisposeVec(_btnColor);
			
			_btnSend = UIFactory.gButton("发送",198,230,60,22,this);
			_btnSend.configEventListener(MouseEvent.CLICK,onClickBtnSend);
			pushUIToDisposeVec(_btnSend);
		}
		
		
		private function clickHandler(e:MouseEvent):void
		{
			_numericStepper.value = 99;
		}
		
		/**
		 * 点击发送按钮 
		 * @param e
		 * 
		 */
		protected function onClickBtnSend(e:MouseEvent):void
		{
			send();
		}
		
		protected function onKeySend(e:KeyboardEvent):void
		{
			if(e.keyCode == KeyCode.ENTER)
			{
				send();
			}
		}
		
		protected function send():void
		{
			var msg:String = _tiSend.text;
			if(!msg)
			{
				MsgManager.showRollTipsMsg("大喇叭消息内容不能为空");
			}
			else
			{
				if(Cache.instance.pack.backPackCache.getItemCountByCode(new ItemData(itemCode)) <= 0)
				{
					MsgManager.showRollTipsMsg("大喇叭不足");
				}
				else
				{
					var obj:Object = new Object();
					obj.area = ChatArea.Speaker;
					obj.content = msg;
					Dispatcher.dispatchEvent( new DataEvent(EventName.ChatSend,obj));
					
					if(_cbClose.selected)
					{
						this.hide();
					}
				}
			}
		}
		
		/**
		 * 选择表情 
		 * @param str
		 * 
		 */		
		protected function selectFace(face:*):void
		{
			_tiSend.appendText("/" + face.toString() + " ");
			_tiSend.setFocus();
			_tiSend.setSelection(_tiSend.text.length,_tiSend.text.length);
		}
		
		/**
		 * 选择颜色
		 * @param str
		 * 
		 */		
		protected function selectColor(color:int):void
		{
			_color = color;
			setInputTextFormat();
		}
		
		private function setInputTextFormat():void
		{
			var tf:TextFormat = new GTextFormat(FontUtil.defaultName,12,_color);
			tf.leading = 3;
			_tiSend.setStyle("textFormat",tf);
			_tiSend.setStyle("textPadding",5);
		}
		
		/**
		 * 点击购买按钮 
		 * @param e
		 * 
		 */
		protected function onClickBuyBtn(e:MouseEvent):void
		{
			var shopItemData:ShopItemData = new ShopItemData(itemCode);
			shopItemData.num = int(_numericStepper.value);
			Dispatcher.dispatchEvent( new DataEvent(EventName.BuyItem,shopItemData));
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
		}
	}
}