package frEngine.effectEditTool.lineRoad
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Pivot3D;
	import frEngine.effectEditTool.manager.Obj3dContainer;
	import frEngine.primitives.base.LineBase;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;
	import frEngine.shape3d.BezierLine;

	public class LineRoadMesh3D extends LineBase
	{

		//private var _timeOutId:int;
		private static var _defaultCircleMaterial:ShaderBase;
		private static const _circlePool:Array=new Array();
		private var _curCircleList:Array=new Array();
		public var lineList:Vector.<BezierLine>=new Vector.<BezierLine>();
		private var _selectedCircle:LineCirle;
		private var _prePos:Vector3D=new Vector3D();
		private var _preRot:Vector3D=new Vector3D();
		private var totalCacheNum:int=0;
		private var posCache:Vector.<Vector3D>;
		private var transformCache:Vector.<Matrix3D>;
		private static const defaultPoint:Vector3D=new Vector3D();
		private static const defaultMatrix3d:Matrix3D=new Matrix3D();
		
		public function LineRoadMesh3D($renderList:RenderList)
		{
			super(null,false,$renderList);
		}
		
		
		public function drawLine():void
		{
			download(false);
			drawInstance.clear();
			drawInstance.lineStyle(1, 0xffffff, 1);
			
			var _result:Vector3D=new Vector3D();
			var lineLen:int=lineList.length;
			for(var i:int=0;i<lineLen;i++)
			{
				var bezeLine:BezierLine=lineList[i];
				if(bezeLine.isStart)
				{
					drawInstance.moveTo(bezeLine.P0.x, bezeLine.P0.y, bezeLine.P0.z);
				}
				var num:int=bezeLine.total_length/5;
				for(var j:int=1;j<=num;j++)
				{
					bezeLine.beze(j/num,_result);
					drawInstance.lineTo(_result.x, _result.y, _result.z);
				}
				
			}
		}
		
		public function showCircle():void
		{
			clearAllCircle();
			var len:int=lineList.length;
			if(len==0)
			{
				return;
			}
			var circle3d:LineCirle;
			var preLine:BezierLine;
			var curLine:BezierLine
			for(var i:int=0;i<len;i++)
			{
				
				curLine=lineList[i];
				
				if(curLine.isStart)
				{
					preLine=curLine;
					circle3d=LineRoadMesh3D.createCircle(this,preLine.P0,null,preLine.P1);
					_curCircleList.push(circle3d);
					i++;
					curLine=lineList[i];
				}

				circle3d=LineRoadMesh3D.createCircle(this,preLine.P3,preLine.P2,curLine.P1);
				_curCircleList.push(circle3d);
				
				if(i==len-1 || lineList[i+1].isStart)
				{
					circle3d=LineRoadMesh3D.createCircle(this,curLine.P3,curLine.P2,null);
					_curCircleList.push(circle3d);
				}
				
				preLine=curLine;
				
			}
			
		}
		public function initLine(unitList:Array,totalLinesLen:Number):void
		{

			var len:int=unitList.length;
			
			lineList.length=0;
			
			var totalLen:Number=0;

			for(var i:int=0;i<len;i++)
			{
				var lineInfo:Object=unitList[i];
				var linePoints:Array=lineInfo.pointsList;
				var isClosed:Boolean=lineInfo.isClosed;
				var len2:int=linePoints.length;
				var _pre:Object=linePoints[0];
				var bezeLine:BezierLine;
				for(var j:int=1;j<len2;j++)
				{
					var cur:Object=linePoints[j];
					bezeLine=new BezierLine(_pre.pos,_pre.outPos,cur.inPos,cur.pos,cur.len);
					if(j==1)
					{
						bezeLine.isStart=true;
					}
					lineList.push(bezeLine);
					bezeLine.startTime=totalLen/totalLinesLen;
					bezeLine.disTime=bezeLine.total_length/totalLinesLen;
					totalLen+=bezeLine.total_length;
					_pre=cur;
				}
				if(isClosed)
				{
					cur=linePoints[0];
					bezeLine=new BezierLine(_pre.pos,_pre.outPos,linePoints[0].inPos,cur.pos,cur.len);
					lineList.push(bezeLine);
					bezeLine.startTime=totalLen/totalLinesLen;
					bezeLine.disTime=bezeLine.total_length/totalLinesLen;
					totalLen+=bezeLine.total_length;
				}
				
			}	
			totalCacheNum=int(totalLen/2);
			clearCache(true);
		}
		
		
		public function getPosByTime(time:Number):Vector3D
		{
			if(lineList.length==0)
			{
				return defaultPoint;
			}
			if(time<0)
			{
				time=0;
			}
			if(time>1)
			{
				time=1;
			}
			time=Math.round(time*(totalCacheNum-1));
			var result:Vector3D=posCache[time];
			if(result)
			{
				return result
			}
			var _rate:Number=time/totalCacheNum;
			result=new Vector3D(0,0,0,1);
			var index:int=fastGetInsertPos(lineList,_rate);
			var bezeLine:BezierLine=lineList[index];
			//var _t:Number=bezeLine.beze_even( (_rate-bezeLine.startTime)/bezeLine.disTime );
			var _t:Number=(_rate-bezeLine.startTime)/bezeLine.disTime;
			bezeLine.beze(_t,result);
			posCache[time]=result=this.world.transformVector(result)
			return result;
			
		}
		
		public function getMatrix3dByTime(time:Number):Matrix3D
		{
			if(lineList.length==0)
			{
				return defaultMatrix3d;
			}
			
			if(time<0)
			{
				time=0;
			}
			if(time>1)
			{
				time=1;
			}
			
			
			var _time:int=Math.round(time*(totalCacheNum-1));
			var result:Matrix3D=transformCache[_time];
			if(result)
			{
				return result
			} 
			
			var _pos:Vector3D=getPosByTime(time);
			var _direction:Vector3D
			
			if(_time==0)
			{
				_direction=getPosByTime(time+1/totalCacheNum).subtract(_pos);
			}else if(_time==totalCacheNum-1)
			{
				_direction=_pos.subtract(getPosByTime(time-1/(totalCacheNum-1)));
			}else
			{
				_direction=getPosByTime(time+1/(totalCacheNum-1)).subtract(_pos);
			}

			transformCache[_time]=result=new Matrix3D();
			
			_direction.normalize();
			
			var up:Vector3D;
			if (_direction.x == 0 && Math.abs(_direction.y) == 1 && _direction.z == 0)
			{
				up = Vector3D.Z_AXIS;
			}
			else
			{
				up = Vector3D.Y_AXIS;
			}
			
			var _left:Vector3D = up.crossProduct(_direction);
			_left.normalize();
			up = _direction.crossProduct(_left);
			_left.w=up.w=_direction.w=0;
			result.copyColumnFrom(0, _left);
			result.copyColumnFrom(1, _direction);
			result.copyColumnFrom(2, up);
			result.copyColumnFrom(3,_pos);
			return result;
		}
		
		public function clearCache(useRot:Boolean):void
		{
			posCache=new Vector.<Vector3D>(totalCacheNum,true);
			if(useRot)
			{
				transformCache=new Vector.<Matrix3D>(totalCacheNum,true);
			}
			
		}
		
		public function fastGetInsertPos(targetList:Vector.<BezierLine>,targetValue:Number):int
		{
			var _end:int = targetList.length;
			var _start:int=0;
			var _cur:int=-1;
			while (_start < _end)
			{
				_cur = ((_start + _end) >>> 1);
				var _curValue:Number=targetList[_cur].startTime;
				if (_curValue == targetValue)
				{
					return _cur;
				}
				if ((targetValue > _curValue))
				{
					_start = ++_cur;
				}
				else
				{
					_end = _cur;
				}
				
			}
			return _cur-1;
		}
		private static function createCircle($box:Pivot3D,$pos:Object,$in:Object,$out:Object):LineCirle
		{
			var circle3d:LineCirle;
			if(_circlePool.length==0)
			{
				circle3d=new LineCirle(defaultCircleMaterial);
			}else
			{
				circle3d=_circlePool.shift();
			}
			
			

			circle3d.initParent($box,$pos,$in,$out);

			return circle3d;
		}
		
		private static function get defaultCircleMaterial():ShaderBase
		{
			if(!_defaultCircleMaterial)
			{
				_defaultCircleMaterial=new ShaderBase("LineCirleMesh3DMaterial",new TransformFilter(),new ColorFilter(0.8,0,0.8,1),null);
			}
			return _defaultCircleMaterial;
		}
	
		public function clearAllCircle():void
		{
			var len:int=this._curCircleList.length;
			var arr:Array=[];
			for(var i:int=0;i<len;i++)
			{
				var obj:LineCirle=this._curCircleList[i];
				obj.clear();
				_circlePool.push(obj);
				delete Obj3dContainer.sceneObjectsList[obj];
			}
			_curCircleList.length=0;
		}
		public override function dispose(isReuse:Boolean=true):void
		{
			clearAllCircle();
			super.dispose(isReuse);
			
		}
	}
}