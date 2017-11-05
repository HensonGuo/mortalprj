/**
 * 2014-2-28
 * @author chenriji
 **/
package mortal.game.view.task.view
{
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GButton;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GSprite;
	
	import extend.language.Language;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.component.gLinkText.GLinkText;
	import mortal.component.gLinkText.GLinkTextData;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.GameConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.task.data.GLinkTextDataParser;
	import mortal.game.view.task.data.TaskInfo;
	import mortal.mvc.core.Dispatcher;
	
	public class TaskItemDesc extends GSprite
	{
		// 任务描述
		private var _pane:GScrollPane;
		private var _descContianer:GSprite;
		private var _desc:Array;
		// 任务目标
		private var _target:Array;
		// 任务奖励
		private var _reward:TaskReward;
		// 放弃任务
		private var _btnGiveup:GButton;
		// 数据
		private var _taskInfo:TaskInfo;
		
		public function TaskItemDesc()
		{
			super();
		}
		
		
		public function get taskInfo():TaskInfo
		{
			return _taskInfo;
		}

		public function set taskInfo(value:TaskInfo):void
		{
			_taskInfo = value;
			var datas:Array = GLinkTextDataParser.parse(_taskInfo);
			
			// 当前进行到第几步
			var curStep:int = _taskInfo.curStep;
			
			// 任务描述
			var txtNum:int = 0;
			var txtY:int = 0;
			for(var i:int = 0; i < datas.length; i++)
			{
				var stepNum:String = Language.getStringByParam(20160, GameConst.Num_ZhongWen[i]);
				var subDatas:Array = datas[i];
				for(var j:int = 0; j < subDatas.length; j++)
				{
					var data:GLinkTextData = subDatas[j];
					var txt:GLinkText = getDescTxt(txtNum);
					txt.widthConst = 350;
					// 当前步骤才亮起， 其他步骤灰色
					if(curStep == i)
					{
						txt.filters = [];
					}
					else
					{
						txt.filters = [FilterConst.colorFilter];
					}
					if(j == 0)
					{
						// 第x步骤
						txt.setLinkText(data, "",stepNum + ":");
					}
					else// 没有x步， 但是X会右移3个字的宽度，大概是45
					{
						txt.setLinkText(data);
						txt.x = 45;
					}
					
					txt.y = txtY;
					txtY = txt.y + txt.height;
					txtNum++;
				}
			}
			delNotUse(_desc, txtNum);
			_pane.source = _descContianer;
			_pane.drawNow();
			
			//  任务目标
			txtNum = 0;
			subDatas = datas[curStep];
			if(subDatas == null && curStep > 0)
			{
				subDatas = datas[curStep - 1];
			}
			for(j = 0; j < subDatas.length; j++)
			{
				data = subDatas[j];
				txt = getTargetTxt(txtNum);
				txt.widthConst = 310;
				txt.y = txtNum*18 + 112;
				txt.setLinkText(data);
				txtNum++;
			}
			delNotUse(_target, txtNum);
			
			// 任务奖励
			_reward.updateRewards(_taskInfo.stask.rewards);
			
			// 更新放弃按钮
			updateGiveupBtn();
		}
		
		private function updateGiveupBtn():void
		{
			if(_taskInfo == null)
			{
				DisplayUtil.removeMe(_btnGiveup);
			}
			else if(_taskInfo.isCanget())//|| _taskInfo.isComplete())
			{
				DisplayUtil.removeMe(_btnGiveup);
			}
			else if(_btnGiveup.parent == null)
			{
				if(_taskInfo.isDoing())
				{
					this.addChild(_btnGiveup);
				}
				else if(_taskInfo.isFail())
				{
					this.addChild(_btnGiveup);
				}
			}
		}
		
		private function getTargetTxt(index:int):GLinkText
		{
			var res:GLinkText = _target[index];
			if(res == null)
			{
				res = ObjectPool.getObject(GLinkText);
				pushUIToDisposeVec(res);
				_target[index] = res;
				this.addChild(res); 
			}
			res.isShowNum = true;
			res.isShowFlyBoot = true;
			return res;
		}
		
		private function getDescTxt(index:int):GLinkText
		{
			var res:GLinkText = _desc[index];
			if(res == null)
			{
				res = ObjectPool.getObject(GLinkText);
				pushUIToDisposeVec(res);
				_desc[index] = res;
				res.isShowFlyBoot = false;
				res.isShowNum = false;
				_descContianer.addChild(res); 
			}
			return res;
		}
		
		private function delNotUse(arr:Array, usedNum:int):void
		{
			if(arr.length <= usedNum)
			{
				return;
			}
			var tmp:int = usedNum;
			for(var i:int = usedNum; i < arr.length; i++)
			{
				DisplayUtil.removeMe(arr[i] as DisplayObject);
			}
			if(tmp < i && arr.length >= tmp)
			{
				arr.splice(tmp);
			}
		}

		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_pane = UIFactory.gScrollPanel(0, 0, 370, 70, this);
			_descContianer = new GSprite();
			_reward = ObjectPool.getObject(TaskReward);
			_reward.y = 230;
			this.addChild(_reward);
			
			_desc = [];
			_target = [];
			
			_btnGiveup = UIFactory.gButton(Language.getString(20164), 307, 304, 60, 24, this);
			_btnGiveup.configEventListener(MouseEvent.CLICK, giveupHandler);
		}
		
		private function giveupHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.TaskGiveupTask, _taskInfo));
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_pane.dispose(isReuse);
			_pane = null;
			_descContianer.dispose(isReuse);
			_descContianer = null;
			
			_reward.dispose(isReuse);
			_reward = null;
			
			_btnGiveup.dispose(isReuse);
			_btnGiveup = null;
			
			_taskInfo = null;
			_desc = null;
			_target = null;
		}
	}
}