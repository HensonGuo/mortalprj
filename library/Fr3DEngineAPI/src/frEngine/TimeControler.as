package frEngine
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import baseEngine.system.Device3D;

	public class TimeControler
	{
		public static const instanceList:Dictionary=new Dictionary(false);
		private var _offFrame:int=0;
		public var curFrame:int=0;

		public static var stageFrame:uint=0;
		public static var stageTime:Number=0;
		public static var minFpsTime:Number=10;
		public var _totalframe:int=1;
		
		public var duringFrame:Number=Number.MAX_VALUE;
		
		public var id:Object;
		
		public var autoPlay:Boolean=true;
		
		private static var _timeId:int=0;

		private var childrent:Vector.<TimeControler>=new Vector.<TimeControler>();
		
		private var _parent:TimeControler;
		
		public function TimeControler($id:Object)
		{
			id=$id;
		}
		
		public function set totalframe(value:uint):void
		{
			_totalframe=value;
			for each(var p:TimeControler in childrent)
			{
				p.totalframe=_totalframe-p._offFrame;
				p.curFrame=p.totalframe%p.duringFrame;
			}
		}
		public function get parent():TimeControler
		{
			return _parent;
		}
		public function get totalframe( ):uint
		{
			return _totalframe;
		}
		public function gotoFrame($curFrame:uint,$totalFrame:uint):void
		{
			this.curFrame=$curFrame;
			this.totalframe=$totalFrame;
			if(_parent)
			{
				this._offFrame=_parent.totalframe-this.totalframe;
			}else
			{
				this._offFrame=TimeControler.stageFrame-this.totalframe;
			}
			
		}
		
		/*public function updateCurrentFrame():void
		{
			var disFrame:int=TimeControler.stageFrame-this._offFrame;
			this.totalFrame=disFrame;
			this.curFrame=disFrame%this.duringFrame;
		}*/
		
		public static function upDateTime($stageTime:Number):void
		{
			
			stageTime=$stageTime;
			
			var stageframe:uint = uint(stageTime/1000 * Device3D.animateSpeedFrame);
			
			TimeControler.stageFrame =stageframe;
			
			for each(var p:TimeControler in instanceList)
			{
				if(p.autoPlay)
				{
					p.totalframe=stageframe-p._offFrame;
					p.curFrame=(p.totalframe)%p.duringFrame;
					
				}
				
			}
		}
		
		
		public static function createTimerInstance(timeId:Object=null,_parentTime:TimeControler=null):TimeControler
		{
			if(timeId==null)
			{
				timeId=_timeId;
				_timeId++;
			}
			var _timeC:TimeControler;
			
			if(_parentTime)
			{
				_timeC=new TimeControler(timeId);
				var index:int=_parentTime.childrent.indexOf(_timeC);
				if(index==-1)
				{
					_parentTime.childrent.push(_timeC);
				}
				_timeC._parent=_parentTime;
			}
			else
			{
				_timeC=instanceList[timeId];
				if(!_timeC)
				{
					instanceList[timeId]=_timeC=new TimeControler(timeId);
				}
			}
			return _timeC;
		}
		public function active():void
		{
			TimeControler.instanceList[this.id]=this;
		}
		
		public function unActive():void
		{
			if(this.id==-1)
			{
				return;
			}
			delete TimeControler.instanceList[this.id]
		}
		public static function disposeTimer($timeControler:TimeControler):void
		{
			if($timeControler.id==-1)
			{
				return;
			}
			var _childrent:Vector.<TimeControler>=$timeControler.childrent;
			
			for each(var p:TimeControler in _childrent)
			{
				p._parent=null;
			}
			$timeControler.childrent=null;
			
			$timeControler.unActive();
		}
	}
}