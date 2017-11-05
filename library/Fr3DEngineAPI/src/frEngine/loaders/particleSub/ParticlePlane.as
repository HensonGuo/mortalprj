package frEngine.loaders.particleSub
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.utils.Matrix3DUtils;
	
	import frEngine.core.FrSurface3D;
	import frEngine.shader.filters.FilterName_ID;
	
	
	
	public class ParticlePlane extends Mesh3D
	{

		public function ParticlePlane($width:Number = 10, $height:Number = 10,$axis:String = "+xy")
		{
			super("", false, null);
			this.setSurface(0,createPlane($width,$height,1,$axis));
		}

		private static function createPlane($width:int,$height:int,$segments:int,$axis:String):FrSurface3D
		{
			var _local7:int;
			var _local8:Number;
			var _local9:Number;
			var _local10:Number;
			var _local11:Number;
			
			var _local16:FrSurface3D = new FrSurface3D("plane");
			
			_local16.addVertexData(FilterName_ID.POSITION_ID, 3, false, null);
			_local16.addVertexData(FilterName_ID.UV_ID, 2, false, null);
			var vertexVector:Vector.<Number>=_local16.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector;
			var indexVector:Vector.<uint>=_local16.indexVector;
			var _local12:Matrix3D = new Matrix3D();
			if ($axis == "+xy")
			{
				Matrix3DUtils.setOrientation(_local12, new Vector3D(0, 0, -1));
			}
			else
			{
				if ($axis == "-xy")
				{
					Matrix3DUtils.setOrientation(_local12, new Vector3D(0, 0, 1));
				}
				else
				{
					if ($axis == "+xz")
					{
						Matrix3DUtils.setOrientation(_local12, new Vector3D(0, 1, 0));
						//_local12.appendRotation(90,Vector3D.Y_AXIS);
					}
					else
					{
						if ($axis == "-xz")
						{
							Matrix3DUtils.setOrientation(_local12, new Vector3D(0, -1, 0));
							//_local12.appendRotation(90,Vector3D.Y_AXIS);
						}
						else
						{
							if ($axis == "+yz")
							{
								Matrix3DUtils.setOrientation(_local12, new Vector3D(1, 0, 0));
							}
							else
							{
								if ($axis == "-yz")
								{
									Matrix3DUtils.setOrientation(_local12, new Vector3D(-1, 0, 0));
								}
								else
								{
									Matrix3DUtils.setOrientation(_local12, new Vector3D(0, 0, -1));
								}
								
							}
							
						}
						
					}
					
				}
				
			}
			
			Matrix3DUtils.setScale(_local12, $width, $height, 1);
			var _local13:Vector.<Number> = _local12.rawData;
			var _local14:Vector3D = Matrix3DUtils.getDir(_local12);
			
			_local7 = 0;
			_local9 = 0;
			while (_local9 <= $segments)
			{
				_local8 = 0;
				while (_local8 <= $segments)
				{
					_local10 = ((_local8 / $segments) - 0.5);
					_local11 = ((_local9 / $segments) - 0.5);
					vertexVector.push(
						_local10 * _local13[0] + _local11 * _local13[4] + _local13[12],
						_local10 * _local13[1] + _local11 * _local13[5] + _local13[13], 
						_local10 * _local13[2] + _local11 * _local13[6] + _local13[14],
						1-_local8 / $segments,1- _local9 / $segments 
					);
					_local7++;
					_local8++;
				}
				
				_local9++;
			}
			
			_local7 = 0;
			_local9 = 0;
			while (_local9 < $segments)
			{
				_local8 = 0;
				while (_local8 < $segments)
				{
					
					indexVector[_local7++] = ((_local8 + 1) + (_local9 * ($segments + 1)));
					
					indexVector[_local7++] = ((_local8 + 1) + ((_local9 + 1) * ($segments + 1)));
					
					indexVector[_local7++] = (_local8 + ((_local9 + 1) * ($segments + 1)));
					
					indexVector[_local7++] = (_local8 + (_local9 * ($segments + 1)));
					
					indexVector[_local7++] = ((_local8 + 1) + (_local9 * ($segments + 1)));
					
					indexVector[_local7++] = (_local8 + ((_local9 + 1) * ($segments + 1)));
					
					_local8++;
				}
				
				_local9++;
			}
			return _local16;
		}
		
	}
}

