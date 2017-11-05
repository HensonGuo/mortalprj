


//flare.primitives.DebugWireframe

package frEngine.primitives
{
	import flash.geom.Vector3D;
	
	import __AS3__.vec.Vector;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Poly3D;
	import baseEngine.core.Surface3D;
	
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.core.mesh.Md5Mesh;
	import frEngine.primitives.base.LineBase;
	import frEngine.shader.filters.FilterName_ID;

	public class DebugWireframe extends LineBase
	{
		private var _meshObject:*;
		public var color:uint;
		private var _alpha:Number;

		public function DebugWireframe(meshObject:* = null, color:uint = 0xFFFFFF, size:Number = 1, $renderList:RenderList=null,$name:String="debugLine")
		{
			super($name, false, $renderList);
			this._alpha = size;
			this._meshObject = meshObject;
			this.color = color;
			if(meshObject)
			{
				this.config();
			}
			
		}

		public function config():void
		{

			download();
			drawInstance.clear();
			drawInstance.lineStyle(1, this.color, this._alpha);
			var isMesh:Boolean = (this.meshObject is Mesh3D);
			if (isMesh)
			{
				var isMd5Mesh:Boolean = (this.meshObject is Md5Mesh);
				var useAnimate:Boolean = false;
				if (isMd5Mesh && useAnimate)
				{
					bounds = createSkinMeshLine();
				}
				else
				{
					bounds = createStaticMeshLine();
				}
				if (isMd5Mesh)
				{
					this.rotationY = 180;
				}

				return;
			}
			var isArray:Boolean = (this.meshObject is Array)
			if (isArray)
			{
				bounds = createRoatLine();
			}
		}

		private function createRoatLine():Boundings3D
		{
			var lineArray:Array = _meshObject as Array;
			var lineNum:int = lineArray.length;
			var curx:Number = 0;
			var cury:Number = 0;
			var curz:Number = 0;
			var maxX:Number = Number.MIN_VALUE;
			var maxY:Number = maxX;
			var maxZ:Number = maxX;
			var minX:Number = Number.MAX_VALUE;
			var minY:Number = minX;
			var minZ:Number = minX;
			for (var i:int = 0; i < lineNum; i++)
			{
				var lineData:Array = lineArray[i];
				var lineDataLen:int = lineData.length;
				var j:int = 0;
				while (j < lineDataLen)
				{
					curx = lineData[j++];
					cury = lineData[j++];
					curz = lineData[j++];
					if (j == 3)
					{
						drawInstance.moveTo(curx, cury, curz);
					}
					else
					{
						drawInstance.lineTo(curx, cury, curz);
					}

					if (maxX < curx)
					{
						maxX = curx;
					}
					else if (minX > curx)
					{
						minX = curx;
					}

					if (maxY < cury)
					{
						maxY = cury;
					}
					else if (minY > cury)
					{
						minY = cury;
					}

					if (maxZ < curz)
					{
						maxZ = curz;
					}
					else if (minZ > curz)
					{
						minZ = curz;
					}
				}
			}
			var _bounds:Boundings3D = new Boundings3D();
			_bounds.min.setTo(minX, minY, minZ);
			_bounds.max.setTo(maxX, maxY, maxZ);
			_bounds.length.x = (_bounds.max.x - _bounds.min.x);
			_bounds.length.y = (_bounds.max.y - _bounds.min.y);
			_bounds.length.z = (_bounds.max.z - _bounds.min.z);
			_bounds.center.x = ((_bounds.length.x * 0.5) + _bounds.min.x);
			_bounds.center.y = ((_bounds.length.y * 0.5) + _bounds.min.y);
			_bounds.center.z = ((_bounds.length.z * 0.5) + _bounds.min.z);
			_bounds.radius = Vector3D.distance(_bounds.center, _bounds.max);
			return null;

		}

		private function createSkinMeshLine():Boundings3D
		{
			var _mesh:Mesh3D = Mesh3D(_meshObject);
			var len:int = _mesh.getSurfacesLen();
			var _local2:FrSurface3D;
			for (var k:int = 0; k < len; k++)
			{
				_local2 = _mesh.getSurface(k);
				var firstIndex:uint = (_local2.firstIndex / 3);
				var numTriangles:int = _local2.numTriangles;
				if (numTriangles == -1)
				{
					numTriangles = (_local2.indexVector.length / 3);
				}

				numTriangles = (numTriangles + firstIndex);
				var curIndex:uint = firstIndex;
				while (curIndex < numTriangles)
				{
					var poly3d:Poly3D = _local2.polys[curIndex];
					drawInstance.moveTo(poly3d.v0.x, poly3d.v0.y, poly3d.v0.z);
					drawInstance.lineTo(poly3d.v1.x, poly3d.v1.y, poly3d.v1.z);
					drawInstance.lineTo(poly3d.v2.x, poly3d.v2.y, poly3d.v2.z);
					drawInstance.lineTo(poly3d.v0.x, poly3d.v0.y, poly3d.v0.z);
					curIndex++;
				}

			}
			return _mesh.bounds;
		}

		private function createStaticMeshLine():Boundings3D
		{
			var _local2:FrSurface3D;
			var _mesh:Mesh3D = Mesh3D(_meshObject);
			_local2 = _mesh.getSurface(0);

			var frvertexbuffer:FrVertexBuffer3D = FrSurface3D(_local2).getVertexBufferByNameId(FilterName_ID.POSITION_ID);
			var vertex:Vector.<Number> = frvertexbuffer.vertexVector;
			var persize:uint = frvertexbuffer.sizePerVertex;
			var offset:int = frvertexbuffer.bufferVoMap[FilterName_ID.POSITION_ID].offset;

			if (offset < 0)
			{
				return null;
			}


			var triangleIndex:Vector.<uint> = _local2.indexVector;
			var _len:uint = triangleIndex.length;

			var curIdex:uint = 0;
			var index0:uint;
			var index1:uint;
			var index2:uint;
			while (curIdex < _len)
			{
				index0 = (triangleIndex[curIdex++] * persize + offset);
				index1 = (triangleIndex[curIdex++] * persize + offset);
				index2 = (triangleIndex[curIdex++] * persize + offset);
				drawInstance.moveTo(vertex[index0], vertex[(index0 + 1)], vertex[(index0 + 2)]);
				drawInstance.lineTo(vertex[index1], vertex[(index1 + 1)], vertex[(index1 + 2)]);
				drawInstance.lineTo(vertex[index2], vertex[(index2 + 1)], vertex[(index2 + 2)]);
				drawInstance.lineTo(vertex[index0], vertex[(index0 + 1)], vertex[(index0 + 2)]);
			}
			return _mesh.bounds;
		}

		public function get meshObject():*
		{
			return (this._meshObject);
		}

		public function set meshObject(value:*):void
		{
			this._meshObject = value;
		}

	}
} //package flare.primitives

