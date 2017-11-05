package mortal.game.view.friend
{
	import Message.Game.EFriendFlag;
	import Message.Game.SFriendRecord;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.global.Global;
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import fl.controls.listClasses.ListData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	import mortal.common.display.BitmapDataConst;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.utils.AvatarUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.menu.PlayerMenuRegister;
	import mortal.mvc.core.Dispatcher;
	
	/**
	 * @date   2014-2-21 下午3:53:17
	 * @author dengwj
	 */	 
	public class FriendCellRenderer extends GCellRenderer 
	{
		/** 选中条 */
		private var _selectedBar:ScaleBitmap;
		/** 头像框 */
		private var _headBorder:GBitmap;
		/** VIP等级图标 */
		private var _vipImg:GBitmap;
		/** 角色头像 */
		private var _headImg:GBitmap;
		/** 角色等级背景 */
		private var _levelBorder:ScaleBitmap;
		/** 角色等级 */
		private var _roleLevel:GTextFiled;
		/** 角色阵营 */
		private var _roleCamp:GTextFiled;
		/** 角色名字 */
		private var _roleName:GTextFiled;
		/** 战斗力 */
		private var _fightValue:GTextFiled;
		/** 个性签名 */
		private var _roleSign:GTextFiled;
		/** 亲密度图标数组 */
		private var _closeImgArr:Array = [];
		/** 亲密度 */
		private var _closeValue:int;
		/** 好友记录ID */
		private var _recordId:Number;
		/** 好友角色ID */
		private var _playerId:int;
		/** 显示对象集合 */
		private var _displayObjArr:Array = [];
		/** 是否变灰 */
		private var _isGray:Boolean = false;
		private var _bmp:GBitmap;
		private var _spr:Sprite;
		
		/** 角色数据 */
		private var _playerData:Object;
		
		/** 当前选中项 */
		public static var currSelected:FriendCellRenderer;
		
		public function FriendCellRenderer()
		{
			super();
			this.setSize(275, 45);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_headBorder = UIFactory.gBitmap("FriendHeadBg",2,0,this);
			_displayObjArr.push(_headBorder);
			_headImg = UIFactory.gBitmap("",3,2,this);
			_displayObjArr.push(_headImg);
			_vipImg = UIFactory.gBitmap(ImagesConst.VIP_3,2,0,this);
			_displayObjArr.push(_vipImg);
			_levelBorder = UIFactory.bg(0,24,21,18,this,ImagesConst.LevelBg);
			_displayObjArr.push(_levelBorder);
			_roleLevel = UIFactory.gTextField("99",3,23,30,20,this);
			_roleLevel.textColor = 0xffffff;
			_displayObjArr.push(_roleLevel);
			// 亲密度图标
			for(var i:int = 0; i < 5; i++)
			{
				var closeImg:GBitmap = UIFactory.gBitmap(ImagesConst.Qinmidu_light, 193 + 17 * i, 4, this);
				_closeImgArr.push(closeImg);
				_displayObjArr.push(closeImg);
			}
			_roleName = UIFactory.gTextField("玩家名字七个字",50,0,96,20,this);
			_roleName.textColor = 0xffc23f;
			_roleName.filters = [FilterConst.vipNameGlowFilter];
			_displayObjArr.push(_roleName);
			_roleCamp = UIFactory.gTextField("神域",156,0,35,20,this);
			_displayObjArr.push(_roleCamp);
			_fightValue = UIFactory.gTextField("99999",216,0,48,20,this);
			_fightValue.textColor = GlobalStyle.colorChenUint;
			_displayObjArr.push(_fightValue);
			
			_bmp = GlobalClass.getBitmap(BitmapDataConst.AlphaBMD);
			_bmp.width = 284;
			_bmp.height = 48;
			_spr = UIFactory.sprite(0,0,this);
			_spr.addChild(_bmp);
			
			_roleSign = UIFactory.gTextField("",50,24,200,24,this);
			_displayObjArr.push(_roleSign);
			_spr.doubleClickEnabled = true;
			_spr.addEventListener(MouseEvent.DOUBLE_CLICK, onDBClickHandler);
		}
		
		protected override function initSkin():void
		{
			var emptyBmp:GBitmap = new GBitmap;
			var selectSkin:ScaleBitmap = UIFactory.bg(0,0,282,46,null,ImagesConst.SelectBg);
			this.setStyle("downSkin",selectSkin);
			this.setStyle("overSkin",selectSkin);
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin",selectSkin);
			this.setStyle("selectedOverSkin",selectSkin);
			this.setStyle("selectedUpSkin",selectSkin);
		}
		
		override public function set data(arg0:Object):void
		{
			var value:Object;
			if(arg0.data is SFriendRecord)
			{
				value = arg0.data as SFriendRecord;
				var name:String         = value.friendPlayer.name;
				var signature:String    = value.friendPlayer.signature;
				var camp:int    		= value.friendPlayer.camp;
				var career:int          = value.friendPlayer.career;
				var sex:int             = value.friendPlayer.sex;
				var level:int           = value.friendPlayer.level; 
				var flag:int			= value.flag;
				var recordId:Number     = value.recordId;
				var playerId:int        = value.friendPlayer.entityId.id;
				var online:Boolean      = value.friendPlayer.online;
				var combat:int          = value.friendPlayer.combat;
				var friendType:int      = value.friendType;
			}
			else if(arg0.data is SMiniPlayer)
			{
				value = arg0.data as SMiniPlayer;
				name         = value.name;
				signature    = value.signature;
				camp		 = value.camp;
				career       = value.career;
				sex          = value.sex;
				level        = value.level; 
				playerId     = value.entityId.id;
				online       = value.online;
				combat       = value.combat;
				friendType   = 0;
				flag	     = 0;
				recordId     = 0;
			}
			
			this._playerData 		 = value;
			this._roleCamp.htmlText  = GameDefConfig.instance.getCampHtml(camp);
			this._headImg.bitmapData = GlobalClass.getBitmapData(AvatarUtil.getPlayerAvatar(career,sex,2));
			this._roleName.text      = name;
			this._roleLevel.text     = "" + level;
			
			if(level >= 100)
			{
				this._levelBorder.width = 30;
			}
			else
			{
				this._levelBorder.width = 21;
			}
			
			setSignature(signature);
			setTips(value);
			
			if(flag == EFriendFlag._EFriendFlagEnemy)
			{
				this._roleSign.toolTipData = null;
				ToolTipsManager.unregister(_spr);
			}
			
			this._recordId = recordId;
			this._playerId = playerId;
			
			displayByType(flag);
			
			if(!online)// 上下线灰/亮(好友、仇人)
			{
				this.setGray(true);
			}
			else
			{
				this.setGray(false);
				// TODO =====================判断是否VIP
				_roleName.filters = [FilterConst.vipNameGlowFilter];
			}
			if(flag == EFriendFlag._EFriendFlagBlackList)// 黑名单的全灰
			{
				this.setGray(true);
			}
			
			this._fightValue.text = combat + "";
			
			switch(flag)// 注册右键下拉菜单
			{
				case EFriendFlag._EFriendFlagFriend:
					if(friendType == 0)
					{
						PlayerMenuRegister.UnRegister(_spr);
						PlayerMenuRegister.Register(_spr,value,PlayerMenuConst.FriendOpMenu);
					}
					else
					{
						PlayerMenuRegister.UnRegister(_spr);
						PlayerMenuRegister.Register(_spr,value,PlayerMenuConst.IntimateFriendOpMenu);
					}
					break;
				case EFriendFlag._EFriendFlagBlackList :
					PlayerMenuRegister.UnRegister(_spr);
					PlayerMenuRegister.Register(_spr,value,PlayerMenuConst.BlackListOpMenu);
					break;
				case EFriendFlag._EFriendFlagEnemy:
					PlayerMenuRegister.UnRegister(_spr);
					PlayerMenuRegister.Register(_spr,value,PlayerMenuConst.EnemyOpMenu);
					break;
				case 0 :
					PlayerMenuRegister.UnRegister(_spr);
					PlayerMenuRegister.Register(_spr,value,PlayerMenuConst.RecentListOpMenu);
			}
		}
		
		/**
		 * 变灰 
		 * @param value
		 */
		private function setGray(value:Boolean):void
		{
			if(value && !_isGray)
			{
				this._isGray = true;
				for each(var item:Object in this._displayObjArr)
				{
					item.filters = [FilterConst.colorFilter2];
				}
			}
			if(!value && _isGray)
			{
				this._isGray = false;
				for each(item in this._displayObjArr)
				{
					item.filters = [];
				}
			}
		}
		
		/**
		 * 设置玩家签名 
		 * @param value
		 */	
		private function setSignature(sign:String):void
		{
			if(sign.length < 15)
			{
				this._roleSign.text = sign;
				this._roleSign.toolTipData = HTMLUtil.addColor(sign,"#FFFFFF");
				if(sign == "")
				{
					this._roleSign.text = Language.getString(40004).substr(3);
					this._roleSign.toolTipData = HTMLUtil.addColor(this._roleSign.text,"#FFFFFF");
				}
			}
			else
			{
				this._roleSign.text = sign.substr(0,15) + "...";
				this._roleSign.toolTipData = HTMLUtil.addColor(sign,"#FFFFFF");
			}
			
		}
		
		/**
		 * 设置好友项中的TIPS显示内容 
		 * @param value
		 */		
		private function setTips(value:Object):void
		{
			if(value is SFriendRecord)
			{
				var careerName:String = GameDefConfig.instance.getECareer(value.friendPlayer.career).text;
				var strToolTipData:String = "<textFormat leading='4'>" 
					+ HTMLUtil.addColor("阵营：","#ffffff") + GameDefConfig.instance.getCampHtml(value.friendPlayer.camp) + "<br/>"
					+ HTMLUtil.addColor("职业：","#ffffff") + HTMLUtil.addColor(careerName,"#f2de47") + "<br/>"
					+ HTMLUtil.addColor("亲密度：","#ffffff") + HTMLUtil.addColor(value.intimate+"","#ffffff")
					+ "<textFormat/>";
			}
			else if(value is SMiniPlayer)
			{
				careerName = GameDefConfig.instance.getECareer(value.career).text;
				strToolTipData = "<textFormat leading='4'>" 
					+ HTMLUtil.addColor("阵营：","#ffffff") + GameDefConfig.instance.getCampHtml(value.camp) + "<br/>"
					+ HTMLUtil.addColor("职业：","#ffffff") + HTMLUtil.addColor(careerName,"#f2de47") + "<br/>"
					+ HTMLUtil.addColor("亲密度：","#ffffff") + HTMLUtil.addColor(0+"","#ffffff")
					+ "<textFormat/>";
			}
			ToolTipsManager.unregister(_spr);
			ToolTipsManager.register(_spr,null,strToolTipData);
		}
		
		/**
		 * 根据记录所在列表做不同的显示 
		 * @param type 列表类型  1--好友  2--黑名单  4--仇人 0--最近联系
		 */		
		public function displayByType(type:int):void
		{
			switch(type)
			{
				case EFriendFlag._EFriendFlagFriend :
					friendInfoDisplay(0);
					break;
				case EFriendFlag._EFriendFlagBlackList :
				case 0:
					friendInfoDisplay(1);
					break;
				case EFriendFlag._EFriendFlagEnemy :
					friendInfoDisplay(2);
					break;
			}
		}
		
		/**
		 * 好友记录的信息显示 
		 * @param displayStyle 显示方式
		 */		
		public function friendInfoDisplay(displayStyle:int):void
		{
			switch(displayStyle)
			{
				case 0 :// 好友
					this._roleCamp.visible = false;
					this._fightValue.visible = false;
					this._roleSign.visible = true;
					for each(var closeImg:GBitmap in _closeImgArr)
					{
						closeImg.visible = true;
					}
					this._roleName.y = 0;
					this._roleCamp.y = 0;
					break;
				case 1 :// 黑名单、最近联系
					this._roleCamp.visible = true;
					this._fightValue.visible = false;
					this._roleSign.visible = false;
					for each(closeImg in _closeImgArr)
					{
						closeImg.visible = false;
					}
					this._roleName.y = 10;
					this._roleCamp.y = 10;
					break;
				case 2 :// 仇人
					this._roleCamp.visible = true;
					this._fightValue.visible = true;
					this._roleSign.visible = true;
					for each(closeImg in _closeImgArr)
					{
						closeImg.visible = false;
					}
					this._roleName.y = 0;
					this._roleCamp.y = 0;
					break;
			}
		}
		
		private function onDBClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			PlayerMenuRegister.HideOpList();
			
			if(_playerData is SFriendRecord)
			{
				if((_playerData as SFriendRecord).flag != EFriendFlag._EFriendFlagBlackList)
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.ChatPrivate,_playerData.friendPlayer));
				}
			}
			else if(_playerData is SMiniPlayer)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.ChatPrivate,_playerData));
			}
		}
		
		public function get recordId():Number
		{
			return this._recordId;
		}
		
		public function get playerId():int
		{
			return this._playerId;
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_headBorder.dispose(isReuse);
			_headImg.dispose(isReuse);
			_vipImg.dispose(isReuse);
			_levelBorder.dispose(isReuse);
			_roleLevel.dispose(isReuse);
			for each(var closeImg:GBitmap in _closeImgArr)
			{
				closeImg.dispose(isReuse);
				closeImg = null;
			}
			_roleCamp.dispose(isReuse);
			_roleName.dispose(isReuse);
			_fightValue.dispose(isReuse);
			_roleSign.dispose(isReuse);
			_bmp.dispose(isReuse);
			
			_headBorder = null;
			_headImg = null;
			_vipImg = null;
			_levelBorder = null;
			_roleLevel = null;
			_roleCamp = null;
			_roleName = null;
			_fightValue = null;
			_roleSign = null;
			_bmp = null;
		}
	}
}