


//flare.primitives.Cone

package frEngine.primitives
{
	import flash.geom.Vector3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Surface3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	
	import frEngine.core.FrSurface3D;
	import frEngine.shader.filters.FilterName_ID;

	public class Cone extends Mesh3D
	{

		private var _radius1:Number;
		private var _radius2:Number;
		private var _height:Number;
		private var _segments:int;

		public function Cone(_arg1:String,$renderList:RenderList, $radius1:Number = 5, _radius2:Number = 0, $height:Number = 10, $segments:int = 12, _arg6:Material3D = null)
		{
			var _local8:int;
			var _local9:int;
			var _local10:Number;
			var _local11:Number;
			var _local12:Number;
			var _local13:Number;
			var _local16:int;
			var _local17:int;
			var _local18:Surface3D;
			var _local19:Number;
			super(_arg1, true,$renderList);
			this._segments = $segments;
			this._height = $height;
			this._radius2 = _radius2;
			this._radius1 = $radius1;

			var surface:FrSurface3D = new FrSurface3D("cone");
			this.addSurface(surface);
			surface.addVertexData(FilterName_ID.POSITION_ID, 3, false, null);
			surface.addVertexData(FilterName_ID.NORMAL_ID, 3, false, null);
			surface.addVertexData(FilterName_ID.UV_ID, 2, false, null);
			var _vertexVector:Vector.<Number>= new Vector.<Number>();
			surface.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector=_vertexVector;
			surface.indexVector = new Vector.<uint>();
			var _local14:Vector3D = new Vector3D();
			var _local15:int = $segments;
			_local10 = 0;
			while (_local10 <= _local15)
			{
				_local12 = 0;
				_local11 = Math.cos((((_local10 / _local15) * Math.PI) * 2));
				_local13 = -(Math.sin((((_local10 / _local15) * Math.PI) * 2)));
				_local14.x = _local11;
				_local14.y = (($radius1 - _radius2) / $height);
				_local14.z = _local13;
				_local14.normalize();
				_vertexVector.push((_local11 * $radius1), 0, (_local13 * $radius1), _local14.x, _local14.y, _local14.z, (_local10 / $segments), 1);
				_vertexVector.push((_local11 * _radius2), $height, (_local13 * _radius2), _local14.x, _local14.y, _local14.z, (_local10 / $segments), 0);
				_local8++;
				_local10++;
			}
			;
			if ($radius1 > 0)
			{
				_local16 = (_vertexVector.length / surface.sizePerVertex);
				_local10 = 0;
				while (_local10 <= _local15)
				{
					_local11 = (Math.cos((((_local10 / _local15) * Math.PI) * 2)) * $radius1);
					_local13 = (-(Math.sin((((_local10 / _local15) * Math.PI) * 2))) * $radius1);
					_vertexVector.push(_local11, 0, _local13, 0, -1, 0, ((_local11 / this._radius1) * 0.5), ((_local13 / this._radius1) * 0.5));
					_local10++;
				}
				;
			}
			;
			if (_radius2 > 0)
			{
				_local17 = (_vertexVector.length / surface.sizePerVertex);
				_local10 = 0;
				while (_local10 <= _local15)
				{
					_local11 = (Math.cos((((_local10 / _local15) * Math.PI) * 2)) * _radius2);
					_local13 = (-(Math.sin((((_local10 / _local15) * Math.PI) * 2))) * _radius2);
					_vertexVector.push(_local11, $height, _local13, 0, 1, 0, ((_local11 / this._radius2) * 0.5), ((_local13 / this._radius2) * 0.5));
					_local10++;
				}
				;
			}
			;
			_local8 = 0;
			_local10 = 0;
			var _indexVector:Vector.<uint>=surface.indexVector;
			while (_local10 < _local15)
			{
				surface.indexVector[_local8++] = ((_local10 * 2) + 2);
				_indexVector[_local8++] = ((_local10 * 2) + 1);
				_indexVector[_local8++] = (_local10 * 2);
				_indexVector[_local8++] = ((_local10 * 2) + 2);
				_indexVector[_local8++] = ((_local10 * 2) + 3);
				_indexVector[_local8++] = ((_local10 * 2) + 1);
				_local10++;
			}
			;
			if ($radius1 > 0)
			{
				_local10 = 1;
				while (_local10 < (_local15 - 1))
				{
					_indexVector[_local8++] = ((_local16 + _local10) + 1);
					_indexVector[_local8++] = (_local16 + _local10);
					_indexVector[_local8++] = _local16;
					_local10++;
				}
				;
			}
			;
			if (_radius2 > 0)
			{
				_local10 = 1;
				while (_local10 < (_local15 - 1))
				{
					_indexVector[_local8++] = _local17;
					_indexVector[_local8++] = (_local17 + _local10);
					_indexVector[_local8++] = ((_local17 + _local10) + 1);
					_local10++;
				}
				;
			}
			if(_arg6)
			{
				this.setMaterial(_arg6,Texture3D.MIP_NONE,_arg6.name);
			}
			


			surface.updateBoundings();

			_local19 = Math.max($radius1, _radius2);
			bounds = new Boundings3D();
			bounds.center.y = ($height * 0.5);
			bounds.max.setTo(_local19, $height, _local19);
			bounds.min.setTo(-(_local19), 0, -(_local19));
			bounds.length = bounds.max.subtract(bounds.min);
			bounds.radius = Vector3D.distance(bounds.center, bounds.max);
		}

		public function get radius1():Number
		{
			return (this._radius1);
		}

		public function get radius2():Number
		{
			return (this._radius2);
		}

		public function get height():Number
		{
			return (this._height);
		}

		public function get segments():int
		{
			return (this._segments);
		}

	}
} //package flare.primitives

