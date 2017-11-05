package frEngine.primitives
{
	import flash.geom.Vector3D;
	
	import __AS3__.vec.Vector;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Surface3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	
	import frEngine.core.FrSurface3D;
	import frEngine.shader.filters.FilterName_ID;
	
	public class FrSphere extends Mesh3D 
	{
		
		private var _vertexCount:int;
		private var _radius:Number;
		private var _segments:int;
		
		public function FrSphere($name:String,$renderList:RenderList, $radius:Number=5, $segments:int=24, _arg4:Material3D=null)
		{
			var _local6:int;
			var _local7:Number;
			var _local8:Number;
			var _local9:Number;
			var _local10:Number;
			var _local11:Number;

			super($name,false,$renderList);
			this._segments = $segments;
			this._radius = $radius;
			
			var _local5:FrSurface3D = new FrSurface3D(($name + "_surface"));
			_local5.addVertexData(FilterName_ID.POSITION_ID,3,false,null);
			_local5.addVertexData(FilterName_ID.NORMAL_ID,3,false,null);
			_local5.addVertexData(FilterName_ID.UV_ID,2,false,null);
			_local5.indexVector = new Vector.<uint>();
			this.addSurface(_local5);
			var vertexVector:Vector.<Number>=_local5.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector;
			var indexVector:Vector.<uint>=_local5.indexVector;
			var _local12:Vector3D = new Vector3D();
			var _local13:int = $segments;
			var _local14:int = ($segments + 1);
			_local6 = 0;
			_local8 = 0;
			while (_local8 <= _local14)
			{
				_local7 = 0;
				while (_local7 <= _local13)
				{
					_local10 = (-(Math.cos(((_local8 / _local14) * Math.PI))) * $radius);
					_local9 = ((Math.cos((((_local7 / _local13) * Math.PI) * 2)) * $radius) * Math.sin(((_local8 / _local14) * Math.PI)));
					_local11 = ((-(Math.sin((((_local7 / _local13) * Math.PI) * 2))) * $radius) * Math.sin(((_local8 / _local14) * Math.PI)));
					_local12.x = _local9;
					_local12.y = _local10;
					_local12.z = _local11;
					_local12.normalize();
					vertexVector.push(_local9, _local10, _local11, _local12.x, _local12.y, _local12.z, (1 - (_local7 / $segments)), (1 - (_local8 / $segments)));
					_local6++;
					_local7++;
				};
				_local8++;
			};
			_local6 = 0;
			_local8 = 0;
			while (_local8 < _local14)
			{
				_local7 = 0;
				while (_local7 < _local13)
				{
					indexVector[_local6++] = (_local7 + (_local8 * (_local13 + 1)));
					indexVector[_local6++] = ((_local7 + 1) + (_local8 * (_local13 + 1)));
					indexVector[_local6++] = (_local7 + ((_local8 + 1) * (_local13 + 1)));
					indexVector[_local6++] = ((_local7 + 1) + (_local8 * (_local13 + 1)));
					indexVector[_local6++] = ((_local7 + 1) + ((_local8 + 1) * (_local13 + 1)));
					indexVector[_local6++] = (_local7 + ((_local8 + 1) * (_local13 + 1)));
					_local7++;
				};
				_local8++;
			};
			this._vertexCount = ((_local13 + 1) * (_local14 + 1));
			_arg4 && this.setMaterial(_arg4,Texture3D.MIP_NONE,_arg4.name);
			
			_local5.updateBoundings();
			
			bounds = new Boundings3D();
			bounds.max.setTo($radius, $radius, $radius);
			bounds.min.setTo(-($radius), -($radius), -($radius));
			bounds.length = bounds.max.subtract(bounds.min);
			bounds.radius = ($radius * 2);
		}
		public function get radius():Number
		{
			return (this._radius);
		}
		public function get segments():int
		{
			return (this._segments);
		}
		
	}
}

//package flare.primitives

