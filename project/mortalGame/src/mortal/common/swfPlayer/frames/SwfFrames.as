/**
 * @date	2011-4-6 下午10:08:37
 * @author  jianglang
 * 
 *  NPC 怪物 人物
 */	

package mortal.common.swfPlayer.frames
{
	import com.gengine.core.call.Caller;
	import com.gengine.debug.Log;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.resource.info.SWFInfo;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mortal.common.swfPlayer.data.ActionInfo;
	import mortal.common.swfPlayer.data.DirectionType;
	import mortal.common.swfPlayer.frames.FrameArray;
	import mortal.game.resource.FrameTypeAction;
	import mortal.game.scene3D.player.info.IModelInfo;

	public class SwfFrames
	{
		
		public static var swfUrl:Dictionary = new Dictionary();
		private var _actionFrams:Dictionary = new Dictionary();
		
		public var fireFrame:int = 2;
		private var _name:String;
		private var _frameType:String;
		
		private var _modleInfo:IModelInfo;
		
		private var _isLoaded:Boolean;
		protected var _isLoading:Boolean;
		protected var _url:String;
		
		protected var _caller:Caller;
		
		protected var _callType:String = "type";
		
		private var _referenceCount:int = 0;  //引用数量
		
		public var isInitEmptyFrames:Boolean = false;
		
		private var _key:String;
		
		private var _disposeTime:Number = 0;
		
		private var _type:int = 1;
		
		private var _pointY:Number=0;  //坐标Y点 与人物对应的 Y 坐标点
		
		private var _modleType:int; //模型类型 目前是指 坐骑类型
		
		private var _isSouthTop:Boolean = false;//是否南面 坐骑在上方
		private var _isNorthTop:Boolean = false;//是否北面 坐骑在上方
		
		private var _swfInfo:SWFInfo;
		
		private static const DisposeTime:Number = 20 * 1000; // 20S
		
		private var _loadPriority:int = LoaderPriority.LevelC;
		
		private var _modle:Object;
		
		public function get loadPriority():int
		{
			return _loadPriority;
		}

		public function set loadPriority(value:int):void
		{
			_loadPriority = value;
		}

		public function get modleType():int
		{
			return _modleType;
		}
		
		public function set modleType(value:int):void
		{
			_modleType = value;
		}

		public function get isSouthTop():Boolean
		{
			return _isSouthTop;
		}

		public function set isSouthTop(value:Boolean):void
		{
			_isSouthTop = value;
		}
		
		public function get isNorthTop():Boolean
		{
			return _isNorthTop;
		}
		
		public function set isNorthTop(value:Boolean):void
		{
			_isNorthTop = value;
		}

		public function get pointY():Number
		{
			return _pointY;
		}

		public function set pointY(value:Number):void
		{
			_pointY = value;
		}

		public function get type():int
		{
			return _type;
		}

		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}

		public function get url():String
		{
			return _url;
		}

		public function get disposeTime():Number
		{
			return _disposeTime;
		}

		public function get actionConut():int
		{
			return _actionConut;
		}
		
		public function set actionConut( value:int ):void
		{
			_actionConut = value;
		}

		public var loadCompleteHandler:Function;
		
		private var _actionConut:int;
		
		public function SwfFrames( frameType:String,name:String )
		{
			_frameType = frameType;
			_name = name;
			_caller = new Caller();
		}
		
		public function get key():String
		{
			if( _key == null )
			{
				_key = getSwfKey( name,frameType );
			}
			return _key;
		}
		
		public static function getSwfKey( name:String , frameType:String ):String
		{
			return frameType+"_"+name;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name( value:String ):void
		{
			_name = value;
		}
		
		public function set modleInfo(value:IModelInfo):void
		{
			_modleInfo = value;
		}

		public function get frameType():String
		{
			return _frameType;
		}
		
		public function set movieClip( value:MovieClip ):void
		{
			if( value == null )
			{
				if( isInitEmptyFrames == false ) return;
			}
			var tempActionAry:Array = [];
			var info:ActionInfo;
			for each( info in _actionFrams )
			{
//				if( info is FlyActionInfo == false )
//				{
					info.movieClip = value;
//				}
//				else
//				{
//					tempActionAry.push(info);
//				}
			}
//			for each( info in tempActionAry )
//			{
//				info.movieClip = value;
//			}
		}
		
		public function get movieClip():MovieClip
		{
			if( _swfInfo )
			{
				return _swfInfo.clip;
			}
			return null;
		}
		
		public function createEmptyMovieClip():void
		{
			for each( var info:ActionInfo in _actionFrams )
			{
				info.movieClip = null;
			}
		}
		
		public function removeReference():void
		{
			_referenceCount --;
			if( _referenceCount <= 0 )
			{
				//如果还没有开始加载，则从加载列表中移除
				if(_url && !_isLoaded && !_isLoading)
				{
					_isLoaded = false;
					_isLoading = false;
					LoaderManager.instance.removeNotLoadedFile(_url);
					delete swfUrl[url];
					_disposeTime = 0;
				}
				else
				{
					_disposeTime = getTimer() + DisposeTime;
				}
			}
			
			//从加载列表中移除
			if(_referenceCount <= 0)
			{
				clearFromLoad();
			}
		}
		
		public function addReference():void
		{
			if( _referenceCount < 0 )
			{
				_referenceCount = 0;
			}
			_referenceCount ++;
		}
		
		public function get referenceCount():int
		{
			return _referenceCount;
		}
		
		public function clearReferenceCount():void
		{
			_referenceCount = 1;
			removeReference();
		}
		
		/**
		 * 加载 SWF 动作文件 
		 * @param url
		 * @param onLoaded
		 * 
		 */		
		public function load(url:String,onLoaded:Function):void
		{
			addReference();
			_url = url;
			if( _isLoaded  )
			{
				if( onLoaded is Function )
				{
					onLoaded(this);
				}
				return;
			}
			if( _isLoading )
			{
				if( onLoaded is Function)
				{
					_caller.addCall( _callType,onLoaded);
				}
			}
			else
			{
//				Log.debug( "加载模型路径："+ url);
				if( onLoaded is Function)
				{
					_caller.addCall( _callType,onLoaded);
				}
				_isLoading = true;
				swfUrl[url] = true;
				LoaderManager.instance.load(url,onModelLoaded,_loadPriority);
//				LoaderManager.instance.addReference(url);
			}
		}
		
		protected function onModelLoaded( info:SWFInfo ):void
		{
			_swfInfo = info;
			_isLoaded = true;
			_isLoading = false;
			movieClip = info.clip;
			_caller.call(_callType,this);
			_caller.removeCallByType(_callType);
			if( loadCompleteHandler is Function )
			{
				loadCompleteHandler();
			}
		}
		
		public function getFrames( action:int , direction:int ):FrameArray
		{
			var info:ActionInfo = _actionFrams[action];
			if( info ) 
			{
				if( info.dir == 1 ) 
				{
					direction = DirectionType.DefaultDir;
				}
				return info.getActionDir(direction);
			}
			return null;
		}

		private function addAction( actionInfo:ActionInfo ):void
		{
			_actionFrams[actionInfo.action] = actionInfo;
		}
		
		public function getActionInfo( action:int ):ActionInfo
		{
			return _actionFrams[action];
		}
		
		public function clone():SwfFrames
		{
			var frames:SwfFrames = new SwfFrames(_frameType,_name);
			frames.createAction(_modle);
//			var tempInfo:ActionInfo;
//			for each( var info:ActionInfo in _actionFrams )
//			{
//				tempInfo = info.clone();
//				tempInfo.swf  = frames;
//				frames.addAction(tempInfo);
//			}
//			frames.actionConut = _actionConut;
//			frames.pointY = pointY;
//			frames.isSouthTop = isSouthTop;
//			frames.fireFrame = fireFrame;
//			frames.modleType = modleType;
//			frames.isInitEmptyFrames = isInitEmptyFrames;
			return frames;
		}
		
		/**
		 * 创建SWF配置文件动作 
		 * @param modle
		 * 
		 */		
		public function createAction( modle:Object ):void
		{
			_modle = modle;
			var actionObject:Object;
			var actionInfo:ActionInfo;
			this.fireFrame = modle.fireFrame;
			_type = modle.type;
			isInitEmptyFrames = modle.isInitEmptyFrames;
			if( modle.action is Array )
			{
				var ary:Array = modle.action as Array;
				_actionConut = ary.length;
				for each(actionObject in ary )
				{
					actionInfo = new ActionInfo( actionObject.type,actionObject.startFrame,actionObject.endFrame,actionObject.frameRate,actionObject.delay,actionObject.dir );
					actionInfo.isInitEmptyFrames = actionObject.isInitEmptyFrames;
					actionInfo.swf = this;
					this.addAction(actionInfo);
					_actionConut ++;
				}
				
//				if( frameType == "user" )
//				{
//					//休息动作 作为 坐骑动作copy
//					actionInfo = this.getActionInfo(ActionType.Rest);
//					createMountFrames(MountActionInfo.RestMountFrame,ActionType.RestMountStand,actionInfo);
//					createMountFrames(MountActionInfo.RestMountFrame,ActionType.RestMountWalk,actionInfo);
//					
//					//飞行动作 作为 坐骑动作copy
//					actionInfo = this.getActionInfo(ActionType.Stand);
//					createMountFrames(MountActionInfo.FlyMountFrame,ActionType.flyMountStand,actionInfo);
//					createMountFrames(MountActionInfo.FlyMountFrame,ActionType.flyMountWalk,actionInfo);
//				}
			}
			else
			{
				actionObject = modle.action;
				actionInfo = new ActionInfo( actionObject.type,actionObject.startFrame,actionObject.endFrame,actionObject.frameRate,actionObject.delay,actionObject.dir );
				actionInfo.isInitEmptyFrames = actionObject.isInitEmptyFrames;
				actionInfo.swf = this;
				this.addAction(actionInfo);
				_actionConut = 1;
			}
		}
		/**
		 *  
		 * @param flyAction  飞行动作
		 * @param action     对应的飞行动作
		 * @param actionInfo 实际显示动作
		 * 
		 */		
//		private function createFlyMountFrames(flyAction:int, action:int,copyActionInfo:ActionInfo ):void
//		{
//			var actionInfo:ActionInfo = this.getActionInfo(action);
//			var flyActionInfo:FlyActionInfo = new FlyActionInfo( flyAction,actionInfo.startFrame,actionInfo.endFrame,actionInfo.frameRate,actionInfo.delay,actionInfo.dir );
//			flyActionInfo.copyAction = copyActionInfo;
//			flyActionInfo.isInitEmptyFrames = actionInfo.isInitEmptyFrames;
//			flyActionInfo.swf = this;
//			this.addAction(flyActionInfo);
//		}
		
//		private function createMountFrames( mountName:String,mountAction:int,copyActionInfo:ActionInfo ):void
//		{
//			var mountInfo:ActionInfo = FrameTypeAction.instance.getActionInfo(mountName,mountAction);
//			var flyActionInfo:MountActionInfo = new MountActionInfo(mountAction,mountInfo.startFrame,mountInfo.endFrame,mountInfo.frameRate,mountInfo.delay,mountInfo.dir );
//			flyActionInfo.copyAction = copyActionInfo;
//			flyActionInfo.mountActionInfo = mountInfo;
//			flyActionInfo.isInitEmptyFrames = mountInfo.isInitEmptyFrames;
//			flyActionInfo.swf = this;
//			this.addAction(flyActionInfo);
//		}
		
		public function dispose():void
		{
			if( isClear == false ) return;
//			Log.debug("disposeFile:"+_url); 
			_referenceCount = -1;
			_isLoaded = false;
			_isLoading = false;
			clearFromLoad();
			for each( var actionInfo:ActionInfo in _actionFrams )
			{
				actionInfo.dispose();
			}
			delete swfUrl[url];
			if( _swfInfo )
			{
				_swfInfo.dispose();
			}
		}
		
		/**
		 * 清除加载相关 
		 * 
		 */		
		private function clearFromLoad():void
		{
//			_isLoaded = false;
//			_isLoading = false;
//			LoaderManager.instance.removeReference(url);
		}
		
		public static function traceUrl():void
		{
			var str:String = "";
			for( var key:* in swfUrl  )
			{
				str += key+"|";
			}
			Log.debug("未销毁的swfUrl:"+str);
		}
		
		public static function isDispose( url:String ):Boolean
		{
			return url in swfUrl;
		}
		
		public var isClear:Boolean = true;
	}
}
