package mortal.game.view.group.cellRenderer
{
	import Message.Public.ECamp;
	import Message.Public.ECareer;
	import Message.Public.EGroupOperType;
	import Message.Public.SGroupOper;
	import Message.Public.SPublicPlayer;
	
	import com.gengine.utils.HTMLUtil;
	import com.greensock.layout.AlignMode;
	import com.mui.controls.GButton;
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.player.info.EntityInfo;
	import mortal.game.view.common.ClassTypesUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.game.view.common.menu.PlayerMenuRegister;
	import mortal.game.view.group.GroupCache;
	import mortal.mvc.core.Dispatcher;
	
	public class NearPlayerCellRenderer extends GCellRenderer
	{
		//数据
		private var _entityInfo:EntityInfo;
		
		//显示对象
		private var _playerName:GTextFiled;
		
		private var _career:GTextFiled;
		
		private var _level:GTextFiled;
		
		private var _cam:GTextFiled;
		
		private var _power:GTextFiled;
		
		private var _inviteBtn:GButton;
		
		
		public function NearPlayerCellRenderer()
		{
			super();
			this.mouseEnabled = false;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.align = AlignMode.CENTER;
			
			_career = UIFactory.gTextField("",102,0,100,20,this,tf);
			
			_level = UIFactory.gTextField("",222,0,100,20,this,tf);
			
			_cam = UIFactory.gTextField("",332,0,100,20,this,tf);
			
			tf.underline = true;
			_playerName = UIFactory.gTextField("",-22,0,100,20,this,tf);
			
			tf = GlobalStyle.textFormatChen;
			tf.align = AlignMode.CENTER;
			_power = UIFactory.gTextField("",479,0,100,20,this,tf);
			
			_inviteBtn = UIFactory.gButton( Language.getString(30211),652,1,67,22,this,"GroupButton");
			_inviteBtn.configEventListener(MouseEvent.CLICK,inviteHandler);
			
			this.pushUIToDisposeVec(UIFactory.bg(0,25,760,1,this,ImagesConst.SplitLine));
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			PlayerMenuRegister.UnRegister(_playerName);
			
			_playerName.dispose(isReuse);
			_career.dispose(isReuse);
			_level.dispose(isReuse);
			_cam.dispose(isReuse);
			_power.dispose(isReuse);
			_inviteBtn.dispose(isReuse);
			
			_playerName = null;
			_career = null;
			_level = null;
			_cam = null;
			_power = null;
			_inviteBtn = null;
			
			super.disposeImpl(isReuse);
		}
		
		private function inviteHandler(e:MouseEvent):void
		{
			if( _entityInfo.entityInfo.level <= 0)   //玩家已经离线
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.GetNearPlayer));
				MsgManager.showRollTipsMsg(Language.getString(30253));
				return;
			}
			var arr:Array = new Array();
			var sGroupOper:SGroupOper = new SGroupOper();
			sGroupOper.fromEntityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.toEntityId = _entityInfo.entityInfo.entityId;
			sGroupOper.fromPlayer = new SPublicPlayer();
			sGroupOper.fromPlayer.entityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.type = EGroupOperType._EGroupOperTypeInvite;
				
			arr.push(sGroupOper);
			Dispatcher.dispatchEvent(new DataEvent(EventName.GroupInviteOper,arr));
		}
		
		private function setCareer(carrer:int):void
		{
			_career.text = GameDefConfig.instance.getCarrer(carrer);
		}
		
		private function setCamp(value:int):void
		{
			_cam.htmlText = HTMLUtil.addColor(GameDefConfig.instance.getECamp(value).text,GameDefConfig.instance.getECamp(value).text1);
			
		}
		
		override public function set data(arg0:Object):void
		{
			_entityInfo = arg0.data;
			if(_entityInfo && _entityInfo.entityInfo.level > 0)
			{
				setCareer(_entityInfo.entityInfo.career);
				setCamp(_entityInfo.entityInfo.camp);
				
				_playerName.htmlText = "<a href='event:#'>" + _entityInfo.entityInfo.name + "</a>";
				_level.text = _entityInfo.entityInfo.level.toString();
				_power.text = _entityInfo.entityInfo.combat.toString();
				
				var groupCache:GroupCache = Cache.instance.group;
				if(groupCache.players.length == 5 || (!groupCache.isCaptain && groupCache.isInGroup && !groupCache.memberInvite))
				{
					_inviteBtn.mouseEnabled = false;
					_inviteBtn.filters = [FilterConst.colorFilter2];
				}
				else
				{
					_inviteBtn.mouseEnabled = true;
					_inviteBtn.filters = [];
				}
				
				PlayerMenuRegister.Register(_playerName,_entityInfo,PlayerMenuConst.NearbyPlayerOpMenu);
			}
//			else if( _entityInfo.entityInfo.level <= 0)
//			{
//				Dispatcher.dispatchEvent(new DataEvent(EventName.GetNearPlayer));
//				MsgManager.showRollTipsMsg(Language.getString(30253));
//			}
			
		}
		
		override public function set selected(arg0:Boolean):void
		{
			
		}
		
	}
}