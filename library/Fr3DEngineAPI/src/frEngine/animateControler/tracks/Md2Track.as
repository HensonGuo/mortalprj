package frEngine.animateControler.tracks
{
	import flash.utils.Dictionary;
	
	import baseEngine.core.Label3D;
	import baseEngine.core.Mesh3D;
	
	import frEngine.animateControler.keyframe.vertexAnimate.VertexAnimateKeyFrame;
	import frEngine.core.Data3dInfo;
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.shader.filters.FilterName_ID;
	
	
	public class Md2Track extends Label3D
	{
		public var maxFrameLen:Number=0;

		public var frames:Array=new Array();

		private var _timeList:Dictionary=new Dictionary(false);

		private var _dirty:Boolean=false;
		
		public var targetMesh:Mesh3D;
		private var vertexAlphaEnabled:Boolean;
		public function Md2Track(startTime:int,endTime:int,$trackName:String,$targetMesh:Mesh3D,$vertexAlphaEnabled:Boolean,$fightOnFrame:uint)
		{
			super(startTime,endTime,$trackName,$fightOnFrame);
			targetMesh=$targetMesh;
			vertexAlphaEnabled=$vertexAlphaEnabled;
		}
		public function editTargetFrame(frameIndex:int,...params):void
		{
			var surfaceIndex:int=params[0];
			var data:Vector.<Number>=params[1];
			var persize:int=params[2];
			var offset:int=params[3];
			var format:String=params[4];
			addPostionKeyFrame(frameIndex,surfaceIndex,data,persize,offset,format);
		}
		public function update():void
		{
			if(_dirty)
			{
				_dirty=false;
				frames.sortOn("time",Array.NUMERIC);
			}
			
		}
		
		
		/**
		 * 从第0秒开始
		 */
		public function addPostionKeyFrame(frame:int,surfaceIndex:int,data:Vector.<Number>,$persize:int=4,$offset:int=0,$format:String="float4",normalVect:Vector.<Number>=null):VertexAnimateKeyFrame
		{
			if(_timeList[frame]!=null)
			{
				return _timeList[frame];
			}
			if(frame>maxFrameLen)
			{
				maxFrameLen=frame;
			}
			var datainfo:Data3dInfo=new Data3dInfo(data,$persize,$offset,$format);
			var flagName:String=trackName+frame;
			var vertexId:int=FilterName_ID.getVertexNameId(flagName);
			var _targetSurface:FrSurface3D=targetMesh.getSurface(surfaceIndex);
			
			var vertexNum:int=vertexAlphaEnabled?4:3;
			var vertexBuffer:FrVertexBuffer3D=_targetSurface.addVertexData(vertexId,vertexNum,false,datainfo);
			
			var keyframe:VertexAnimateKeyFrame //=new VertexAnimateKeyFrame(vertexBuffer.bufferIndex,vertexBuffer.bufferVoMap[vertexId].offset,frame,normalVect);
			
			if(normalVect && _targetSurface.getVertexBufferByNameId(FilterName_ID.NORMAL_ID)==null)
			{
				var vertexNormalBuffer:FrVertexBuffer3D=_targetSurface.addVertexData(FilterName_ID.NORMAL_ID,vertexNum,true,null);
				vertexNormalBuffer.vertexVector=normalVect;
				
			}
			_timeList[frame]=keyframe;
			frames.push(keyframe);
			
			_dirty=true;
			return keyframe;
		}
		private function getKeyFrame(frameIndex:int):VertexAnimateKeyFrame
		{
			return frames[frameIndex];
			
		}
	}
}

