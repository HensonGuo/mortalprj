package mortal.game.view.group.cellRenderer
{
	import Message.Public.EGroupOperType;
	import Message.Public.SEntityId;
	import Message.Public.SGroup;
	import Message.Public.SGroupOper;
	import Message.Public.SGroupPlayer;
	import Message.Public.SPublicPlayer;
	
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
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.menu.PlayerMenuRegister;
	import mortal.mvc.core.Dispatcher;
	
	public class NearTeamCellRenderer extends GCellRenderer
	{
		//数据
		private var _sgroup:SGroup;
		
		//显示对象
		private var _teamName:GTextFiled;
		
		private var _canptain:GTextFiled;
		
		private var _num:GTextFiled;
		
		private var _heightestPower:GTextFiled;
		
		private var _operBtn:GButton;
		
		
		public function NearTeamCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.align = AlignMode.CENTER;
			
			_teamName = UIFactory.gTextField("",-16,0,100,20,this,tf);
			
			_num = UIFactory.gTextField("",284,0,100,20,this,tf);
			
			_heightestPower = UIFactory.gTextField("",433,0,120,20,this,tf);
			
			tf = GlobalStyle.textFormatChen;
			tf.align = AlignMode.CENTER;
			_canptain = UIFactory.gTextField("",137,0,100,20,this,tf);
			
			_operBtn = UIFactory.gButton( Language.getString(30226),654,1,67,22,this,"GroupButton");
			_operBtn.configEventListener(MouseEvent.CLICK,applyJoin);
			
			this.pushUIToDisposeVec(UIFactory.bg(0,25,760,1,this,ImagesConst.SplitLine));
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_teamName.dispose(isReuse);			
			_canptain.dispose(isReuse);		
			_num.dispose(isReuse);		
			_heightestPower.dispose(isReuse);		
			_operBtn.dispose(isReuse);	
			
			_teamName = null;
			_canptain = null;
			_num = null;
			_heightestPower = null;
			_operBtn = null;
			
			super.disposeImpl(isReuse);
		}
		
		private function applyJoin(e:MouseEvent):void
		{
			var arr:Array = new Array();
			var sGroupOper:SGroupOper = new SGroupOper();
			sGroupOper.fromEntityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.toEntityId = _sgroup.captainId;
			sGroupOper.fromPlayer = new SPublicPlayer();
			sGroupOper.fromPlayer.entityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.type = EGroupOperType._EGroupOperTypeApply;
			
			arr.push(sGroupOper);
			Dispatcher.dispatchEvent(new DataEvent(EventName.GroupInviteOper,arr));
		}
		
		private function getCaptainName(captainId:SEntityId):String
		{
			var arr:Array = _sgroup.players;
			var str:String;
			for each(var i:SGroupPlayer in arr)
			{
				if(i.player.entityId.id == captainId.id)
				{
					str = i.player.name;
				}
			}
			return str;
		}
		
		override public function set data(arg0:Object):void
		{
			_sgroup = arg0.data;
			if(_sgroup)
			{
				_teamName.text = _sgroup.name;
				_canptain.text = getCaptainName(_sgroup.captainId);
				_num.text = _sgroup.players.length == 5? Language.getString(30223):_sgroup.players.length + "/5";
				
				
				if(_sgroup.players.length == 5)
				{
					_operBtn.mouseEnabled = false;
					_operBtn.filters = [FilterConst.colorFilter2];
				}
				else
				{
					_operBtn.mouseEnabled = true;
					_operBtn.filters = [];
				}
				
				var maxValuePlayer:SPublicPlayer = new SPublicPlayer();
				for each(var i:SGroupPlayer in _sgroup.players)
				{
					if(i.player.combat > maxValuePlayer.combat)
					{
						maxValuePlayer = i.player;
					}
				}
				_heightestPower.htmlText = maxValuePlayer.name + "<font color='#FF5a00'>(" + maxValuePlayer.combat + ")</font>";
//				PlayerMenuRegister.Register(_playerName,_sgroup.,PlayerMenuConst.NearbyPlayerOpMenu);
			}
		}
	}
}