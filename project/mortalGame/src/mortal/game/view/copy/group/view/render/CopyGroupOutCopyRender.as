/**
 * 2014-3-17
 * @author chenriji
 **/
package mortal.game.view.copy.group.view.render
{
	import Message.Public.EGroupOperType;
	import Message.Public.SCopyGroupInfo;
	import Message.Public.SGroupOper;
	import Message.Public.SPublicPlayer;
	
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class CopyGroupOutCopyRender extends GCellRenderer
	{
		protected var _txtName:GTextFiled;
		protected var _txtTeamNum:GTextFiled;
		protected var _txtFight:GTextFiled;
		protected var _btn:GLoadedButton;
		protected var _line:ScaleBitmap;
		
		protected var _info:SCopyGroupInfo;
		
		public function CopyGroupOutCopyRender()
		{
			super();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			//195 301 395
			super.createDisposedChildrenImpl();
			_txtName = UIFactory.gTextField("", 6, 6, 150, 20, this);
			_txtTeamNum = UIFactory.gTextField("", 195, 6, 150, 20, this);
			
			_txtFight = UIFactory.gTextField("", 301, 6, 150, 20, this);
			_txtFight.textColor = GlobalStyle.colorAnjinUint;
			_btn = UIFactory.gLoadedButton(ImagesConst.GroupBtn_upSkin, 395, 5, 64, 20, this);
			_btn.label = Language.getString(20192);
			
			_line = UIFactory.bg(0, 30, 465, 1, this, ImagesConst.SplitLine);
			
			_btn.configEventListener(MouseEvent.CLICK, clickBtnHandler);
		}
		
		public override function set data(value:Object):void
		{
			_info = value as SCopyGroupInfo;
			_txtName.text = _info.captainName + Language.getString(20194);
			
			
			// 计算平均战斗力
			var total:int = 0;
			for each(var player:SPublicPlayer in _info.members)
			{
				total += player.combat;
			}
			_txtFight.text = (total/_info.playerNum).toString();
			
			// 队伍是否已满
			if(_info.playerNum >= 5)
			{
				_txtTeamNum.textColor = 0xff0000;
				_txtTeamNum.text = Language.getString(30223);
			}
			else
			{
				_txtTeamNum.textColor = GlobalStyle.colorPutongUint;
				_txtTeamNum.text = _info.playerNum.toString() + "/5";
			}
			
			// 已经有队伍了不许申请
			if(Cache.instance.group.isInGroup)
			{
				_btn.mouseEnabled = false;
				_btn.filters = [FilterConst.colorFilter];
			}
			else
			{
				_btn.mouseEnabled = true;
				_btn.filters = [];
			}
		}
		
		private function clickBtnHandler(evt:MouseEvent):void
		{
			var arr:Array = new Array();
			var sGroupOper:SGroupOper = new SGroupOper();
			sGroupOper.fromEntityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.toEntityId = _info.captainId;
			sGroupOper.fromPlayer = new SPublicPlayer();
			sGroupOper.fromPlayer.entityId = Cache.instance.role.entityInfo.entityId;
			sGroupOper.type = EGroupOperType._EGroupOperTypeApply;
			
			arr.push(sGroupOper);
			Dispatcher.dispatchEvent(new DataEvent(EventName.GroupInviteOper,arr));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_txtName.dispose(isReuse);
			_txtFight.dispose(isReuse);
			_txtTeamNum.dispose(isReuse);
			
			_txtName = null;
			_txtFight = null;
			_txtTeamNum = null;
			
			_btn.dispose(isReuse);
			_btn = null;
			
			_line.dispose(isReuse);
			_line = null;
		}
		
		public override function set label(value:String):void
		{
			
		}
	}
}