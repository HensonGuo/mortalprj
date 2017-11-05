package mortal.game.view.friend
{
	import Message.Game.SFriendRecord;
	import Message.Public.SMiniPlayer;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.window.SmallWindow;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.mvc.core.Dispatcher;

	/**
	 * 好友查询设置面板
	 * @date   2014-2-25 下午7:06:46
	 * @author dengwj
	 */
	public class FriendSetPanel extends SmallWindow
	{
		private var _middlePanelBg:ScaleBitmap;
		/** 查找玩家 */
		private var _findPlayerLabel:GTextFiled;
		/** 输入框 */
		private var _findInput:GTextInput;
		/** 搜索按钮 */
		private var _searchBtn:GButton;
		/** 分隔线 */
		private var _splitLine:ScaleBitmap;
		/** 万家名字 */
		private var _roleName:GTextFiled;
		/** 等级 */
		private var _roleLevel:GTextFiled;
		/** 职业 */
		private var _roleCareer:GTextFiled;
		/** 阵营 */
		private var _camp:GTextFiled;
		/** 战斗力 */
		private var _fightValue:GTextFiled;
		/** VIP开通 */
		private var _vipState:GBitmap;
		/** 性别 */
		private var _sex:GTextFiled;
		/** 状态 */
		private var _state:GTextFiled;
		/** 宣言 */
		private var _sign:GTextFiled;
		/** 属性名集合 */
		private const _attrList:Array = ["玩家名字：","等      级：","职      业：","阵      营：","战 斗  力：",
										"VIP开 通：","性      别：","状      态：","宣      言："];
		private var _propLabelList:Array = [];
		/** 加为好友超链 */
		private var _addFriend:GTextFiled;
		/** 发起私聊超链 */
		private var _sendPrivateChat:GTextFiled;
		/** 拉入黑名单超链 */
		private var _pushToBlack:GTextFiled;
		/** 多选框1 */
		private var _checkBox_1:GCheckBox;
		/** 多选框2 */
		private var _checkBox_2:GCheckBox;
		private var _rejectStrange:GTextFiled;
		private var _rejectDisturb:GTextFiled;
		
		/** 确定按钮 */
		private var _okBtn:GButton;
		/** 取消按钮 */
		private var _cancelBtn:GButton;
		/** 属性集合 */
		private var _propList:Vector.<GTextFiled> = new Vector.<GTextFiled>();
		/** 搜索到的玩家 */
		private var _searchRole:SMiniPlayer;
		
		/** 搜索玩家的名字 */
		private var _roleNameStr:String;
		
		public function FriendSetPanel()
		{
			super();
			init();
			this.layer = LayerManager.windowLayer;
		}
		
		private function init():void
		{
			setSize(315,338);
			title = "查询设置";
			this.isHideDispose = false;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_findPlayerLabel = UIFactory.gTextField("查找玩家：",28,42,65,20,this);
			_findPlayerLabel.textColor = 0xffffff;
			_findInput = UIFactory.gTextInput(94,39,152,26,this);
			_searchBtn = UIFactory.gButton("搜索",249,40,42,24,this,"PageBtn");
			_splitLine = UIFactory.bg(12,71,283,1,this,ImagesConst.SplitLine);
			
			for(var i:int = 0; i < _attrList.length; i++)
			{
				var x:int = 28 + (i % 2) * 180;
				var y:int = 81 + int(i / 2) * 26;
				var prop:GTextFiled = UIFactory.gTextField(_attrList[i],x,y,65,20,this);
				prop.textColor = 0xffffff;
				this._propLabelList.push(prop);
			}
			
			_roleName = UIFactory.gTextField("",84+6,81,112,20,this);
			_propList.push(_roleName);
			_roleLevel = UIFactory.gTextField("",260+7,81,50,20,this);
			_propList.push(_roleLevel);
			_roleCareer = UIFactory.gTextField("",84+6,110-3,112,20,this);
			_propList.push(_roleCareer);
			_camp = UIFactory.gTextField("",260+7,110-3,50,20,this);
			_propList.push(_camp);
			_fightValue = UIFactory.gTextField("",84+6,138-3,100,20,this);
			_propList.push(_fightValue);
			_vipState = UIFactory.gBitmap("",263+7,143-3,this);
			_sex = UIFactory.gTextField("",84+6,165-4,112,20,this);
			_propList.push(_sex);
			_state = UIFactory.gTextField("",260+7,165-5,50,20,this);
			_propList.push(_state);
			_sign = UIFactory.gTextField("",84+6,194-8,220,40,this);
			_sign.wordWrap = true;
			_propList.push(_sign);
			
			_addFriend = UIFactory.gTextField("",53,186+32,61,22,this);
			_addFriend.htmlText = "<u><a href='event:0'><font color='#00ff00'>加为好友</font></a></u>";
			_addFriend.visible = false;
			_sendPrivateChat = UIFactory.gTextField("",131,186+32,61,22,this);
			_sendPrivateChat.htmlText = "<u><a href='event:1'><font color='#00ff00'>发起私聊</font></a></u>";
			_sendPrivateChat.visible = false;
			_pushToBlack = UIFactory.gTextField("",210,186+32,70,22,this);
			_pushToBlack.htmlText = "<u><a href='event:2'><font color='#00ff00'>拉入黑名单</font></a></u>";
			_pushToBlack.visible = false;
			_addFriend.configEventListener(TextEvent.LINK, onTextClickHandler);
			_sendPrivateChat.configEventListener(TextEvent.LINK, onTextClickHandler);
			_pushToBlack.configEventListener(TextEvent.LINK,onTextClickHandler);
			
			_checkBox_1 = UIFactory.checkBox("",24,244,19,19,this);
			_checkBox_2 = UIFactory.checkBox("",24,267,19,19,this);
			_rejectStrange = UIFactory.gTextField("拒绝陌生人弹窗消息",47,244,130,22,this);
			_rejectDisturb = UIFactory.gTextField("拒绝他人将我加为好友",47,267,130,22,this);
			
			_okBtn = UIFactory.gButton("确定",94,297,56,24,this);
			_cancelBtn = UIFactory.gButton("取消",172,297,56,24,this);
			
			this.configEventListener(MouseEvent.CLICK,onClickHandler);
		}
		
		override public function show(x:int=0, y:int=0):void
		{
			super.show();
			
			if(ClientSetting.local.getIsDone(IsDoneType.RefuseStranger))
			{
				this._checkBox_1.selected = true;
			}
			else
			{
				this._checkBox_1.selected = false;
			}
			
			if(ClientSetting.local.getIsDone(IsDoneType.RefuseOtherApply))
			{
				this._checkBox_2.selected = true;
			}
			else
			{
				this._checkBox_2.selected = false;
			}
		}
		
		override protected function configParams():void
		{
			super.configParams();
			
			paddingBottom = 100;
		}
		
		override protected function setWindowCenter():void
		{
			
		}
		
		/**
		 * 点击按钮处理 
		 * @param e
		 */	
		private function onClickHandler(e:MouseEvent):void
		{
			if(e.target == _okBtn)
			{
				if(this._checkBox_1.selected == true)
				{
					ClientSetting.local.setIsDone(true, IsDoneType.RefuseStranger);
				}
				else
				{
					ClientSetting.local.setIsDone(false, IsDoneType.RefuseStranger);
				}
				if(this._checkBox_2.selected == true)
				{
					ClientSetting.local.setIsDone(true, IsDoneType.RefuseOtherApply);
				}
				else
				{
					ClientSetting.local.setIsDone(false, IsDoneType.RefuseOtherApply);
				}
				this.hide();
			}
			else if(e.target == _cancelBtn)
			{
				this.hide();
			}
			else if(e.target == _searchBtn)
			{// 搜索
				var roleName:String = _findInput.text;
				if(roleName == "")
				{
					MsgManager.showRollTipsMsg("请输入玩家名");
				}
				else
				{
//					roleName = roleName.replace( /^\s*|\s*$/g,"");// 去除前后空格
					roleName = roleName.replace(/\s/g,"");// 去除所有空格
					_roleNameStr = roleName;
					Dispatcher.dispatchEvent(new DataEvent(EventName.FriendSearch, [roleName]));
				}
			}
		}
		
		/**
		 * 点击超链接处理 
		 * @param e
		 */
		private function onTextClickHandler(e:TextEvent):void
		{
			switch(e.text)
			{
				case "0":
					// 走申请好友的流程
					var name:String = _roleName.text;
					if(name != "")
					{
						Dispatcher.dispatchEvent(new DataEvent(EventName.FriendApply, name));
					}
					break;
				case "1":
					PlayerMenuConst.Opearte(PlayerMenuConst.ChatPirvate,this.searchRole);
					break;
				case "2":
					Dispatcher.dispatchEvent(new DataEvent(EventName.AddToBlackList,this.searchRole));
					break;
			}
		}
		
		/**
		 * 更新显示数据 
		 * @param data
		 */
		public function updateData(data:Object):void
		{
			if(data)
			{
				var role:SMiniPlayer = data as SMiniPlayer;
				if(role.name != _roleNameStr)
				{
					return;
				}
				_roleName.text = role.name;
				_roleLevel.text = role.level + "级";
				_roleCareer.text = GameDefConfig.instance.getECareer(role.career).text;
				_camp.htmlText = GameDefConfig.instance.getCampHtml(role.camp);
				if(role.sex == 0)
				{
					_sex.text = "男";
				}
				else
				{
					_sex.text = "女";
				}
				if(!role.online)
				{
					_state.text = "离线";
				}
				else
				{
					_state.text = "在线";
				}
				_fightValue.text = "" + role.combat; 
//				 TODOs ============ vip开通
				this._vipState.visible = true;
				_vipState.bitmapData = GlobalClass.getBitmapData(ImagesConst.VIP_3);
				_sign.text = role.signature;
				if(role.signature == "")
				{
					_sign.text = Language.getString(40004).substr(3);
				}
				
				// 根据不同状态做不同显示
				switch(role.online)
				{
					case 0 :// 离线
						for each(var gtf:GTextFiled in this._propList)
						{
							gtf.filters = [FilterConst.colorFilter2];
						}
						this._vipState.filters = [FilterConst.colorFilter2];
						break;
					case 1 :// 在线
						for each(gtf in this._propList)
						{
							gtf.filters = [];
						}
						this._vipState.filters = [];
						break;
				}
				var roleId:int = role.entityId.id;
				var selfId:int = Cache.instance.role.playerInfo.playerId;
				
				if(roleId == selfId)
				{
					_addFriend.visible = false;
					_sendPrivateChat.visible = false;
					_pushToBlack.visible = false;
				}
				else
				{
					_addFriend.visible = true;
					_sendPrivateChat.visible = true;
					_pushToBlack.visible = true;
				}
				// 添加好友链接设置
				if(role.online == 1 && !isFriendOrBlack(roleId, 0) && roleId != selfId)// 在线非好友非本人
				{
					_addFriend.textColor = GlobalStyle.greenUint;
					_addFriend.mouseEnabled = true;
				}
				else
				{
					_addFriend.textColor = GlobalStyle.grayUint;
					_addFriend.mouseEnabled = false;
				}
				// 发起私聊链接设置
				if(role.online == 1 && !isFriendOrBlack(roleId, 1) && roleId != selfId)// 在线非黑名单非本人
				{
					_sendPrivateChat.textColor = GlobalStyle.greenUint;
					_sendPrivateChat.mouseEnabled = true;
				}
				else
				{
					_sendPrivateChat.textColor = GlobalStyle.grayUint;
					_sendPrivateChat.mouseEnabled = false;
				}
				// 拉黑链接设置
				if(!isFriendOrBlack(roleId, 1) && roleId != selfId)// 非黑名单de非本人
				{
					_pushToBlack.textColor = GlobalStyle.greenUint;
					_pushToBlack.mouseEnabled = true;
				}
				else
				{
					_pushToBlack.textColor = GlobalStyle.grayUint;
					_pushToBlack.mouseEnabled = false;
				}
				
			}
			else
			{// 未查找到玩家
				for each(var text:GTextFiled in _propList)
				{
					text.text = "";
				}
				this._vipState.visible = false;
				_addFriend.visible = false;
				_sendPrivateChat.visible = false;
				_pushToBlack.visible = false;
				MsgManager.showRollTipsMsg("该玩家不存在");
			}
		}
		
		/**
		 * 判断是否为好友或黑名单
		 * @return 
		 */		
		private function isFriendOrBlack(roleId:int, type:int):Boolean
		{
			var findList:Array = [];// 查找列表
			if(type == 0)// 好友列表
			{
				findList = Cache.instance.friend.friendList;
			}
			else
			{
				findList = Cache.instance.friend.blackList;
			}
			
			for each(var friend:SFriendRecord in findList)
			{
				if(roleId == friend.friendPlayer.entityId.id)
				{
					return true;
				}
			}
			return false;
		}
		
		public function get searchRole():SMiniPlayer
		{
			return this._searchRole;
		}
		
		public function set searchRole(role:SMiniPlayer):void
		{
			this._searchRole = role;
		}
	
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			for each(var tf:GTextFiled in _propLabelList)
			{
				tf.dispose(isReuse);
				tf = null;
			}
			_findPlayerLabel.dispose(isReuse);
			_findInput.dispose(isReuse);
			_searchBtn.dispose(isReuse);
			_splitLine.dispose(isReuse);
			_roleName.dispose(isReuse);
			_roleLevel.dispose(isReuse);
			_roleCareer.dispose(isReuse);
			_camp.dispose(isReuse);
			_fightValue.dispose(isReuse);
			_vipState.dispose(isReuse);
			_sex.dispose(isReuse);
			_state.dispose(isReuse);
			_sign.dispose(isReuse);
			_addFriend.dispose(isReuse);
			_sendPrivateChat.dispose(isReuse);
			_pushToBlack.dispose(isReuse);
			_checkBox_1.dispose(isReuse);
			_checkBox_2.dispose(isReuse);
			_rejectStrange.dispose(isReuse);
			_rejectDisturb.dispose(isReuse);
			_okBtn.dispose(isReuse);
			_cancelBtn.dispose(isReuse);
			
			_findPlayerLabel = null;
			_findInput = null;
			_searchBtn = null;
			_splitLine = null;
			_roleName = null;
			_roleLevel = null;
			_roleCareer = null;
			_camp = null;
			_fightValue = null;
			_vipState = null;
			_sex = null;
			_state = null;
			_sign = null;
			_addFriend = null;
			_sendPrivateChat = null;
			_pushToBlack = null;
			_checkBox_1 = null;
			_checkBox_2 = null;
			_rejectStrange = null;
			_rejectDisturb = null;
			_okBtn = null;
			_cancelBtn = null;
		}
	}
}