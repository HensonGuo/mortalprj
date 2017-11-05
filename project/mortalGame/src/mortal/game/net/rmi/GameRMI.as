package mortal.game.net.rmi
{
	/**
	 * 游戏通信接口 
	 */	
	import Engine.RMI.RMIDispatcher;
	import Engine.RMI.RMIEvent;
	
	import Message.Game.IBagPrxHelper;
	import Message.Game.IBusinessPrxHelper;
	import Message.Game.ICopyPrxHelper;
	import Message.Game.IEquipPrxHelper;
	import Message.Game.IFightPrxHelper;
	import Message.Game.IFriendPrxHelper;
	import Message.Game.IGroupPrxHelper;
	import Message.Game.IGuildPrxHelper;
	import Message.Game.IInterPrxHelper;
	import Message.Game.ILoginGamePrxHelper;
	import Message.Game.IMailPrxHelper;
	import Message.Game.IMapPrxHelper;
	import Message.Game.IMarketPrxHelper;
	import Message.Game.IMountPrxHelper;
	import Message.Game.IPanicBuyPrxHelper;
	import Message.Game.IPetPrxHelper;
	import Message.Game.IPlayerPrxHelper;
	import Message.Game.IRolePrxHelper;
	import Message.Game.IShopPrxHelper;
	import Message.Game.ITaskPrxHelper;
	import Message.Game.ITestPrxHelper;
	
	import flash.system.System;
	
	import mortal.common.net.RMIBase;
	import mortal.common.net.RMISession;
	import mortal.game.manager.MsgManager;
	import mortal.game.net.MessageHandler;
	import mortal.game.net.RMISessionEvent;

	public class GameRMI extends RMIBase
	{
		private static var _instance:GameRMI;
		
		public function GameRMI()
		{
			if( _instance != null )
			{
				throw new Error(" GameRMI 单例 ");
			}
			new Regist();
			RMIDispatcher.getInstance().addEventListener( RMIEvent.RMI_ERROR , onRmiErrorHandler );
		}
		
		public static function get instance():GameRMI
		{
			if( _instance == null )
			{
				trace("准备初始化GameRMI","系统总内存:",System.totalMemory);
				_instance = new GameRMI();
				trace("初始化GameRMI","系统总内存:",System.totalMemory);
			}
			return _instance;
		}
		
		/**
		 * 服务器统一异常处理 
		 * @param event
		 * 
		 */		
		private function onRmiErrorHandler( event:RMIEvent ):void
		{
			MsgManager.systemError(event.error);
		}
		
		override public function set rmiSession(value:RMISession):void
		{
			value.session.messageHandler = new MessageHandler();
			value.session.communicator.sessionEvent = new RMISessionEvent();
			super.rmiSession = value;
		}
		
		/** 
		 * 登陆游戏 
		 */		
		public var loginGameProxy:ILoginGamePrxHelper = new ILoginGamePrxHelper();
		
		//背包
		public var iBagPrx:IBagPrxHelper = new IBagPrxHelper();
		
		public var iMapPrx:IMapPrxHelper = new IMapPrxHelper();
		
		public var iFightPrx:IFightPrxHelper = new IFightPrxHelper();
		
		public var iRolePrx:IRolePrxHelper = new IRolePrxHelper();
		
		public var iShopPrx:IShopPrxHelper = new IShopPrxHelper();
		
		public var iPanicBuyPrx:IPanicBuyPrxHelper = new IPanicBuyPrxHelper();
		
		public var iPetPrx:IPetPrxHelper = new IPetPrxHelper();
		
		public var iInterPrx:IInterPrxHelper = new IInterPrxHelper();
		//组队
		public var iGroupPrx:IGroupPrxHelper = new IGroupPrxHelper();
		// 好友
		public var iFriendPrx:IFriendPrxHelper = new IFriendPrxHelper();
		//邮件
		public var iMailPrx:IMailPrxHelper = new IMailPrxHelper();
		//市场
		public var iMartketPrx:IMarketPrxHelper = new IMarketPrxHelper();
		//交易
		public var iTrade:IBusinessPrxHelper  = new IBusinessPrxHelper();
		
		public var iPlayerPrx:IPlayerPrxHelper = new IPlayerPrxHelper();
		
		// 任务
		public var iTask:ITaskPrxHelper = new ITaskPrxHelper();
		
		// 副本
		public var iCopy:ICopyPrxHelper = new ICopyPrxHelper();
		
		// 装备
		public var iEquip:IEquipPrxHelper = new IEquipPrxHelper();
		
		public var iMount:IMountPrxHelper = new IMountPrxHelper();
		
		public var iGuild:IGuildPrxHelper = new IGuildPrxHelper();
		
//		CONFIG::Debug
//		{
			public var iTestPrx:ITestPrxHelper = new ITestPrxHelper();
//		}
		
		/**
		 * 注册代理  每个一个代理必须加一个初始化属性类 
		 * 
		 */
		override protected function initProxy():void
		{
			session.registerProxy( loginGameProxy );
			session.registerProxy( iMapPrx );
			session.registerProxy( iFightPrx );
			session.registerProxy( iBagPrx );
			session.registerProxy( iRolePrx );
			session.registerProxy( iShopPrx );
			session.registerProxy( iPanicBuyPrx );
			session.registerProxy( iPetPrx );
			session.registerProxy( iGroupPrx );
			session.registerProxy( iFriendPrx );
			session.registerProxy( iPlayerPrx );
			session.registerProxy( iTask );
			session.registerProxy( iCopy );
			session.registerProxy( iInterPrx );
			session.registerProxy( iEquip );
			session.registerProxy( iMailPrx );
			session.registerProxy( iMartketPrx );
			session.registerProxy( iTrade );
			session.registerProxy( iMount );
			session.registerProxy( iGuild );
//			CONFIG::Debug
//			{
				session.registerProxy( iTestPrx );
//			}
		}
	}
}