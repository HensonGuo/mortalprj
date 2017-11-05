package mortal.game.view.friend
{
	import Message.Game.EFriendType;
	import Message.Game.SPlayer;
	import Message.Game.SRole;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import fl.controls.TileList;
	
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.cache.RoleCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.AvatarUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;

	/**
	 * 好友界面
	 * @author dengwj
	 * 
	 */	
	public class FriendModule extends BaseWindow
	{
		
		// 数据
		/** 好友分组数据 */
		private var _friendTabData:Array;
		
		// 显示
		/**中间背景*/
		private var _middlePaneBg:ScaleBitmap;
		/** 角色头像 */
		private var _roleHead:GBitmap;
		/** 角色等级 */
		private var _roleLevel:GTextFiled;
		/** 角色阵营 */
		private var _roleCamp:GTextFiled;		
		/** 角色职业 */
		private var _roleCareer:GTextFiled;
		/** 角色名字 */
		private var _roleName:GTextFiled;
		/** VIP图标 */
		private var _vipImg:GBitmap;
		/** 个性签名 */
		private var _roleSign:GTextInput;
		/** 分组导航 */
		private var _tabBar:GTabBar;
		/** 分组信息提示部分 */
		private var _groupInfoSpr:FriendGroupInfoSpr;
		/** 分组信息提示部分2 */
		private var _groupInfoSpr2:FriendGroupInfoSpr;
		/** 角色显示列表部分 */
		private var _roleListSpr:RoleListSpr;
		/** 查询按钮 */
		private var _findBtn:GButton;
		/** 删除按钮 */
		private var _deleteBtn:GButton;
		/** 查询设置面板 */
		private var _friendSetPanel:FriendSetPanel;
		/** 批量删除面板 */
		private var _friendDeletePanel:FriendDeletePanel
		/** 当前选中页签 */
		private var _currSelGroup:int;
		/** 玩家自己的签名 */
		private var _selfSign:String;
		
		public function FriendModule()
		{
			_friendTabData = Language.getArray(40003);
			super();
			init();
			this.layer = LayerManager.windowLayer;
		}
		
		private function init():void
		{
			setSize(315,507);
//			title = Language.getString(40001);
//			titleIcon = ImagesConst.PackIcon;
			title = "好友";
			_titleSprite.x = 20;
			this.isHideDispose = false;
			this._friendSetPanel = new FriendSetPanel();
			this._friendDeletePanel = new FriendDeletePanel();
		}
		
		override protected function updateWindowCenterSize():void
		{
			if( _windowCenter )
			{
				_windowCenter.setSize(309, 416);
				_windowCenter.x = 10;
				_windowCenter.y = 85;
			}
			this._closeBtn.x += 6;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_middlePaneBg = UIFactory.bg(16,143-29,298,343,this);
			
			_roleHead = UIFactory.gBitmap("",7,-44,this);
			_roleLevel = UIFactory.gTextField("",16,40,47,17,this);
			_roleCamp = UIFactory.gTextField("",62,40,34,20,this);
			_roleCareer = UIFactory.gTextField("",204,40,43,18,this);
			_roleName = UIFactory.gTextField("",128,40,97,18,this);
			_vipImg = UIFactory.bitmap("AvatarVIP_upSkin",251,40,this);
			_vipImg.visible = false;
			_roleSign = UIFactory.gTextInput(11,62,307,23,this,"GTextInput2");
			_roleSign.textField.textColor = GlobalStyle.colorPutongUint;
			_roleSign.maxChars = 20;
			_roleSign.configEventListener(FocusEvent.FOCUS_IN,editSign);
			_roleSign.configEventListener(FocusEvent.FOCUS_OUT,updateSign);
			
			_roleLevel.text = "Lv." + Cache.instance.role.roleInfo.level;
			_roleName.text = Cache.instance.role.playerInfo.name;
			_roleSign.text = Language.getString(40004);
			
			//好友分组页签
			_tabBar = UIFactory.gTabBar(16,91,_friendTabData,61,23,this,tabBarChangeHandler,"PageBtn");
			
			// 分组信息部分
			_groupInfoSpr = UICompomentPool.getUICompoment(FriendGroupInfoSpr);
			_groupInfoSpr.createDisposedChildren();
			_groupInfoSpr.x = 19;
			_groupInfoSpr.y = 127-12;
			_groupInfoSpr.flag = EFriendType._EFriendTypeNormal;// 好友
			_groupInfoSpr.updateListType(this._currSelGroup);
			this.addChild(_groupInfoSpr);
			
			_groupInfoSpr2 = UICompomentPool.getUICompoment(FriendGroupInfoSpr);
			_groupInfoSpr2.createDisposedChildren();
			_groupInfoSpr2.x = 19;
			_groupInfoSpr2.y = 135;
			_groupInfoSpr2.flag = EFriendType._EFriendtypeIntimate;// 密友
			_groupInfoSpr2.updateListType(this._currSelGroup);
			this.addChild(_groupInfoSpr2);
			
			_groupInfoSpr.configEventListener(MouseEvent.CLICK, onSwitchHandler);
			_groupInfoSpr2.configEventListener(MouseEvent.CLICK, onSwitchHandler);
			
			// 角色显示列表部分
			_roleListSpr = UICompomentPool.getUICompoment(RoleListSpr);
			_roleListSpr.createDisposedChildren();
			_roleListSpr.x = 12;
			_roleListSpr.y = 127-12;
			this.addChild(_roleListSpr);
			
			_findBtn = UIFactory.gButton("查询添加",86,466,68,23,this);
			_deleteBtn = UIFactory.gButton("批量删除",164,466,68,23,this);
			
			_findBtn.configEventListener(MouseEvent.CLICK, onClickHandler);
			_deleteBtn.configEventListener(MouseEvent.CLICK, onClickHandler);
			
		}
		
		/**
		 * 更新界面上自身的信息 
		 */
		public function updateSelfInfo(data:Object):void
		{
			if(data)
			{
				var roleInfo:SRole = (data as RoleCache).roleInfo;
				var playerInfo:SPlayer = (data as RoleCache).playerInfo;
				this._roleLevel.text = "Lv." + roleInfo.level;
				this._roleLevel.textColor = 0xffffff;
				var campName:String = GameDefConfig.instance.getECamp(playerInfo.camp).text;
				this._roleCamp.htmlText = GameDefConfig.instance.getCampHtml(playerInfo.camp);
				this._roleName.text = playerInfo.name;
				this._roleName.textColor = 0xffffff;
				var careerName:String = GameDefConfig.instance.getECareer(roleInfo.career).text;
				this._roleCareer.text = careerName;
				this._roleCareer.textColor = 0xf2de47;
				var headPath:String = AvatarUtil.getPlayerAvatar(roleInfo.career,playerInfo.sex);
				this._roleHead.bitmapData = GlobalClass.getBitmapData(headPath);
				if(playerInfo.VIP != 0)
				{
					this._vipImg.visible = true;
				}
				else
				{
					this._vipImg.visible = false;
				}
//				if(playerInfo.VIP == 0){
//					this._vipImg.bitmapData = null;
//				}else{
//					var className:String = "VIP_" + playerInfo.VIP;
//					this._vipImg.bitmapData = GlobalClass.getBitmapData(className);
//				}
				
				this._roleSign.text = playerInfo.signature;
				if(playerInfo.signature == "")
				{
					this._roleSign.text = Language.getString(40004);
				}
				this._selfSign = playerInfo.signature;
			}
		}
		
		/**
		 * 切换分组页签处理
		 */
		private function tabBarChangeHandler(e:MuiEvent):void
		{
			this._currSelGroup = e.selectedIndex;
			_groupInfoSpr.updateListType(e.selectedIndex);// 更新列表类型
			_groupInfoSpr2.updateListType(e.selectedIndex);
			var roleList:TileList = this._roleListSpr.roleList;
			if(e.selectedIndex == 0)
			{
				this.addChild(_groupInfoSpr2);
				roleList.y = 25 + 21;
				roleList.height = 315 - 31;
			}
			else
			{
				DisplayUtil.removeMe(_groupInfoSpr2);
				this.closeList(0);
				roleList.y = 25;
				roleList.height = 315;
			}
			Dispatcher.dispatchEvent(new DataEvent(EventName.FriendListReq, e.selectedIndex));
		}
		
		/**
		 * 更新列表数据
		 * @param data 
		 */		
		public function updateList(data:Array):void
		{
			_roleListSpr.updateListRoles(data);
		}
		
		/**
		 * 更新当前列表数据 
		 * @param data
		 */		
		public function updateCurrList():void
		{
			var data:Array = [];
			switch(this._currSelGroup)
			{
				case 0 : 
					data = Cache.instance.friend.friendList;
					break;
				case 1 : 
					data = Cache.instance.friend.foeList;
					break;
				case 2 : 
					data = Cache.instance.friend.blackList;
					break;
				case 3 : 
					data = Cache.instance.friend.recentList;
					break;
			}
			_roleListSpr.updateListRoles(data);
		}
		
		/**
		 * 更新密友列表 
		 * @param e
		 */
		public function updateCloseList(data:Array = null):void
		{
			if(data != null)
			{
				_roleListSpr.updateCloseFriendList(data);
			}
			else
			{
				_roleListSpr.updateCloseFriendList(Cache.instance.friend.closeFriendList);
			}
		}
		
		/**
		 * 点击按钮处理 
		 * @param e
		 */		
		public function onClickHandler(e:MouseEvent):void
		{
			var roleList:GTileList = this._roleListSpr.roleList;
			var closeFriendList:GTileList = this._roleListSpr.closeFriendList;
			if(e.target == _findBtn)
			{
				this._friendSetPanel.show();
			}
			if(e.target == _deleteBtn)
			{
				this._friendDeletePanel.show();
				Dispatcher.dispatchEvent(new DataEvent(EventName.FriendDeleteListReq));// 请求列表数据
			}
		}
		
		/**
		 * 点击列表的展开/关闭按钮处理 
		 * @param type
		 * 
		 */		
		public function onSwitchHandler(e:MouseEvent):void
		{
			if(this._currSelGroup == 0)
			{// 好友/密友列表
				if(e.target == _groupInfoSpr.addSpr || e.target == _groupInfoSpr.plusSpr)
				{
					if(this._roleListSpr.closeFriendList.parent )
					{
						updatePosition(0);
						closeList(0);
					}
					else
					{
						openList(0);
						closeList(1);
						updatePosition(1);
					}
				}
				if(e.target == _groupInfoSpr2.addSpr || e.target == _groupInfoSpr2.plusSpr)
				{
					if(this._roleListSpr.roleList.parent )
					{
						closeList(1);
					}
					else
					{
						openList(1);
						updatePosition(0);
						closeList(0);
					}
				}
			}
			else
			{// 其他列表
				if(this._roleListSpr.roleList.parent)
				{
					closeList(2);
				}
				else
				{
					openList(2);
				}
			}
		}
		
		/**
		 * 更新好友列表标题栏的位置 
		 */		
		public function updatePosition(type:int):void
		{
			if(this.roleListSpr.closeFriendList.parent != null)
			{
				if(type == 0)
				{
					_groupInfoSpr2.y = 135;
				}
				else
				{
					var rowHeight:int = this._roleListSpr.closeFriendList.rowHeight;
					var length:int = this._roleListSpr.closeFriendList.length;
					var result:int = 135 + length * rowHeight;
					_groupInfoSpr2.y = result < 429 ? result : 429;
				}
			}
		}
		
		/**
		 * 打开角色列表 
		 */		
		public function openList(type:int):void
		{
			if(type == 0)// 打开密友列表
			{
				if(!this._roleListSpr.closeFriendList.parent)
				{
					this._roleListSpr.addChild(this._roleListSpr.closeFriendList);
					this._groupInfoSpr.switchBtnState(true);
				}
			}
			else if(type == 1)// 打开好友列表
			{
				if(!this._roleListSpr.roleList.parent)
				{
					this._roleListSpr.addChild(this._roleListSpr.roleList);
					this._groupInfoSpr2.switchBtnState(true);
				}
			}
			else if(type == 2)// 其他列表
			{
				if(!this._roleListSpr.roleList.parent)
				{
					this._roleListSpr.addChild(this._roleListSpr.roleList);
				}
				this._groupInfoSpr.switchBtnState(true);
			}
		}
		
		/**
		 * 关闭角色列表 
		 * @return 
		 */
		public function closeList(type:int):void
		{
			if(type == 0)// 关闭密友列表
			{
				DisplayUtil.removeMe(this._roleListSpr.closeFriendList);
				this._groupInfoSpr.switchBtnState(false);
			}
			else if(type == 1)// 关闭好友列表
			{
				DisplayUtil.removeMe(this._roleListSpr.roleList);
				this._groupInfoSpr2.switchBtnState(false);
			}
			else if(type == 2)// 关闭其他列表(好友、仇人、黑名单、最近联系)
			{
				DisplayUtil.removeMe(this._roleListSpr.roleList);
				this._groupInfoSpr.switchBtnState(false);
			}
		}
		
		/**
		 * 更新好友/密友列表显示人数 
		 * @type 更新列表类别 0--密友   1--好友  3--批量删除面板中的好友
		 * 
		 */
		public function updateRoleNum(type:int):void
		{
			switch(type)
			{
				case 0 : 
					this._groupInfoSpr.updateRoleNum();
					break;
				case 1 :
					this._groupInfoSpr2.updateRoleNum();
					break;
				case 3:
					this._friendDeletePanel.updateRoleNum();
					break;
			}
		}
		
		/**
		 * 编辑个性签名 
		 * @param e
		 * 
		 */
		private function editSign(e:FocusEvent):void
		{
			if(this._roleSign.text == Language.getString(40004))
			{
				this._roleSign.text = "";
			}
		}
		
		/**
		 * 更新个性签名 
		 * @return 
		 */
		private function updateSign(e:FocusEvent):void
		{
			
			if(this._roleSign.text != this._selfSign)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.SignatureUpdate,this._roleSign.text));
			}
			
			this._selfSign = this._roleSign.text;
			
			if(this._roleSign.text == "")
			{
				this._roleSign.text = Language.getString(40004);
			}
			
		}
		
		public function get friendSetPanel():FriendSetPanel
		{
			return this._friendSetPanel;
		}
		
		public function get friendDeletePanel():FriendDeletePanel
		{
			return this._friendDeletePanel;
		}
		
		public function get currSelGroup():int
		{
			return this._currSelGroup;
		}
		
		public function get tabBar():GTabBar
		{
			return this._tabBar;
		}
		
		public function get roleListSpr():RoleListSpr
		{
			return this._roleListSpr;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			
			super.disposeImpl(isReuse);
			
			_middlePaneBg.dispose(isReuse);
			_roleHead.dispose(isReuse);
			_roleLevel.dispose(isReuse);
			_roleCamp.dispose(isReuse);
			_roleCareer.dispose(isReuse);
			_roleName.dispose(isReuse);
			_vipImg.dispose(isReuse);
			_roleSign.dispose(isReuse);
			_tabBar.disposeChild(isReuse);
			_groupInfoSpr.dispose(isReuse);
			_groupInfoSpr2.dispose(isReuse);
			_roleListSpr.dispose(isReuse);
			_findBtn.dispose(isReuse);
			_deleteBtn.dispose(isReuse);
			_friendSetPanel.dispose(isReuse);
			_friendDeletePanel.dispose(isReuse);
			
			_middlePaneBg = null;
			_roleHead = null;
			_roleLevel = null;
			_roleCamp = null;
			_roleCareer = null;
			_roleName = null;
			_vipImg = null;
			_roleSign = null;
			_tabBar = null;
			_groupInfoSpr = null;
			_groupInfoSpr2 = null;
			_roleListSpr = null;
			_findBtn = null;
			_deleteBtn = null;
			_friendSetPanel = null;
			_friendDeletePanel = null;
		}
		
	}
}