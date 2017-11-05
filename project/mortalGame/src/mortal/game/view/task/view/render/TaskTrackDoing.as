/**
 * 2014-2-24
 * @author chenriji
 **/
package mortal.game.view.task.view.render
{
	import Message.Public.ETaskQuick;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GSprite;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.component.gLinkText.GLinkText;
	import mortal.component.gLinkText.GLinkTextData;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.SceneConfig;
	import mortal.game.scene3D.map3D.sceneInfo.SceneInfo;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.task.data.GLinkTextDataParser;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.game.view.task.view.track.BtnShowTrackItem;
	import mortal.mvc.core.Dispatcher;
	
	public class TaskTrackDoing extends TaskTrackBase
	{
		private var _openBtn:BtnShowTrackItem;
		private var _btnQuick:GButton;
		
		public function TaskTrackDoing()
		{
			_dx = 16;
			super();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_openBtn = new BtnShowTrackItem();
			_openBtn.y = 4;
			_txtTitle.x = _dx;
			_bodySprite.x = _dx;
			this.addChild(_openBtn);
			
			_openBtn.configEventListener(MouseEvent.CLICK, clickExpandHandler);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			if(_btnQuick != null)
			{
				_btnQuick.dispose(isReuse);
				_btnQuick = null;
			}
			_openBtn.dispose(isReuse);
			_openBtn = null;
		}
		
		private function clickExpandHandler(evt:MouseEvent):void
		{
			if(_openBtn.isClose)
			{
				openInfo(true);
			}
			else
			{
				closeInfo(true);
			}
		}
		
		/**
		 * 任务详细信息是否关闭状态 
		 * @return 
		 * 
		 */
		public function get isClose():Boolean
		{
			return _openBtn.isClose;
		}
		
		/**
		 * 打开或关闭任务详细信息 
		 * 
		 */
		public function showOrHideInfo():void
		{
			if(_openBtn.isClose)
			{
				openInfo();
			}
			else
			{
				closeInfo();
			}
		}
		
		public override function set taskInfo(value:TaskInfo):void
		{
			_taskInfo = value;
			var curStep:int = _taskInfo.playerTask.currentStep;
			
			var dataAll:Array = GLinkTextDataParser.parse(_taskInfo);//parseProcess(value.stask.processMap, _taskInfo);
			if(_taskInfo.isComplete())
			{
				curStep = dataAll.length - 1;
			}
			var datas:Array = dataAll[curStep];
			for(var i:int = 0; i < datas.length; i++)
			{
				var text:GLinkText = getText(i);
				text.y = (i + 1) * 18;
				text.setLinkText(datas[i] as GLinkTextData, getExtendHtmlText());
			}
			var tmp:int = i;
			for(; i < _txts.length; i++)
			{
				text = _txts[i];
				text.dispose(true);
			}
			if(i >tmp)
			{
				_txts.splice(tmp);
			}
			
			// 更新标题
			_txtTitle.htmlText = getTitleName();
			
			// 更新按钮
			var btnLabel:String = "";
			var quick:int = _taskInfo.stask.canQuickComplete;
			if(_taskInfo.isFail())
			{
				btnLabel = Language.getString(20164); // 放弃任务
			}
			else if(quick != ETaskQuick._ETaskQuickNo)
			{
				// 是否可以快捷完成、提交
				if(_taskInfo.isComplete())
				{
					if((quick & ETaskQuick._ETaskQuickFinish) > 0) // 已完成了，快速提交
					{
						btnLabel = Language.getString(20183);
					}
				}
				else
				{
					if(quick == (ETaskQuick._ETaskQuickFinish|ETaskQuick._ETaskQuickComplete))
					{
						btnLabel = Language.getString(20184); // 快速完成提交
					}
					else if(quick == ETaskQuick._ETaskQuickComplete)
					{
						btnLabel = Language.getString(20166); // 快速完成
					}
				}
			}
			
			if(btnLabel != "")
			{
				if(_btnQuick == null)
				{
					var tyy:int = 22;
					if(text != null)
					{
						tyy = text.y + text.height + 2;
					}
					_btnQuick = UIFactory.gButton("", _txtTitle.x, tyy, 60, 22, _bodySprite);
					_btnQuick.configEventListener(MouseEvent.CLICK, clickFinishHandler);
				}
				if(_btnQuick.parent == null)
				{
					_bodySprite.addChild(_btnQuick);
				}
				_btnQuick.label = btnLabel;
				_btnQuick.mouseEnabled = true;
			}
			else
			{
				DisplayUtil.removeMe(_btnQuick);
			}
		}
		
		private function clickFinishHandler(evt:MouseEvent):void
		{
			_btnQuick.mouseEnabled = false;
			switch(_btnQuick.label)
			{
				case Language.getString(20184): // 快速完成提交
					Dispatcher.dispatchEvent(new DataEvent(EventName.TaskQuickCompleteFinish, _taskInfo));
					break;
				case Language.getString(20166): // 快速完成
					Dispatcher.dispatchEvent(new DataEvent(EventName.TaskQuickComplete, _taskInfo));
					break;
				case Language.getString(20183): //快速提交
					Dispatcher.dispatchEvent(new DataEvent(EventName.TaskQuickFinish, _taskInfo));
					break;
				case Language.getString(20164): // 放弃任务
					Dispatcher.dispatchEvent(new DataEvent(EventName.TaskGiveupTask, _taskInfo));
					break;
			}
		}
		
		/**
		 * 打开任务详细信息 
		 * 
		 */
		public override function openInfo(isDispatchEvent:Boolean=false):void
		{
			if(!_bodySprite.parent)
			{
				this.addChild(_bodySprite);
			}
			
			_openBtn.open(isDispatchEvent);
			
			
		}
		
		/**
		 * 关闭任务详细信息 
		 * 
		 */
		public override function closeInfo(isDispatchEvent:Boolean=false):void
		{
			if(_bodySprite.parent)
			{
				this.removeChild(_bodySprite);
			}
			
			_openBtn.close(isDispatchEvent);
		}
		
		override public function get height():Number
		{
			if(_openBtn.isClose)
			{
				return 22;
			}
			if(_btnQuick != null && _btnQuick.parent != null)
			{
				return _btnQuick.y + _btnQuick.height;
			}
			return super.height;

		}
	}
}