package frEngine.animateControler.particleControler
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.BezierVo;
	import frEngine.effectEditTool.lineRoad.LineRoadMesh3D;

	public class LineRoadControler extends Modifier
	{
		private static var _tempArr:Vector.<Vector3D>=new Vector.<Vector3D>(100,true);
		private var _lineRoadMesh3d:LineRoadMesh3D;
		private var _useRot:Boolean;
		public function LineRoadControler()
		{
			
		}
		
		public override function dispose():void
		{
			super.dispose();
			if(_lineRoadMesh3d)
			{
				_lineRoadMesh3d.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,updateCacheHander);
			}
			_lineRoadMesh3d=null;
			
		}
		public function init(lineRaodMesh3d:LineRoadMesh3D,useRot:Boolean):void
		{
			_lineRoadMesh3d=lineRaodMesh3d;
			_useRot=useRot;
			if(_cache[currentFrame]!=null)
			{
				setTargetProperty(_cache[currentFrame]);
			}
			if(_lineRoadMesh3d)
			{
				_lineRoadMesh3d.addEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,updateCacheHander);
			}
			
		}
		private function updateCacheHander(e:Event):void
		{
			_lineRoadMesh3d.clearCache(this._useRot);
			if(_cache[currentFrame]!=null)
			{
				setTargetProperty(_cache[currentFrame]);
			}
		}
		public override function clearCache():void
		{
			super.clearCache();
			_lineRoadMesh3d && _lineRoadMesh3d.clearCache(this._useRot);
			targetObject3d.transform.identity();
			targetObject3d.setTransform(targetObject3d.transform,false);
			
			
		}
		public override function get type():int
		{
			return AnimateControlerType.LineRoadControler;
		}
		
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return 0;
		}
		
		protected override function setTargetProperty(value:*):void
		{
			if(_lineRoadMesh3d)
			{
				if(_useRot)
				{
					var m:Matrix3D=_lineRoadMesh3d.getMatrix3dByTime(value);
					targetObject3d.world=m
				}else
				{
					var v:Vector3D=_lineRoadMesh3d.getPosByTime(value);
					targetObject3d.setPosition(v.x,v.y,v.z,false);
				}
				
			}
			
		}

		public function getMidPos(num:int):Vector.<Vector3D>
		{
			if(_lineRoadMesh3d)
			{
				var preFrame:int=this.currentFrame-1;
				preFrame<0  && (preFrame=0)
					
				if(!_cache[this.currentFrame])
				{
					calculateFrameValue(this.currentFrame);
				}
				
				var curTime:Number=_cache[this.currentFrame];
				
				if(!_cache[preFrame])
				{
					calculateFrameValue(preFrame);
				}
				
				var preTime:Number=_cache[preFrame];
				
				var disTime:Number=curTime-preTime;
				
				disTime<0 && (disTime+=1);
				
				var perTime:Number=disTime/num;

				for(var i:int=0;i<num;i++)
				{
					preTime+=perTime;
					preTime>1 && (preTime=1);
					_tempArr[i]=_lineRoadMesh3d.getPosByTime( preTime )
				}
			}
			
			return _tempArr;
		}
	}
}