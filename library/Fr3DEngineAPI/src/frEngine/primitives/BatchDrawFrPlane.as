package frEngine.primitives
{
	import flash.geom.Vector3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	
	import frEngine.core.FrSurface3D;
	import frEngine.shader.filters.FilterName_ID;
	
	public class BatchDrawFrPlane extends Mesh3D 
	{
		
		private var _width:Number;
		private var _height:Number;
		private var _segments:int;
		private var _axis:String;
		private static var  batchSurface:FrSurface3D
		public function BatchDrawFrPlane(_arg1:String="", _arg2:Number=10, _arg3:Number=10,$renderList:RenderList=null)
		{

			super(_arg1,false,$renderList);
			this._axis = "+xy";
			this._segments = 1;
			this._height = _arg3;
			this._width = _arg2;
			
			if(!batchSurface)
			{
				createBatchSurface(0.5,0.5);
			}
			
			this.setSurface(0,batchSurface);
			
			var _local17:Number;
			_local17 = (Math.max(_arg2, _arg3) * 0.5);
			bounds = new Boundings3D();
		
			bounds.max.setTo(_local17, _local17, 0);
			bounds.min.setTo(-(_local17), -(_local17), 0);

			bounds.length = bounds.max.subtract(bounds.min);
			bounds.radius = Vector3D.distance(bounds.center, bounds.max);
		}
		private static function createBatchSurface(w:Number,h:Number):void
		{
			batchSurface= new FrSurface3D("plane");
			
			batchSurface.addVertexData(FilterName_ID.POSITION_ID,3,false,null);
			batchSurface.addVertexData(FilterName_ID.UV_ID,2,false,null);
			batchSurface.addVertexData(FilterName_ID.SKIN_INDICES_ID,1,false,null);
			var vertex:Vector.<Number>= new Vector.<Number>();
			var index:Vector.<uint>= new Vector.<uint>();
			
			var indexArr:Array=[1,2,3,	0,2,1];


			for(var i:int=0;i<20;i++)
			{
				
				vertex.push(	-w, 			-h,				0,				1, 1,i,
								w, 				-h,				0,				0, 1,i,
								-w, 			h,				0,				1, 0,i,
								w, 				h,				0,				0, 0,i);

				var baseValue:int=i*4;
				var base:int=i*6;
				for(var j:int=0;j<6;j++)
				{
					index[base+j]=baseValue+indexArr[j];	
				}
			}
			batchSurface.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector =vertex;
			batchSurface.indexVector =index;
				
			batchSurface.updateBoundings();
		}
		public function get axis():String
		{
			return (this._axis);
		}
		public function get segments():int
		{
			return (this._segments);
		}
		public function get height():Number
		{
			return (this._height);
		}
		public function get width():Number
		{
			return (this._width);
		}
		
	}
}
