package mortal.game.view.shop
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.CursorManager;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.ShopProxy;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.npc.data.NpcFunctionData;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class ShopController extends Controller
	{
		private var _shopModule:ShopModule;
		
		private var _shopProxy:ShopProxy;
		
		public function ShopController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_shopProxy = GameProxy.shop;
		}
		
		override protected function initView():IView
		{
			if (_shopModule == null)
			{
				_shopModule=new ShopModule();
				_shopModule.addEventListener(WindowEvent.SHOW, onShopShow);
				_shopModule.addEventListener(WindowEvent.CLOSE, onShopClose);
			}
			return _shopModule;
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.NPC_OpenNpcShop, openShop);
		}
		
		private function onShopShow(e:Event):void
		{
			updateBuyBackList();
			
			CursorManager.currentCurSorType = CursorManager.BUY;
			CursorManager.showCursor(CursorManager.BUY);
			
			_shopModule.addEventListener(MouseEvent.ROLL_OVER, mouse_over);
			_shopModule.addEventListener(MouseEvent.ROLL_OUT, mouse_out);
			
			NetDispatcher.addCmdListener(ServerCommand.updateBuyBackList,updateBuyBackList);
			
			Dispatcher.addEventListener(EventName.BuyBack, buyBack);
			
		}
		
		private function onShopClose(e:Event):void
		{
			removeSmallWin();
			
			_shopModule.removeEventListener(MouseEvent.MOUSE_OVER, mouse_over);
			_shopModule.removeEventListener(MouseEvent.MOUSE_OUT, mouse_out);
			CursorManager.currentCurSorType = CursorManager.NO_CURSOR;
			
			Dispatcher.removeEventListener(EventName.BuyBack, buyBack);
		}
		
		/**
		 * 打开商店 
		 * @param data
		 * 
		 */		
		private function openShop(data:DataEvent):void
		{
			var npcFunctionData:NpcFunctionData = data.data as NpcFunctionData;
			GameManager.instance.popupWindow(ModuleType.Shops);
			_shopModule.updateTabBar(npcFunctionData);
		}
		
		/**
		 *打开商店之后鼠标滑进背包
		 * @param e
		 *
		 */
		private function mouse_over(e:MouseEvent):void
		{
			var aa:String = CursorManager.currentCurSorType;
			switch (CursorManager.currentCurSorType)
			{
				case CursorManager.SELL:
					CursorManager.showCursor(CursorManager.NO_CURSOR);
					break;
				case CursorManager.FIX:
					CursorManager.showCursor(CursorManager.FIX);
					break;
				case CursorManager.BUY:
					CursorManager.showCursor(CursorManager.BUY);
					break;
				case CursorManager.NO_CURSOR:
					CursorManager.showCursor(CursorManager.NO_CURSOR);
					break;
			}
		}
		
		/**
		 * 打开商店之后鼠标滑出背包
		 * @param e
		 *
		 */
		private function mouse_out(e:MouseEvent):void
		{
			CursorManager.showCursor(CursorManager.NO_CURSOR);
		}
		
		/**
		 * 关闭确认框 
		 * 
		 */		
		private function removeSmallWin():void
		{
			if(BuyItemWin.instance && !BuyItemWin.instance.isHide)
			{
				BuyItemWin.instance.hide();
			}
		}
		
		/**
		 * 更新回购列表 
		 * @param data
		 * 
		 */		
		private function updateBuyBackList(data:Object = null):void
		{
			_shopModule.updateBuyBackList();
		}
		
		private function buyBack(data:DataEvent):void
		{
			var arr:Array = new Array();
			arr.push(data.data);
			_shopProxy.buyBack(arr);
		}
		
	}
}