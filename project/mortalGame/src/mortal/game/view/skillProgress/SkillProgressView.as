/**
 * @heartspeak
 * 2014-2-25 
 */   	

package mortal.game.view.skillProgress
{
	import Message.DB.Tables.TSkill;
	
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.mui.utils.UICompomentPool;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.view.common.BaseProgressBar;
	import mortal.mvc.core.View;
	
	public class SkillProgressView extends View
	{
		protected var progress:BaseProgressBar;
		protected var _timer:FrameTimer;
		protected var _repeatTime:int = 0;
		protected var _totalTime:int = 0;
		protected var _callback:Function;
		
		public function SkillProgressView()
		{
			super();
			this.layer = LayerManager.uiLayer;
		}
		
		private static var _instance:SkillProgressView;
		
		public static function get instance():SkillProgressView
		{
			if(!_instance)
			{
				_instance = new SkillProgressView();
				_instance.stageResize();
			}
			return _instance;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			progress = UICompomentPool.getUICompoment(BaseProgressBar);
			progress.setProgress(ImagesConst.MountProgressBar,false,28,25,153,11);
			progress.setBg(ImagesConst.MountProgressBarBg,false,210,51);
			progress.setLabel(BaseProgressBar.ProgressBarTextNone);
			progress.setValue(0,100);
			this.addChild(progress);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			progress.dispose(isReuse);
			progress = null;
		}
		
		override public function stageResize():void
		{
			this.x = 600;
			this.y = SceneRange.display.height - 170;
		}
		
		public function startByTotalTime(totalTime:int, callback:Function=null):void
		{
			_callback = callback;
			if(!_timer)
			{
				_timer = new FrameTimer();
				_timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
			}
			_timer.start();
			_repeatTime = 0;
			_totalTime = totalTime;
			this.show();
		}
		
		/**
		 * 开始读条 
		 * @param skill
		 * 
		 */		
		public function start(skill:TSkill):void
		{
			if(!_timer)
			{
				_timer = new FrameTimer();
				_timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
			}
			_timer.start();
			_repeatTime = 0;
			if(skill.useTime > 0)
			{
				_totalTime = skill.useTime;
			}
			else
			{
				_totalTime = skill.leadTime;
			}
			this.show();
		}
		
		protected function onEnterFrame(timer:FrameTimer):void
		{
			_repeatTime += timer.interval;
			if(_repeatTime > _totalTime)
			{
				_totalTime = _totalTime;
				if(_callback != null)
				{
					_callback.apply();
					_callback = null;
				}
			}
			progress.setValue(_repeatTime,_totalTime);
		}
		
		/**
		 * 更新读条 
		 * @param skill
		 * @param count
		 * 
		 */		
		public function updateCount(skill:TSkill,count:int):void
		{
			if(count == -1 || skill.leadCount == count || skill.leadCount == 0)
			{
				this.hide();
				_timer.stop();
			}
		}
	}
}