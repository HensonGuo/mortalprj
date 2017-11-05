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
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class GroupApplyCellRenderer extends GCellRenderer
	{
		private var _sGroupOper:SGroupOper;
		
		private var _teamName:GTextFiled;
		
		private var _career:GTextFiled;
		
		private var _level:GTextFiled;
		
		private var _cam:GTextFiled;
		
		private var _power:GTextFiled;
		
		private var _agreeBtn:GButton;
		
		private var _rejectBtn:GButton;
		
		public function GroupApplyCellRenderer()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.align = AlignMode.CENTER;
			
			_teamName = UIFactory.gTextField("",-13,0,100,20,this,tf);
			
			_career = UIFactory.gTextField("",129,0,100,20,this,tf);
			
			_level = UIFactory.gTextField("",253,0,100,20,this,tf);
			
			_cam = UIFactory.gTextField("",419,0,100,20,this);
			
			tf = GlobalStyle.textFormatChen;
			tf.align = AlignMode.CENTER;
			_power = UIFactory.gTextField("",503,0,100,20,this,tf);
			
			_agreeBtn = UIFactory.gButton( Language.getString(30230),648,1,40,22,this,"GroupButton");
			_agreeBtn.configEventListener(MouseEvent.CLICK,agreeHandler);
			
			_rejectBtn = UIFactory.gButton( Language.getString(30231),689,1,40,22,this,"GroupButton");
			_rejectBtn.configEventListener(MouseEvent.CLICK,rejectHandler);
			
			this.pushUIToDisposeVec(UIFactory.bg(0,25,760,1,this,ImagesConst.SplitLine));
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_teamName.dispose(isReuse);
			_career.dispose(isReuse);
			_level.dispose(isReuse);
			_cam.dispose(isReuse);
			_power.dispose(isReuse);
			_agreeBtn.dispose(isReuse);
			_rejectBtn.dispose(isReuse);
			
			_teamName = null;
			_career = null;
			_level = null;
			_cam = null;
			_power = null;
			_agreeBtn = null;
			_rejectBtn = null;
			
			super.disposeImpl(isReuse);
		}
		
		private function agreeHandler(e:MouseEvent):void
		{
			var arr:Array = new Array();
			var sGroupOper:SGroupOper = new SGroupOper();
			sGroupOper.fromEntityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.toEntityId = _sGroupOper.fromEntityId;
			sGroupOper.fromPlayer = new SPublicPlayer();
			sGroupOper.fromPlayer.entityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.type = EGroupOperType._EGroupOperTypeAgree;
			sGroupOper.uid = _sGroupOper.uid;
			
			arr.push(sGroupOper);
			Dispatcher.dispatchEvent(new DataEvent(EventName.GroupApplyOper,arr));
		}
		
		private function rejectHandler(e:MouseEvent):void
		{
			var arr:Array = new Array();
			var sGroupOper:SGroupOper = new SGroupOper();
			sGroupOper.fromEntityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.toEntityId = _sGroupOper.fromEntityId;
			sGroupOper.fromPlayer = new SPublicPlayer();
			sGroupOper.fromPlayer.entityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.type = EGroupOperType._EGroupOperTypeReject;
			sGroupOper.uid = _sGroupOper.uid;
			
			arr.push(sGroupOper);
			Dispatcher.dispatchEvent(new DataEvent(EventName.GroupApplyOper,arr));
		}
		
		private function setCareer(carrer:int):void
		{
			_career.text = GameDefConfig.instance.getCarrer(carrer);
		}
		
		private function setCamp(value:int):void
		{
			_cam.htmlText = GameDefConfig.instance.getCampHtml(value);
		}
		
		override public function set data(arg0:Object):void
		{
			_sGroupOper = arg0.data;
			
			if(_sGroupOper)
			{
				setCareer(_sGroupOper.fromPlayer.career);
				setCamp(_sGroupOper.fromPlayer.camp);
				
				_teamName.text = _sGroupOper.fromPlayer.name;
				_level.text = _sGroupOper.fromPlayer.level.toString();
				_power.text = _sGroupOper.fromPlayer.combat.toString();
				
			}
		}
	}
}