package frEngine.animateControler.colorControler
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Label3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.BezierVo;
	import frEngine.math.FrMathUtil;
	import frEngine.shader.MaterialParams;
	
	public class ColorControler extends MeshAnimateBase
	{
		protected static const vectorR:Vector3D=new Vector3D();
		protected static const vectorG:Vector3D=new Vector3D();
		protected static const vectorB:Vector3D=new Vector3D();
		
		private static const defaultOffsetValue:ColorKeyFrame=new ColorKeyFrame(0,0,null);
		private var _targetMeshMP:MaterialParams;
		public function ColorControler()
		{
			super();
		}

		protected override function setMaterialHander(e:Event):void
		{
			_targetMeshMP.colorAnimUse=true;
			super.setMaterialHander(e);
		}
		
		public override function  dispose():void
		{
			super.dispose();
			_targetMeshMP.colorOffset[0] = 1;
			_targetMeshMP.colorOffset[1] = 1;
			_targetMeshMP.colorOffset[2] = 1;
			_targetMeshMP.colorAnimUse=false;
			_targetMeshMP=null;
		}
		public override function set targetObject3d(value:Pivot3D):void
		{
			if(value)
			{
				_targetMeshMP=Mesh3D(value).materialPrams;
			}
			super.targetObject3d=value;
		}
		protected override function setTargetProperty(value:*):void
		{
			var colorKeyFrame:ColorKeyFrame = value as ColorKeyFrame;
			
			_targetMeshMP.colorOffset[0] = colorKeyFrame.colorOffsetR;
			_targetMeshMP.colorOffset[1] = colorKeyFrame.colorOffsetG;
			_targetMeshMP.colorOffset[2] = colorKeyFrame.colorOffsetB;

		}
		
		
		public override function get type():int
		{
			return AnimateControlerType.colorAnimateControler;
		}
		
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return defaultOffsetValue;
		}
		
		public override function offsetKeyFrame(track:Object,startKeyFrame:int, offsetNum:int, attribute:String):void
		{
			return;
		}
		
		override protected function calculateFrameValue(tframe:int):void
		{
			var index:int = getTimeIndex(tframe, _keyframes);
			var m1:ColorKeyFrame = _keyframes[index];
			if (m1.frame == tframe || index == _keyframes.length-1)
			{
				_cache[tframe] = m1;
			}
			else
			{
				
				var m2:ColorKeyFrame = _keyframes[index + 1];

				var startFrame:int=m1.frame;
				var endFrame:int=m2.frame;
				var useLine:Boolean=(m1.bezierVo.isLineTween || m2.bezierVo.isLineTween)
				var calframe:int = tframe + 2 + int(Math.random() * 30);//提前计算的帧数，（帧数从30帧中随机取值)
				calframe > endFrame && (calframe = endFrame);
				var i:int,insetValue:ColorKeyFrame;
				if(useLine)
				{
					var disFrame:uint=endFrame-startFrame
					var scaleValueR:Number=(m2.colorOffsetR-m1.colorOffsetR)/disFrame;
					var scaleValueG:Number=(m2.colorOffsetG-m1.colorOffsetG)/disFrame;
					var scaleValueB:Number=(m2.colorOffsetB-m1.colorOffsetB)/disFrame;
					for (i = tframe; i < calframe; i++)
					{
						if (!_cache[i])
						{
							insetValue = new ColorKeyFrame(i,-1,null);
							insetValue.colorOffsetR= m1.colorOffsetR+(i-startFrame)*scaleValueR;
							insetValue.colorOffsetG= m1.colorOffsetG+(i-startFrame)*scaleValueG;
							insetValue.colorOffsetB= m1.colorOffsetB+(i-startFrame)*scaleValueB;
							_cache[i] = insetValue
						}
					}
				}else
				{
					FrMathUtil.getBezierData(startFrame,endFrame,startFrame+m1.bezierVo.RX,endFrame+m2.bezierVo.LX,vectorX);
					FrMathUtil.getBezierData(m1.colorOffsetR,m2.colorOffsetR,m1.colorOffsetR+m1.bezierVo.RY,m2.colorOffsetR+m2.bezierVo.LY,vectorR);
					FrMathUtil.getBezierData(m1.colorOffsetG,m2.colorOffsetG,m1.colorOffsetG+m1.bezierVo.RY,m2.colorOffsetG+m2.bezierVo.LY,vectorG);
					FrMathUtil.getBezierData(m1.colorOffsetB,m2.colorOffsetB,m1.colorOffsetB+m1.bezierVo.RY,m2.colorOffsetB+m2.bezierVo.LY,vectorB);
					for(i=tframe;i<calframe;i++)
					{
						if(!_cache[i])
						{
							var t:Number=FrMathUtil.getBezierTimeAndValue(i,vectorX,null); 
							var t2:Number=t*t;
							var t3:Number=t2*t;
							insetValue = new ColorKeyFrame(i,-1,null);
							insetValue.colorOffsetR= vectorR.x*t3+vectorR.y*t2+vectorR.z*t+vectorR.w;
							insetValue.colorOffsetG= vectorG.x*t3+vectorG.y*t2+vectorG.z*t+vectorG.w;
							insetValue.colorOffsetB= vectorB.x*t3+vectorB.y*t2+vectorB.z*t+vectorB.w;
							_cache[i] = insetValue
						}
					}
				}
			}
		}
		
		public override function parserKeyFrames(keyFrames:Object):void
		{
			var len:int = keyFrames.length;
			var keyframe:ColorKeyFrame;
			for (var i:int = 0; i < len; i++)
			{
				var obj:Object = keyFrames[i];
				var islineTween:Boolean=obj.isLineTween==null?true:obj.isLineTween;
				var bezier:BezierVo=new BezierVo(obj.LX,obj.LY,obj.RX,obj.RY,islineTween);
				var index:int = obj.index;
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
				keyframe = new ColorKeyFrame(index, value, bezier);
				_keyframes.push(keyframe);
			}
			_keyframes.sortOn("frame", Array.NUMERIC);
			this.setPlayLable(this.defaultLable);
			this.defaultLable.change(0, _keyframes[len-1].frame);
			_cache.length = 0;
		}
		
		public override function editKeyFrame(track:Object, keyIndex:int, attribute:String, value:*,bezierVo:BezierVo):Object
		{
			var lable:Label3D = track is String ? this.getLabel(String(track)) : Label3D(track);
			if (lable.to < keyIndex)
			{
				lable.change(lable.from, keyIndex);
			}
			var placeId:int = getKeyFramePlaceByFrameIndex(keyIndex, this._keyframes);
			var keyframe:ColorKeyFrame;
			if (placeId == -1)
			{
				keyframe = new ColorKeyFrame(keyIndex,value,bezierVo);
				_keyframes.push(keyframe);
				_keyframes.sortOn("frame",Array.NUMERIC);
			}
			else
			{
				keyframe = _keyframes[placeId];
				keyframe.bezierVo=bezierVo;
			}
			
			keyframe.colorOffsetR=(value>>16 & 0xff)/255;
			keyframe.colorOffsetG=(value>>8 & 0xff)/255;
			keyframe.colorOffsetB=(value & 0xff)/255;

			_cache.length=0;
			
			return keyframe;
		}
	}
}