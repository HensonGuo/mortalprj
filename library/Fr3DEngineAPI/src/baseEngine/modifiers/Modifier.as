


//flare.modifiers.Modifier

package baseEngine.modifiers
{
	import com.gengine.global.Global;
	
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Label3D;
	import baseEngine.core.Pivot3D;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.BezierVo;
	import frEngine.animateControler.keyframe.INodeKey;
	import frEngine.animateControler.keyframe.NodeAnimateKey;
	import frEngine.math.FrMathUtil;


	public class Modifier extends EventDispatcher
	{
		protected static const vectorX:Vector3D = new Vector3D();
		protected static const vectorY:Vector3D = new Vector3D();

		protected static const angleToPad:Number = Math.PI / 180;
		protected var _isPlaying:Boolean = false;
		protected var _defaultLable:Label3D;

		private var _currentDuring:int = 0;
		public var labels:Dictionary;
		private var _targetObject3d:Pivot3D;


		protected var _lastFrame:Number = -1;
		public var changeFrame:Boolean = false;
		
		private var frameCallbackMap:Dictionary = new Dictionary(false);
		private var _scriptLen:uint = 0;
		public var curPlayTrackName:String;
		public var cuPlayLable:Label3D;
		public var autoPlay:Boolean = true;

		protected var _currentFrame:int

		protected var _keyframes:Array = new Array();
		protected var _cache:Array = new Array();
		protected var _baseValue:*;

		public function Modifier()
		{
			this.labels = new Dictionary(false);
			super();
		}

		public function get defaultLable():Label3D
		{

			_defaultLable == null && (_defaultLable = new Label3D(0, 0, "#default#",0));

			return _defaultLable;
		}

		public function set targetObject3d(value:Pivot3D):void
		{
			if (!value && _targetObject3d)
			{
				setTargetProperty(_baseValue);
			}
			if (value && !targetObject3d)
			{
				_baseValue = getBaseValue(value);
			}
			_targetObject3d = value;
		}

		public function get type():int
		{
			return AnimateControlerType.DefaultAnimateControler;
		}

		public function get targetObject3d():Pivot3D
		{
			return _targetObject3d;
		}

		public function clone():Modifier
		{
			return (this);
		}

		protected static function getKeyFramePlaceByFrameIndex(keyIndex:int, keyFrames:Array):int
		{
			var len:int = keyFrames.length;
			for (var i:int = 0; i < len; i++)
			{
				var m:INodeKey = keyFrames[i];
				if (m.frame == keyIndex)
				{
					return i;
				}
			}
			return -1;
		}

		protected static function getTimeIndex(frame:int, keyFrames:Array):int
		{
			var len:int = keyFrames.length;
			var preTime:Number = keyFrames[0].frame;
			for (var i:int = 1; i < len; i++)
			{
				var kf:Object = keyFrames[i];
				var curTime:Number = kf.frame;
				if (curTime > frame && frame >= preTime)
				{
					return i - 1
				}
				preTime = curTime;
			}
			if (frame <= keyFrames[0].frame)
			{
				return 0;
			}
			if (frame >= keyFrames[len - 1].frame)
			{
				return len - 1;
			}
			return -1;
		}

		public function get totalFrames():int
		{
			return (this.cuPlayLable ? this.cuPlayLable.length : 0)
		}

		public function toUpdateAnimate(forceUpdate:Boolean = false):void
		{
			if (_isPlaying && cuPlayLable)
			{
				this.updateCurFrame();
			}
			else
			{
				changeFrame = false;
			}

			if (_keyframes.length == 0 || (!forceUpdate && !changeFrame))
			{
				return;
			}
			if (_cache[currentFrame] == null)
			{
				calculateFrameValue(this.currentFrame);
			}
			setTargetProperty(_cache[currentFrame]);
		}

		protected function calculateFrameValue(tframe:int):void
		{
			var index:int = getTimeIndex(tframe, _keyframes);
			var m1:NodeAnimateKey = _keyframes[index];
			var p1:Number = m1.value;
			var resultValue:Number;
			if (m1.frame == tframe || index == _keyframes.length - 1)
			{
				_cache[tframe] = p1 + _baseValue;
			}
			else
			{
				var m2:NodeAnimateKey = _keyframes[index + 1];
				var startFrame:int = m1.frame;
				var endFrame:int = m2.frame;
				var useLine:Boolean=(m1.bezierVo.isLineTween || m2.bezierVo.isLineTween)
				var calframe:int = tframe + 2 + int(Math.random() * 30);
				calframe > endFrame && (calframe = endFrame);
				var i:int;
				if(useLine)
				{
					var startValue:Number=m1.value;
					var scaleValue:Number=(m2.value-startValue)/(endFrame-startFrame);
					for (i = tframe; i < calframe; i++)
					{
						if (!_cache[i])
						{
							_cache[i] = startValue+(i-startFrame)*scaleValue + _baseValue;
						}
					}
				}else
				{
					FrMathUtil.getBezierData(startFrame, endFrame, startFrame + m1.bezierVo.RX, endFrame + m2.bezierVo.LX, vectorX);
					FrMathUtil.getBezierData(m1.value, m2.value, m1.value + m1.bezierVo.RY, m2.value + m2.bezierVo.LY, vectorY);
					for (i = tframe; i < calframe; i++)
					{
						if (!_cache[i])
						{
							_cache[i] = FrMathUtil.getBezierTimeAndValue(i, vectorX, vectorY) + _baseValue;
						}
					}
				}
			}

		}

		protected function getBaseValue(obj:Pivot3D):Object
		{
			return null;
		}

		protected function setTargetProperty(value:*):void
		{
			//throw new Error("请覆盖setTargetProperty方法！");
		}

		public function removeLabel(_arg1:Label3D):Label3D
		{
			var _local3:Pivot3D;

			delete this.labels[_arg1.trackName];
			return (_arg1);
		}

		public function getLabel(_arg1:String):Label3D
		{
			return this.labels[_arg1];
		}

		public function addLabel(_arg1:Label3D):Label3D
		{
			if (this.labels[_arg1.trackName] != null)
			{
				return this.labels[_arg1.trackName];
			}
			this.labels[_arg1.trackName] = _arg1;
			if (curPlayTrackName == _arg1.trackName)
			{
				setPlayLable(curPlayTrackName);
			}
			return (_arg1);
		}



		public function setPlayLable(label:Object, targetFrame:int = 0):Label3D
		{
			var lable:Label3D;
			if (label is String)
			{
				lable = this.labels[label];
				curPlayTrackName = String(label);
			}
			else if (label is Label3D)
			{
				lable = this.labels[label.trackName] = label;
				curPlayTrackName = lable.trackName;
			}
			if (!lable)
			{
				return null;
			}
			cuPlayLable = lable;

			_lastFrame = targetFrame - 1;
			_targetObject3d.timerContorler.gotoFrame(targetFrame, targetFrame);
			if (autoPlay)
			{
				play();
			}
			this.currentFrame = targetFrame;
			return lable;
		}

		final public function set currentFrame(value:int):void
		{
			this._currentFrame = value;
			if (this._lastFrame != _currentFrame)
			{
				var curLableScript:Dictionary = _scriptLen > 0 ? frameCallbackMap[curPlayTrackName] : null;
				if (curLableScript != null && cuPlayLable)
				{
					var len:int = _currentFrame - _lastFrame;
					var totalLen:int = cuPlayLable.length;
					if (len < 0)
					{
						len += totalLen;
					}
					
					if (len > 100)
					{
						len = 100;
					}
					
					for (var i:int = 1; i <= len; i++)
					{
						var _frame:int = (_lastFrame + i) % totalLen;
						var callBackList:Array = curLableScript[_frame]
						if (callBackList != null)
						{
							for each(var _callback:Function in callBackList)
							{
								Global.instance.callLater(_callback);
							}
							
						}
					}

				}
				changeFrame = true;
			}
			else
			{
				changeFrame = false;
			}
			this._lastFrame = _currentFrame;
		}

		final public function get currentFrame():int
		{
			return _currentFrame;
		}

		public function get isPlaying():Boolean
		{
			return (this._isPlaying);
		}

		public function addFrameScript(lableName:String, frameIndex:int, callback:Function):void
		{
			var lableScripts:Dictionary = frameCallbackMap[lableName]
			if (lableScripts == null)
			{
				frameCallbackMap[lableName] =lableScripts = new Dictionary(false);
				lableScripts.len = 0;
			}
			var callbackList:Array=lableScripts[frameIndex]
			if(callbackList==null)
			{
				lableScripts[frameIndex]=callbackList=[];
				lableScripts.len++;
			}
			if(callbackList.indexOf(callback)==-1)
			{
				callbackList.push(callback);
				_scriptLen++;
			}
			
		}

		public function removeFrameScript(lableName:String, frameIndex:int,callback:Function):void
		{
			var lableScripts:Dictionary = frameCallbackMap[lableName];
			if (lableScripts && lableScripts[frameIndex] != null)
			{
				var arr:Array=lableScripts[frameIndex];
				var index:int=arr.indexOf(callback);
				if(index!=-1)
				{
					_scriptLen--;
					arr.splice(index,1);
					if(arr.length==0)
					{
						delete lableScripts[frameIndex];
						lableScripts.len--;
						lableScripts.len < 1 && delete frameCallbackMap[lableName]
						
					}
				}
				
			}
		}

		public function removeAllFrameScript():void
		{
			frameCallbackMap = new Dictionary();
		}


		public function gotoAndPlay(_arg1:int, lableName:String = null):void
		{
			this._lastFrame = _arg1 - 1;
			if (lableName != null)
			{
				this.setPlayLable(lableName, _arg1);
			}
			else
			{
				_targetObject3d.timerContorler.gotoFrame(_arg1, _arg1);
				this.currentFrame = _arg1;
			}
			this.play();
		}

		public function gotoAndStop(_arg1:int, lableName:String = null):void
		{
			this._lastFrame = _arg1 - 1;

			if (lableName != null)
			{
				this.setPlayLable(lableName, _arg1);
			}
			else
			{
				_targetObject3d.timerContorler.gotoFrame(_arg1, _arg1);
				this.currentFrame = _arg1;
			}
			this.stop();

		}

		public function play():void
		{
			this._isPlaying = true;
		}

		public function stop():void
		{
			this._isPlaying = false;
		}

		protected function updateCurFrame():void
		{
			var disframe:Number = _targetObject3d.timerContorler.curFrame;
			var frameLen:int = cuPlayLable.length;

			var _local1:Boolean;
			if (disframe >= frameLen)
			{
				disframe = frameLen - 1;
			}
			else if (disframe < 0)
			{
				disframe = 0;
			}
			this.currentFrame = cuPlayLable.from + disframe;

		}

		public function changeBaseValue(track:Object, attributeValue:Number):void
		{
			_baseValue = attributeValue;
			_cache = new Array();
		}

		public function deleteKeyFrame(track:Object, keyIndex:int, attribute:String):void
		{

			var placeId:int = getKeyFramePlaceByFrameIndex(keyIndex, this._keyframes);
			if (placeId == -1)
			{
				return;
			}
			var keyframe:INodeKey = _keyframes[placeId];
			if (keyframe.frame == _keyframes.length - 1)
			{
				var lable:Label3D = track is String ? this.getLabel(String(track)) : Label3D(track);
				var prePlaceId:int = placeId - 1;
				prePlaceId = prePlaceId < 0 ? 0 : prePlaceId;
				var preKeyframe:NodeAnimateKey = _keyframes[prePlaceId];
				lable.change(lable.from, preKeyframe.frame);
			}
			_keyframes.splice(placeId, 1);
			_cache = new Array();
		}

		public function offsetKeyFrame(track:Object, startKeyFrame:int, offsetNum:int, attribute:String):void
		{
			var len:int = _keyframes.length;
			if (len == 0)
			{
				return;
			}
			var m:NodeAnimateKey;
			for (var i:int = startKeyFrame; i < len; i++)
			{
				m = _keyframes[i];
				m.frame += offsetNum;
			}

			if (offsetNum > 0 && startKeyFrame == 0)
			{
				editKeyFrame(track, 0, attribute, _keyframes[0].value, _keyframes[0].bezierVo);
			}
			else if (offsetNum < 0)
			{
				var deleteframeEnd:int = -1;
				for (i = 0; i < len; i++)
				{
					m = _keyframes[i];
					if (m.frame > 0)
					{
						i-1>=0 && (_keyframes[i - 1].frame = 0);
						deleteframeEnd = i - 2;
						break;
					}
				}
				for (i = 0; i <= deleteframeEnd; i++)
				{
					deleteKeyFrame(track, _keyframes[i].frame, attribute);
				}

			}
			var lable:Label3D = track is String ? this.getLabel(String(track)) : Label3D(track);
			lable.change(lable.from, lable.to + offsetNum);
			_cache = new Array();
		}

		public function get keyframes():Array
		{
			return _keyframes;
		}
		
		public function parserKeyFrames(keyFrames:Object):void
		{
			
			var len:int = keyFrames.length;
			
			var keyframe:NodeAnimateKey;
			for (var i:int = 0; i < len; i++)
			{
				var obj:Object = keyFrames[i];
				var islineTween:Boolean=obj.isLineTween==null?true:obj.isLineTween;
				var bezier:BezierVo=new BezierVo(obj.LX,obj.LY,obj.RX,obj.RY,islineTween);
				var attribute:Object = obj.attributes;
				var value:Number;
				if(attribute is Array)
				{
					value=attribute[0].value
				}else
				{
					value=Number(attribute);
				}
				isNaN(value) && (value=0); 
				keyframe = new NodeAnimateKey(obj.index, value, bezier);
				_keyframes.push(keyframe);
			}
			_keyframes.sortOn("frame", Array.NUMERIC);
			
			this.setPlayLable(this.defaultLable);
			
			this.defaultLable.change(0, _keyframes[len-1].frame);
			
			clearCache();
			
		}
		public function clearCache():void
		{
			_cache.length = 0;
		}
		public function editKeyFrame(track:Object, keyIndex:int, attribute:String, value:*, bezierVo:BezierVo):Object
		{
			var lable:Label3D = track is String ? this.getLabel(String(track)) : Label3D(track);
			if (lable.to < keyIndex)
			{
				lable.change(lable.from, keyIndex);
			}
			var placeId:int = getKeyFramePlaceByFrameIndex(keyIndex, this._keyframes);
			var keyframe:NodeAnimateKey;
			if (placeId == -1)
			{
				keyframe = new NodeAnimateKey(keyIndex, value, bezierVo);
				_keyframes.push(keyframe);
				_keyframes.sortOn("frame", Array.NUMERIC);
			}
			else
			{
				keyframe = _keyframes[placeId];
				keyframe.value = value;
				keyframe.bezierVo = bezierVo;
			}

			clearCache();

			return keyframe;
		}

		public function dispose():void
		{
			stop();
			removeAllFrameScript();
			labels = null;
			targetObject3d = null;

		}


	}
}

