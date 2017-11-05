package mortal.game.view.task.drama.operations.npctalk
{
	import com.gengine.global.Global;
	import com.mui.controls.GTextFiled;
	import com.mui.core.GlobalClass;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.common.DisplayUtil;
	import mortal.game.view.common.UIFactory;
	
	
	public class TaskDramaTalkMaskText extends Sprite
	{
		private var _data:TaskDramaTalkData;
		private var _txtTalk:GTextFiled;
		private var _mask:TaskDramaTalkMask;
		private var _onEnd:Function;
		
		private var _timerId1:int;
		private var _timerId2:int;
		
		private var _txtParser:TaskDramaTalkTextParser;
		private var _facesContainer:Sprite;
		
		private var _textFaceContainer:Sprite;
		private var _isShowingStage:Boolean;
		
		public function TaskDramaTalkMaskText()
		{
			super();
			initView();
		}
		
		public function dispose():void
		{
			if(_timerId1 > 0)
			{
				clearTimeout(_timerId1);
				_timerId1 = -1;
			}
			if(_timerId2 > 0)
			{
				clearTimeout(_timerId2);
				_timerId2 = -1;
			}
			Global.stage.removeEventListener(MouseEvent.CLICK, clickNextStep);
		}
		
		public function get data():TaskDramaTalkData
		{
			return _data;
		}
		
		public function resize(reWidth:int):void
		{
			_mask.reWidth(reWidth);
			_txtTalk.width = reWidth;
		}
		
		public function show(value:TaskDramaTalkData, callback:Function):void
		{
			_data = value;
			_onEnd = callback;
			_isShowingStage = false;
			var tf:TextFormat = _txtTalk.defaultTextFormat;
			tf.size = _data.talkFontSize;
//			tf.font = FontUtil.xingkaiName;
			tf.leading = _data.talkFontLeading;
			_txtTalk.defaultTextFormat = tf;
			_txtTalk.textColor = 0xB3FDFC;
			_txtTalk.width = _data.rowWidth;
			_txtTalk.text = "";
			
			_timerId1 = setTimeout(onPopupEnd, _data.popupTime*1000);
			Global.stage.addEventListener(MouseEvent.CLICK, clickNextStep);
		}
		
		private function clickNextStep(evt:MouseEvent):void
		{
			if(!_isShowingStage)
			{
//				_isShowingStage = true;
//				_mask.showAll();
				clearTimeout(_timerId1);
				onPopupEnd();
				_mask.finishRightNow();
			}
			else
			{
				clearTimeout(_timerId2);
				onShowEnd();
			}
		}
		
		public function stopShow():void
		{
			clearTimeout(_timerId1);
			clearTimeout(_timerId2);
			_mask.stop();
			Global.stage.removeEventListener(MouseEvent.CLICK, clickNextStep);
			_isShowingStage = false;
		}
		
		/**
		 * 窗口popup结束
		 */
		private function onPopupEnd():void
		{
			var datas:Array = textParser.parse(_data.talk, _data.talkFontLeading, _data.talkFontSize, _data.rowWidth);
			
			// 设置字幕
			_txtTalk.htmlText = String(datas[0]);
			
			// 添加表情
			DisplayUtil.removeAllChild(_facesContainer);
			_facesContainer.addChild(getFaceSprite(datas[1] as Array));
			
			// 滚动字幕
			_mask.reInit(_data, _txtTalk, onRollingEnd);
			
			_isShowingStage = false;
		}
		
		private function getFaceSprite(faces:Array):Sprite
		{
			var res:Sprite = new Sprite();
			for(var i:int = 0; faces && i < faces.length; i++)
			{
				var face:TaskDramaTalkFaceData = faces[i] as TaskDramaTalkFaceData;
				var mcFace:MovieClip = GlobalClass.getInstance("a" + face.faceId.toString()) as MovieClip;
				mcFace.x = face.faceX;
				mcFace.y = face.faceY;
				mcFace.mouseEnabled = true;
				mcFace.buttonMode = true;
				res.addChild(mcFace);
			}
			return res;
		}
		
		/**
		 * 滚动字幕结束
		 */
		private function onRollingEnd():void
		{
			_isShowingStage = true;
			_timerId2 = setTimeout(onShowEnd, _data.showTime);
		}
		
		private function get textParser():TaskDramaTalkTextParser
		{
			if(_txtParser == null)
				_txtParser = new TaskDramaTalkTextParser();
			return _txtParser;
		}
		
		private function onShowEnd():void
		{
			_isShowingStage = false;
			clearTimeout(_timerId1);
			clearTimeout(_timerId2);
			Global.stage.removeEventListener(MouseEvent.CLICK, clickNextStep);
			if(_onEnd != null)
			{
				_onEnd.apply();
				_onEnd = null;
			}
		}
		
		private function initView():void
		{
			_textFaceContainer = new Sprite();
			this.addChild(_textFaceContainer);
			
			_txtTalk = UIFactory.gTextField("", 0, 0, 200, 500, _textFaceContainer);
			_txtTalk.multiline = true;
			_txtTalk.wordWrap = true;
			_txtTalk.mouseEnabled = false;
			_txtTalk.mouseWheelEnabled = false;
			
			_facesContainer = new Sprite();
			_textFaceContainer.addChild(_facesContainer)
			
			_mask = new TaskDramaTalkMask();
			
			_textFaceContainer.mask = _mask;
			
			this.addChild(_mask);
		}
	}
}