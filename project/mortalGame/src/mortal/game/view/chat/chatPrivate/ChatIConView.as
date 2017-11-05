/**
 * @heartspeak
 * 2014-3-19 
 */   	

package mortal.game.view.chat.chatPrivate
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.UILayer;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.ListMenu;
	import mortal.game.view.common.menu.PlayerMenuCellRenderer;
	import mortal.mvc.core.View;
	import mortal.mvc.interfaces.ILayer;

	public class ChatIConView extends View
	{
		private var _chatBtn:GLoadingButton;
		
		private var _textNumBg:GBitmap;
		
		private var _textNum:GTextFiled;
		
		private var _chatMenu:ListMenu;
		
		private var _dataProvider:DataProvider;
		
		public function ChatIConView()
		{
			super();
			this.layer = LayerManager.uiLayer;
		}
		
		private static var _instance:ChatIConView;
		
		public static function get instance():ChatIConView
		{
			if(!_instance)
			{
				_instance = new ChatIConView();
			}
			return _instance;
		}
		
		/**
		 * 创建显示 
		 * 
		 */
		override protected function configUI():void
		{
			super.configUI();
			_chatBtn = UIFactory.gLoadingButton(ResFileConst.ChatTipBtn,0,0,50,50,this);
			_chatBtn.addEventListener(MouseEvent.CLICK,showChatMenuHandler);
			_chatBtn.addEventListener(MouseEvent.MOUSE_OVER,onChatBtnOver);
			_chatBtn.addEventListener(MouseEvent.MOUSE_OUT,onChatBtnOut);
			
			_textNumBg = UIFactory.gBitmap(ImagesConst.NumberBg,27,-5,this);
			_textNum = UIFactory.gTextField("5",27,-4,24,20,this,GlobalStyle.textFormatPutong.center());
			_textNum.mouseEnabled = false;
			
			_chatMenu = new ListMenu(ResourceConst.getScaleBitmap("ChatMenuBg"));
			_chatMenu.width = 150;
			_chatMenu.setStyle("contentPadding",0);
			_chatMenu.setStyle("cellRenderer",ChatMenuCellRenderer);
			_chatMenu.list.rowHeight = 22;
			_chatMenu.list.drawNow();
			_chatMenu.list.addEventListener(ListEvent.ITEM_CLICK,chatMenuSelect,false,9999);
		}
		
		private var _t:int;
		
		/**
		 * chatBtnOver 
		 * @param e
		 * 
		 */		
		private function onChatBtnOver(e:MouseEvent):void
		{
			delayShowMenu(e);
		}
		
		/**
		 * 延迟显示Menu 
		 * 
		 */		
		private function delayShowMenu(e:MouseEvent):void
		{
			_t = setTimeout(showChatMenuHandler,500,e);
		}
		
		/**
		 * chatbtnOut 
		 * @param e
		 * 
		 */		
		private function onChatBtnOut(e:MouseEvent):void
		{
			clearTimeout(_t);
		}
		
		/**
		 * 显示私聊菜单 
		 * @param e
		 * 
		 */		
		private function showChatMenuHandler(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				//只有一条消息直接显示窗口
				if(_aryChatWindowMsg.length == 1)
				{
					var windowMsg:ChatWindowMsg = _aryChatWindowMsg[0];
					ChatManager.getWindowByWindowUId(windowMsg.windowUid).show();
					return;
				}
			}
			updateMenu();
			var layer:UILayer = LayerManager.topLayer;
			layer.addChild(_chatMenu);
			var x:Number = e.stageX;
			var y:Number = e.stageY;
			x = x < layer.stage.stageWidth - _chatMenu.width?x:x - _chatMenu.width;
			y = y < _chatMenu.height?0:y - _chatMenu.height;
			_chatMenu.show(x,y,layer);
			e.stopImmediatePropagation();
		}
		
		private function updateMenu():void
		{
			var dataProvider:DataProvider = new DataProvider();
			for (var i:int = 0;i < _aryChatWindowMsg.length;i++)
			{
				dataProvider.addItem(_aryChatWindowMsg[i]);
			}
			_chatMenu.dataProvider = dataProvider;
			_chatMenu.list.drawNow();
		}
		
		/**
		 * 显示聊天菜单 
		 * @param e
		 * 
		 */
		private function chatMenuSelect(e:ListEvent):void
		{
			var windowMsg:ChatWindowMsg = _chatMenu.list.dataProvider.getItemAt(e.index) as ChatWindowMsg;
			ChatManager.getWindowByWindowUId(windowMsg.windowUid).show();
		}
		
		private var _aryChatWindowMsg:Vector.<ChatWindowMsg> = new Vector.<ChatWindowMsg>();
		
		/**
		 * 更新当前聊天信息  未读信息条数  以及数据
		 * @param num
		 * 
		 */
		public function updateData(aryChatWindowMsg:Vector.<ChatWindowMsg>):void
		{
			if(aryChatWindowMsg.length)
			{
				this.show();
			}
			else
			{
				this.hide();
			}
			_aryChatWindowMsg = aryChatWindowMsg;
			var totalNum:int = 0;
			for(var i:int = 0;i < aryChatWindowMsg.length;i++)
			{
				totalNum += aryChatWindowMsg[i].unReadMsgNum;
			}
			_textNum.htmlText = totalNum.toString();
			_textNumBg.visible = totalNum > 0;
			_textNum.visible = totalNum > 0;
			if(_chatMenu.parent)
			{
				updateMenu();
			}
		}
		
		override public function stageResize():void
		{
			this.x = 700;
			this.y = SceneRange.display.height - 140;
		}
	}
}