package mortal.game.view.group.cellRenderer
{
	import Message.Public.ECamp;
	import Message.Public.ECareer;
	import Message.Public.SGroupPlayer;
	
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mortal.common.GTextFormat;
	import mortal.common.display.BitmapDataConst;
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.window.Window;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.menu.PlayerMenuRegister;
	import mortal.mvc.core.Dispatcher;
	
	public class TeamMateCellRenderer extends GCellRenderer
	{
		//数据
		private var _teamMateInfo:SGroupPlayer;
		
		//显示对象
		private var _selectedBg:ScaleBitmap;
		
		private var _bg:GBitmap;  //显示状态背景(有人,没人,锁定)
		
		private var _level:GTextFiled;
		
		private var _playerName:GTextFiled;
		
		private var _operOutBtn:GButton;
		
		private var _vipIcon:GBitmap;
		
		private var _camIcon:GBitmap;
		
		private var _captainIcon:GBitmap;
		
		private var _career:GTextFiled;
		
		private var _fightPower:GTextFiled;
		
		private var _captainText:GTextFiled;
		
		//3D模型
		protected var _rect3d:Rect3DObject;
		
		public function TeamMateCellRenderer()
		{
			super();
		}

		protected override function initSkin():void
		{
			var emptyBmp:GBitmap = new GBitmap;
			var selectSkin:ScaleBitmap = UIFactory.bg(0,0,153,287,null,ImagesConst.selectedBg);
			this.setStyle("downSkin",selectSkin);
			this.setStyle("overSkin",selectSkin);
			this.setStyle("upSkin",emptyBmp);
			this.setStyle("selectedDownSkin",selectSkin);
			this.setStyle("selectedOverSkin",selectSkin);
			this.setStyle("selectedUpSkin",selectSkin);
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bg = UIFactory.gBitmap("",2,2,this);
			
			var ft:GTextFormat = GlobalStyle.textFormatBai;
			
			_level = UIFactory.gTextField("",15,5,50,20,this,ft);
			
			_career = UIFactory.gTextField("",20,263,50,20,this,ft);
			
			ft.underline = true;
			_playerName = UIFactory.gTextField("",60,5,80,20,this,ft);
			
			ft = GlobalStyle.textFormatAnjin;
			_fightPower = UIFactory.gTextField("",45,264,100,20,this, GlobalStyle.textFormatChen);
			
			_captainText = UIFactory.gTextField(Language.getString(30209),70,235,60,20,this,ft);
			
			_vipIcon = UIFactory.gBitmap(ImagesConst.VIP,3,21,this);
			
			_camIcon = UIFactory.gBitmap("",122,28,this);
			
			_captainIcon = UIFactory.gBitmap(ImagesConst.Captain,40,232,this);
			
			_operOutBtn = UIFactory.gButton("",36,236,78,22,this,"GroupInviteButton");
			_operOutBtn.configEventListener(MouseEvent.CLICK,operHandler);
		
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			PlayerMenuRegister.UnRegister(_playerName);
			
			_bg.dispose(isReuse);
			_level.dispose(isReuse);
			_playerName.dispose(isReuse);
			_operOutBtn.dispose(isReuse);
			_vipIcon.dispose(isReuse);
			_camIcon.dispose(isReuse);
			_captainIcon.dispose(isReuse);
			_career.dispose(isReuse);
			_fightPower.dispose(isReuse);
			_captainText.dispose(isReuse);
			
			_bg = null;
			_level = null;
			_playerName = null;
			_operOutBtn = null;
			_vipIcon = null;
			_camIcon = null;
			_captainIcon = null;
			_career = null;
			_captainText = null;
			_fightPower = null;
			
			super.disposeImpl(isReuse);
		}
		
//		override public function set selected(arg0:Boolean):void
//		{
//			super.selected = arg0;
//			
//			if(arg0 && _teamMateInfo)
//			{
//				this.filters = [FilterConst.colorGlowFilter(0x36B7FF)];
//			}
//			else
//			{
//				this.filters = [];
//			}
//		}
		
		
		private function operHandler(e:MouseEvent):void
		{
			if(Cache.instance.group.isInGroup)
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.KickOut, _teamMateInfo.player.entityId));
			}
			else
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.CreateGroup));
			}
		}
		
		private function setCamp(value:int):void
		{
			var url:String;
			switch(value)
			{
				case ECamp._ECampNo:
					url = "";break;
				case ECamp._ECampA:
					url = ImagesConst.Camp_a;break;
				case ECamp._ECampB:
					url = ImagesConst.Camp_a;break;
				case ECamp._ECampC:
					url = ImagesConst.Camp_a;break;
			}
			_camIcon.visible = true;
			
			if(url)
			{
				_camIcon.bitmapData = GlobalClass.getBitmapData(url);
			}
		}
		
		private function setCareer(carrer:int):void
		{
			_career.visible = true;
			_career.text = GameDefConfig.instance.getECarrerShot(carrer);;
		}
		
		override public function set data(arg0:Object):void
		{
			_teamMateInfo = arg0.data;
			_operOutBtn.visible = false;
			if(_teamMateInfo)
			{
				setCamp(_teamMateInfo.player.camp);
				setCareer(_teamMateInfo.player.career);
				this.mouseEnabled = true;
				this.mouseChildren = true;
				
				_fightPower.text = Language.getString(30256) + _teamMateInfo.player.combat;
				var bmd:BitmapData = new BitmapData(150,287,true,0x00FFFFFF)
				_bg.bitmapData = bmd;
				_vipIcon.visible = _teamMateInfo.player.VIP == 1;
				_level.text = "Lv. " + _teamMateInfo.player.level;
				_playerName.htmlText = "<a href='event:#'>" + _teamMateInfo.player.name + "</a>";
				_playerName.visible = true;
				
				if(!Cache.instance.group.isInGroup)    //单人状态
				{
					_operOutBtn.visible = true;
					_operOutBtn.label = Language.getString(30237);
					_captainText.visible = _captainIcon.visible = false;
					PlayerMenuRegister.Register(_playerName,_teamMateInfo.player,PlayerMenuConst.GroupSelfOpMenu);
				}
				else if(Cache.instance.group.isCaptain) //玩家是否是队长
				{
					if(!Cache.instance.group.isCaptainById(_teamMateInfo.player.entityId.id))  //这个cell不是队长
					{
						_operOutBtn.visible = true;
						_operOutBtn.label = Language.getString(30238);
						_captainText.visible = _captainIcon.visible = false;
						PlayerMenuRegister.Register(_playerName,_teamMateInfo.player,PlayerMenuConst.GroupMemberOpMenu);
					}
					else   //这个cell是队长
					{
						_operOutBtn.visible = false;
						_captainText.visible = _captainIcon.visible = true;
						PlayerMenuRegister.Register(_playerName,_teamMateInfo.player,PlayerMenuConst.GroupSelfOpMenu);
					}
					
				}
				else  //不是队长
				{
					_operOutBtn.visible = false;
					if(!Cache.instance.group.isCaptainById(_teamMateInfo.player.entityId.id))  //这个cell不是队长
					{
						_captainText.visible = _captainIcon.visible = false;
					}
					else   //这个cell是队长
					{
						_captainText.visible = _captainIcon.visible = true;
					}
					
					if(_teamMateInfo.player.entityId.id == Cache.instance.role.entityInfo.entityId.id) //这个cell是自己
					{
						PlayerMenuRegister.Register(_playerName,_teamMateInfo.player,PlayerMenuConst.GroupSelfOpMenu);
					}
					else
					{
						PlayerMenuRegister.Register(_playerName,_teamMateInfo.player,PlayerMenuConst.GroupMemberOpMenu);
					}
				}
			}
			else    //空
			{
				setCamp(ECamp._ECampNo);
				this.mouseEnabled = false;
				this.mouseChildren = false;
				
				_bg.bitmapData = GlobalClass.getBitmapData(ImagesConst.GroupWaitBg);
				_vipIcon.visible = false;
				_captainIcon.visible = false;
				_level.text = "";
				_captainText.visible = false;
				_operOutBtn.visible = false;
				_playerName.visible = false;
				_camIcon.visible = false;
				_career.visible = false;
				_fightPower.text = "";
			}
		}
		
		
	}
}