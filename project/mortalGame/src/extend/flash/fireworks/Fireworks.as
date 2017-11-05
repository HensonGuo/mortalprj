package extend.flash.fireworks
{
	import com.gengine.global.Global;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.SWFInfo;
	import com.gengine.utils.MathUitl;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mortal.common.sound.SoundManager;
	import mortal.common.sound.SoundTypeConst;
	import mortal.game.Game;
	import mortal.game.resource.info.SkillModelInfo;
	import mortal.game.scene.layer.PlayerLayer;
	import mortal.game.scene.layer.SkillsLayer;
	import mortal.game.scene.player.item.SkillsPlayer;
	import mortal.game.scene.skill.SkillsUtil;
	
	/**
	 * 烟花类 
	 * @author jianglang
	 * 
	 */	
	[Event(name="playComplete", type="mx.events.Event")]
	
	public class Fireworks extends Sprite
	{
		private var _clipClass:Class;		// 烟花class类
		private var _clipInfo:Object; // 烟花资源数据
		
		private var _url:String;// 资源路径
		
		private var _delay:int = 300;   //烟花延时时间
		private var _repeatCount:int = 12;// 烟花播放次数
		private var _aryFirePoints:Array = [];//烟花播放的坐标点数组
		
		private var _consty:Number = 100;//静态位置 y 坐标
		
		public static const PLAYCOMPLETE:String = "playComplete";
		
		private var _isPlaying:Boolean = false; //是否在运行
		
		private var _p:Point;
		private var _fireType:int = 0;
		public function Fireworks( info:Object , p:Point)
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			_clipInfo = info;
			
			_url = info as String;
			_p = p;
		}
		
		/**
		 *  
		 * @param fireType  	烟花的类型，在FireWorkType里面定义
		 * @param playerType	播放的类型 ，在FirePlayType里面定义 比如顺序播放或者同时播放，如果是顺序播放的时候才需要填写第三个参数
		 * @param interval		顺序播放的时候的间隔时间
		 * 
		 */		
		public function start(fireType:int,playType:int = FirePlayType.OrderPlay,interval:int = 300):void
		{
			_delay = interval;
			_fireType = fireType;
//			LoaderManager.instance.load(_url,onDownloadCompleteHandler);
			var aryFirePoint:Array = [];
			switch(fireType)
			{
				case FireWorkType.NormalFire:
					aryFirePoint = FireWorkType.aryNormalFirePoint;
					break;
				case FireWorkType.MarryFire1:
					aryFirePoint = FireWorkType.aryMarryFirePoint1;
					break;
				case FireWorkType.MarryFire2:
					aryFirePoint = FireWorkType.aryMarryFirePoint2;
					break;
				case FireWorkType.MarryFire3:
					aryFirePoint = FireWorkType.aryMarryFirePoint3;
					break;
				case FireWorkType.MarryWeddingFire:
					aryFirePoint = FireWorkType.aryMarryWeddingFirePoint;
					break;
				case FireWorkType.MarryWeddingContinuedFire:
					aryFirePoint = FireWorkType.aryMarryWeddingContinuedFirePoint;
					break;
			}
			_aryFirePoints = aryFirePoint;
			if(playType == FirePlayType.TogetherPlay)
			{
				for each(var point:Point in aryFirePoint)
				{
					addFrieWorksAtPoint(point);
				}
			}
			else if(playType == FirePlayType.OrderPlay)
			{
				_repeatCount = aryFirePoint.length;
				startPlay();
			}
		}
		
		private function onDownloadCompleteHandler(info:SWFInfo):void
      	{
			_clipClass = info.getAssetClass("FireWorks");
      		if(_clipClass)
      		{
				startPlay();
      		}
      	}
		
		private function startPlay():void
		{
			var timer:Timer = new Timer( _delay , _repeatCount );
			timer.addEventListener(TimerEvent.TIMER,onTimerHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerCompleteHandler);
			timer.start();
		}
		
		private function onTimerHandler( event:TimerEvent ):void
		{
			var timer:Timer = event.target as Timer;
			var point:Point;
			if( timer.currentCount <= timer.repeatCount )
			{
				if(_aryFirePoints.length >= timer.currentCount)
				{
					point = _aryFirePoints[timer.currentCount - 1];
					addFireWorks(point);
				}
			}
		}
		
		private function onTimerCompleteHandler( event:TimerEvent ):void
		{
			var timer:Timer = event.target as Timer;
			timer.removeEventListener(TimerEvent.TIMER,onTimerHandler);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerCompleteHandler);
			timer.stop();
			timer = null;
			dispatchEvent(new Event(PLAYCOMPLETE) );
			destroy();
		}
		
		/**
		 * 添加一个烟花
		 * @return 
		 * 
		 */	
		private function addFireWorks(point:Point):void
		{
			addFrieWorksAtPoint(point);
		}
		
		/**
		 * 添加一个烟花效果 
		 * @param point
		 * 
		 */		
		private function addFrieWorksAtPoint(point:Point):void
		{
			var playerLayer:PlayerLayer = Game.scene.playerLayer;
			var skillLayer:SkillsLayer = Game.scene.skillsLayer;
			_p=playerLayer.localToGlobal(_p);
			_p=skillLayer.globalToLocal(_p);
			var player:SkillsPlayer = SkillsUtil.instance.createSkill(_url,new SkillModelInfo());
			player.rotation = 0;
			Game.scene.skillsLayer.fireSkill(player, _p.x+playerLayer.x + point.x,_p.y+playerLayer.y + point.y);
		}
		
		public function destroy():void
		{

		}
	}
}