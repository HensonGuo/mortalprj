package mortal.game.view.mount
{
	import Message.Public.EMountState;
	import Message.Public.SPublicMount;
	
	import extend.language.Language;
	
	import flash.events.Event;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.MountProxy;
	import mortal.game.utils.MountUtil;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.mount.data.CultureData;
	import mortal.game.view.mount.data.MountData;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class MountController extends Controller
	{
		private var _mountModule:MountModule;
		
		private var _mountProxy:MountProxy;
		
		private var _mountCache:MountCache;
		
		public function MountController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_mountProxy = GameProxy.mount;
			_mountCache = Cache.instance.mount;
			
		}
		
		override protected function initView():IView
		{
			if (_mountModule == null)
			{
				_mountModule=new MountModule();
				_mountModule.addEventListener(WindowEvent.SHOW, onWinShow);
				_mountModule.addEventListener(WindowEvent.CLOSE, onWinClose);
			}
			return _mountModule;
		}
		
		override protected function initServer():void
		{
			NetDispatcher.addCmdListener(ServerCommand.MountSetEquipBtn , setBtn);
			
			Dispatcher.addEventListener(EventName.SetMountState,setMountState); //坐骑改变状态
			Dispatcher.addEventListener(EventName.ChangeRideMount,changeRideMount);  //选择坐骑列表后刷新数据
			Dispatcher.addEventListener(EventName.RideMount,rideMount); //骑乘
			Dispatcher.addEventListener(EventName.MountLoadComplete,showSkin);
			Dispatcher.addEventListener(EventName.MountSelseced,setMountInfo);  //选择坐骑列表后刷新数据
			Dispatcher.addEventListener(EventName.MountOpenCulturWin,openCulturTabWin);  //打开培养面板
			Dispatcher.addEventListener(EventName.MountClearNewMount,clearNewMount);
		}
		
		private function onWinShow(e:Event):void
		{
			NetDispatcher.addCmdListener(ServerCommand.MountUpdateList , updateMountList);
			NetDispatcher.addCmdListener(ServerCommand.MountExpUpdate,expUpdate);
			NetDispatcher.addCmdListener(ServerCommand.MountLevelUpdate , levelUpdate);
			NetDispatcher.addCmdListener(ServerCommand.MountUpdateExpNum , updateExpNum);
			NetDispatcher.addCmdListener(ServerCommand.Mount_777Runing ,startRuning);
		
			Dispatcher.addEventListener(EventName.CultureMount,cultureMount);  //培养
			Dispatcher.addEventListener(EventName.CultureLinageMount,cultureLinageMount);  //血统提升
			Dispatcher.addEventListener(EventName.Mount777End,mountUpdateList);//777转盘结束后
			Dispatcher.addEventListener(EventName.MountChangeSelceted,changeSelceted);  //切换坐骑选择

			
		}
		
		private function onWinClose(e:Event):void
		{
			NetDispatcher.removeCmdListener(ServerCommand.MountUpdateList , updateMountList);
			NetDispatcher.removeCmdListener(ServerCommand.MountExpUpdate,expUpdate);
			NetDispatcher.removeCmdListener(ServerCommand.MountLevelUpdate , levelUpdate);
			NetDispatcher.removeCmdListener(ServerCommand.MountUpdateExpNum , updateExpNum);
			
			Dispatcher.removeEventListener(EventName.CultureMount,cultureMount); 
			Dispatcher.removeEventListener(EventName.CultureLinageMount,cultureLinageMount);
			Dispatcher.removeEventListener(EventName.Mount777End,mountUpdateList);//777转盘结束后
			Dispatcher.removeEventListener(EventName.MountChangeSelceted,changeSelceted);  //切换坐骑选择

		}
		
		/**
		 * 更新坐骑列表 
		 * 
		 */		
		private function updateMountList(data:Object):void
		{
			_mountModule.setListInfo();  //更新底部列表
			_mountModule.setInfo();
			setAllMountsAtrribuite();
			setBtn();
			
//			if(_mountCache.currentMount == null && _mountCache.isHasMount)  //如果是第一只坐骑,默认骑上
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.ChangeRideMount,_mountCache.mountList[0].sPublicMount.uid));
//			}
		}
		
		/**
		 * 设置坐骑状态 
		 * @param e
		 * 
		 */		
		private function setMountState(e:DataEvent):void
		{
			_mountProxy.setMountState(e.data.uid,e.data.state);
		}
		
		/**
		 * 设置显示坐骑属性 
		 * @param e
		 * 
		 */		
		private function setMountInfo(e:DataEvent):void
		{
			_mountModule.setMountInfo(e.data as MountData);
		}
		
		/**
		 * 显示基础属性 
		 * 
		 */		
		private function setAllMountsAtrribuite():void
		{
			_mountModule.setAllMountsAtrribuite();
		}
		
		/**
		 * 设置装备和幻化按钮
		 * 
		 */		
		private function setBtn(data:Object = null):void
		{
			if(GameController.mount.isViewShow)
			{
				_mountModule.setEquipBtn();
				_mountModule.setSelectMountBtn();
			}
		}
		
		/**
		 * 骑乘 
		 * @param e
		 * 
		 */		
		private function rideMount(e:DataEvent = null):void
		{
			var obj:Object;
			if(!_mountCache.isHasMount)
			{
				MsgManager.showRollTipsMsg(Language.getString(30315));
				return;
			}
			else if(_mountCache.state == EMountState._EMountStateUndress)  //没装备不能骑乘
			{
				MsgManager.showRollTipsMsg(Language.getString(30310));
				return ;
			}
			else if(_mountCache.currentMount == null)  //没有选择马
			{
				MsgManager.showRollTipsMsg(Language.getString(30304));
				return;
			}
			
//			if(Cache.instance.role.roleEntityInfo.is
			
			if(_mountCache.isRide)
			{
				_mountProxy.setMountState("",EMountState._EMountStateRide);
				_mountCache.state = EMountState._EMountStateDress;
				MsgManager.showRollTipsMsg("结束骑乘");
			}
			else
			{
				if(MountUtil.isOverTime(_mountCache.currentMount))
				{
					MsgManager.showRollTipsMsg("坐骑已过期");
					return;
				}
				_mountProxy.setMountState(_mountCache.currentMount.sPublicMount.uid,EMountState._EMountStateRide);
//				_mountCache.state = EMountState._EMountStateRide;
				MsgManager.showRollTipsMsg("骑乘");
			}
		}
		
		/**
		 * 选择需要骑乘的坐骑 
		 * @param e
		 * 
		 */		
		private function changeRideMount(e:DataEvent):void
		{
			if(_mountCache.isRide)
			{
				if(MountUtil.isOverTime(_mountCache.currentMount))
				{
					MsgManager.showRollTipsMsg("坐骑已过期");
					return;
				}

				_mountProxy.setMountState(String(e.data),EMountState._EMountStateRide);
				MsgManager.showRollTipsMsg("更换坐骑");
			}
			else
			{
				_mountProxy.setMountState(String(e.data),EMountState._EMountStateChange);
				MsgManager.showRollTipsMsg("幻化坐骑");
			}
		}
		
		/**
		 * 打开时自动进入选中的页面 
		 * 
		 */		
		private function setCurrentPage():void
		{
			_mountModule.setCurrentPage();
		}
		
		/**
		 *加载完成后设置皮肤 
		 * @param e
		 * 
		 */		
		private function showSkin(e:DataEvent):void
		{
			_mountCache.sortList();
			_mountModule.showSkin();
			setCurrentPage();
			_mountModule.setListInfo();
			_mountModule.setEquipBtn();
		
		}
		
		/**
		 * 培养坐骑 
		 * @param e
		 * 
		 */		
		private function cultureMount(e:DataEvent):void
		{
			_mountProxy.upgrade(e.data as CultureData);
		}
		
		/**
		 * 更新经验 
		 * @param data
		 * 
		 */		
		private function expUpdate(data:Object):void
		{
			_mountModule.expUpdate();
		}
		
		/**
		 * 等级更新后,刷新数据 
		 * @param data
		 * 
		 */		
		private function levelUpdate(data:Object):void
		{
			_mountModule.refreshList();
			_mountModule.expUpdate();
			_mountModule.levelUpdate();
		}
		
		/**
		 * 更新提升数量 
		 * @param data
		 * 
		 */		
		private function updateExpNum(data:Object):void
		{
			_mountModule.refreshList();
		}
		
		/**
		 * 打开培养面板 
		 * 
		 */		
		private function openCulturTabWin(e:DataEvent):void
		{
			if(!GameController.mount.isViewShow)
			{
				GameManager.instance.popupWindow(ModuleType.Mounts);
			}
			_mountModule.openCultureTabWin()
		}
		
		/**
		 * 提升血统 
		 * @param e
		 * 
		 */		
		private function cultureLinageMount(e:DataEvent):void
		{
			_mountProxy.upgradeTool(e.data as CultureData);
		}
		
		/**
		 * 777开始转动 
		 * @param data
		 * 
		 */		
		private function startRuning(data:Object):void
		{
			_mountModule.startRuning(data);
		}
		
		/**
		 * 清除最新增加的坐骑 
		 * @param e
		 * 
		 */		
		private function clearNewMount(e:DataEvent):void
		{
			_mountCache.newMountData = null;
		}
		
		/**
		 * 刷新坐骑列表(不会自动选中) 
		 * @param e
		 * 
		 */		
		private function mountUpdateList(e:DataEvent):void
		{
			_mountModule.refreshList();
		}
		
		private function changeSelceted(e:DataEvent):void
		{
			_mountModule.setSelectIndex(e.data as int);
		}
	}
}