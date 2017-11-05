/**
 * 2014-5-6
 * @author chenriji
 **/
package mortal.game.view.task
{
	import Message.DB.Tables.TNpc;
	
	import com.gengine.global.Global;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GTextFiled;
	
	import flash.events.MouseEvent;
	
	import mortal.common.display.LoaderHelp;
	import mortal.common.global.GlobalStyle;
	import mortal.common.net.CallLater;
	import mortal.common.sound.SoundManager;
	import mortal.common.sound.SoundTypeConst;
	import mortal.game.manager.ClockManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.NPCConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.task.data.TaskIntroduceData;
	import mortal.mvc.core.View;
	
	public class TaskIntroduce extends View
	{
		private static var _instance:TaskIntroduce;
		
		private var _bg:GBitmap;
		private var _icon:GBitmap;
		private var _txtName:GTextFiled;
		private var _txtDesc:GTextFiled;
		private var _btnClose:GLoadedButton;
		private var _timerId:int;
		private var _datas:Array;
		
		public function TaskIntroduce()
		{
			super();
			this.layer = LayerManager.windowLayer;
		}
		
		public static function get instance():TaskIntroduce
		{
			if(_instance == null)
			{
				_instance = new TaskIntroduce();
			}
			return _instance;
		}

		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_bg = UIFactory.gBitmap(null, 0, 0, this);
			LoaderHelp.setBitmapdata(ImagesConst.TaskIntroduce + ".swf", _bg);
			
			_icon = UIFactory.gBitmap(null, 49, 20, this);
			_txtName = UIFactory.gTextField("", 105, 6, 150, 100, this);
			_txtName.textColor = GlobalStyle.colorChenUint;
			
			_txtDesc = UIFactory.gTextField("", 105, 24, 150, 100, this);
			_txtDesc.multiline = true;
			_txtDesc.wordWrap = true;
			
			_btnClose = UIFactory.gLoadedButton("CloseButtonSmall", 257 , 4, 22, 22, null);
			_btnClose.focusEnabled = true;
			_btnClose.configEventListener(MouseEvent.CLICK, closeBtnClickHandler);
			addChild(_btnClose);
		}
		
		public function showIntroduces(arr:Array):void
		{
			if(_timerId > 0)
			{
				CallLater.removeCallLater(_timerId);
				_timerId = -1;
			}
			_datas = arr.concat();
			callNext();
			show();
		}
		
		public override function show(x:int=0, y:int=0):void
		{
			super.show(Global.stage.stageWidth - 330, Global.stage.stageHeight - 300);
		}
		
		public override function hide():void
		{
			super.hide();
			if(_timerId > 0)
			{
				CallLater.removeCallLater(_timerId);
				_timerId = -1;
			}
		}
		
		private function callNext(params:*=null):void
		{
			if(_datas == null || _datas.length == 0)
			{
				hide();
				return;
			}
			var data:TaskIntroduceData = _datas.shift();
			var npcInfo:TNpc = NPCConfig.instance.getInfoByCode(data.npcId);
			_txtName.text = npcInfo.name;
			_txtDesc.htmlText = data.htmlText;
			LoaderHelp.setBitmapdata(data.npcId.toString() + ".jpg", _icon);
			_timerId = CallLater.setCallLater(callNext, data.time);
		}
		
		protected function closeBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.soundPlay(SoundTypeConst.UIclose);
			hide();
		}
	}
}