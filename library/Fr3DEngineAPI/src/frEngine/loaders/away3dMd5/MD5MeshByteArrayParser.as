package frEngine.loaders.away3dMd5
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import baseEngine.utils.SplitSurfaceInfo;
	import baseEngine.utils.Surface3DUtils;
	
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.loaders.away3dMd5.md5Data.JointData;
	import frEngine.loaders.away3dMd5.md5Data.VertexData;
	import frEngine.math.Quaternion;

	public class MD5MeshByteArrayParser extends MD5MeshParserBase
	{
		private var _bytes:ByteArray;

		public static const parseTypeValue:int = 0x2000;

		public var hasSplitSurfaceInfo:Boolean;
		
		public function MD5MeshByteArrayParser()
		{
			super();

		}

		public static  function checkIsCompressMd5(head1:uint,head2:uint):Boolean
		{
			var isNormal:Boolean;
			if(head1==MD5MeshByteArrayParser.parseTypeValue && head2==1)
			{
				isNormal=true;
			}else
			{
				isNormal=false;
			}
			
			return !isNormal;
		}
		
		public function proceedParsing(data :ByteArray,surface:FrSurface3D,isCompress:int):Skeleton
		{
			_bytes = data;
			var skeleton : Skeleton = parseHeadAndJoints(_bytes,isCompress);
			if(skeleton.isCompress)
			{
				parserOptimizeSurface(_bytes,surface,skeleton);
			}
			else
			{
				var vertexData:Vector.<VertexData> = parseMeshVert(skeleton.hasNormal);
				var indices:Vector.<uint> = parseMeshTriangle();
				var weightData:Vector.<JointData> = parseMeshWeight();
				_bytes = null;
				var _numJoints:uint=skeleton.numBones;
				translateGeom(vertexData, weightData, indices,surface);
				skeleton.maxJointCount=this.maxJointCount;
				skeleton.splitSurfaceInfo=Surface3DUtils.split(surface);
			}
			
			trace("numBones:"+skeleton.numBones,"perVertexBones:"+skeleton.maxJointCount,"surfaceNum:"+skeleton.splitSurfaceInfo.startIndex.length);
			
			return skeleton;
		}

		private static  function parserOptimizeSurface(_bytes:ByteArray,surface:FrSurface3D,skeleton:Skeleton):void
		{
			var len:int=_bytes.readUnsignedInt();
			for (var i:int=0;i<len;i++)
			{
				var isSingle:Boolean=_bytes.readBoolean();
				var num:int=_bytes.readUnsignedInt();
				var vertexBuffer:FrVertexBuffer3D=null;
				for(var j:int=0;j<num;j++)
				{
					var nameId:uint=_bytes.readUnsignedInt();
					var size:uint=_bytes.readUnsignedInt();
					vertexBuffer=surface.addVertexData(nameId,size,isSingle,null);
				}
				
				var vertexLen:uint=_bytes.readUnsignedInt();
				var _b:ByteArray=new ByteArray();
				_b.endian=Endian.LITTLE_ENDIAN;
				_bytes.readBytes(_b,0,vertexLen*4);
				vertexBuffer.vertexBytes=_b;
			}
			var indexLen:uint=_bytes.readUnsignedInt();
			var _b2:ByteArray=new ByteArray();
			_b2.endian=Endian.LITTLE_ENDIAN;
			_bytes.readBytes(_b2,0,indexLen*2);
			
			
			surface.indexBytes=_b2;
			
			var splitInfo:SplitSurfaceInfo=new SplitSurfaceInfo();
			
			var splitNum:uint=_bytes.readUnsignedInt();
			
			var skinData:Vector.<Vector.<int>>=splitInfo.skinData;
			var startIndex:Array=splitInfo.startIndex;
			var triangleNum:Array=splitInfo.triangleNum
			for(i=0;i<splitNum;i++)
			{
				startIndex.push(_bytes.readUnsignedInt());
				triangleNum.push(_bytes.readUnsignedInt());
				var listLen:uint=_bytes.readUnsignedInt();
				var list:Vector.<int>=new Vector.<int>();
				skinData.push(list);
				for(j=0;j<listLen;j++)
				{
					list.push(_bytes.readUnsignedInt());
				}
			}
			skeleton.splitSurfaceInfo=splitInfo;
		}
		
		public static function parseHeadAndJoints(_bytes:ByteArray,isCompress:int):Skeleton
		{
			_bytes.endian = Endian.LITTLE_ENDIAN;
			_bytes.position = 0;
			var skeleton:Skeleton = new Skeleton();
			if(isCompress==-1)
			{
				skeleton.magic = _bytes.readUnsignedShort();
				skeleton.version=_bytes.readUnsignedShort();
				skeleton.isCompress=checkIsCompressMd5(skeleton.magic,skeleton.version);
				if (skeleton.isCompress)
				{
					_bytes.position=0;
					_bytes.uncompress();
					skeleton.version=_bytes.readUnsignedShort();
					parserOptimizeMd5(_bytes,skeleton);
				}
				else
				{
					parserNormalMd5(_bytes,skeleton);
				}
			}else
			{
				skeleton.isCompress=Boolean(isCompress);
				if(isCompress)
				{
					skeleton.magic = 1;
					skeleton.version=_bytes.readUnsignedShort();
					parserOptimizeMd5(_bytes,skeleton);
				}else
				{
					skeleton.magic = _bytes.readUnsignedShort();
					skeleton.version=_bytes.readUnsignedShort();
					parserNormalMd5(_bytes,skeleton);
				}
			}
			
			

			return skeleton;
		}
		
		private static function parserOptimizeMd5(_bytes:ByteArray,skeleton:Skeleton ):void
		{
			skeleton.hasNormal=_bytes.readBoolean();
			skeleton.material= _bytes.readUTF();
			skeleton.maxJointCount=_bytes.readUnsignedInt();
			var _numJoints:uint=_bytes.readUnsignedInt();
			var inherits:Vector.<SkeletonJoint> = skeleton.inherits
			for (var i:int = 0; i < _numJoints; i++)
			{
				var joint:SkeletonJoint = new SkeletonJoint();
				joint.name = _bytes.readUTF();
				joint.parentIndex = _bytes.readShort();
				
				
				_tempVector3d.x = _bytes.readFloat();
				_tempVector3d.y = _bytes.readFloat();
				_tempVector3d.z = _bytes.readFloat();
				
				tempQuat.x=_bytes.readFloat();
				tempQuat.y=_bytes.readFloat();
				tempQuat.z=_bytes.readFloat();
				tempQuat.w=_bytes.readFloat();
				
				var inv:Matrix3D = tempQuat.toMatrix3D();
				inv.appendTranslation(_tempVector3d.x, _tempVector3d.y, _tempVector3d.z);
				inv.invert();
				joint.inverseBindPose = inv;
				inherits[i] = joint;
			}
			var parentIndex:int;
			for (i = 0; i < _numJoints; i++)
			{
				joint = inherits[i];
				parentIndex = joint.parentIndex
				if (parentIndex != -1)
				{
					inherits[parentIndex].children.push(joint);
				}
				else
				{
					skeleton.joinRoot = joint;
				}
			}
		}
		private static function parserNormalMd5(_bytes:ByteArray,skeleton:Skeleton ):void
		{
			
			var hasNormal:Boolean=_bytes.readBoolean();
			var _material:String = readString(_bytes);
			var _numJoints:uint = _bytes.readUnsignedShort();
			//var _bindPoses:Vector.<Matrix3D> = new Vector.<Matrix3D>(_numJoints, true);
			skeleton.hasNormal=hasNormal;
			skeleton.material = _material;
			//skeleton.bindPoses = _bindPoses;
			
			var joint:SkeletonJoint;
			var quat:Quaternion;
			
			var m:Matrix3D;
			var inherits:Vector.<SkeletonJoint> = skeleton.inherits
			for (var i:int = 0; i < _numJoints; i++)
			{
				joint = new SkeletonJoint();
				joint.name = readString(_bytes);
				joint.parentIndex = _bytes.readShort();
				parseVector3D(_bytes,_tempVector3d);
				var pos:Vector3D=rotationQuat.rotatePoint(_tempVector3d);
				quat = parseQuaternion(_bytes);
				
				m = quat.toMatrix3D();
				//_bindPoses[i] = m
				m.appendTranslation(pos.x, pos.y, pos.z);
				var inv:Matrix3D = m;// m.clone();
				inv.invert();
				joint.inverseBindPose = inv;
				joint.quat=quat;
				joint.pos=pos;
				inherits[i] = joint;
			}
			
			var parentIndex:int;
			for (i = 0; i < _numJoints; i++)
			{
				joint = inherits[i];
				parentIndex = joint.parentIndex
				if (parentIndex != -1)
				{
					inherits[parentIndex].children.push(joint);
				}
				else
				{
					skeleton.joinRoot = joint;
				}
			}
		}
		public static function readString(stream:ByteArray):String
		{
			var result:String;
			var n:int = 0;
			var pos:uint = stream.position;
			var maxNum:int = 10000;
			while (n < maxNum)
			{
				result = stream.readMultiByte(1, "gb2312")
				if (result == "\\")
				{
					var bytesNum:int = stream.position - pos - 1;
					stream.position = pos;
					result = stream.readMultiByte(bytesNum, "gb2312");
					stream.position += 2;
					break;
				}
				n++;
			}
			if (n == maxNum)
			{
				throw new Error("3dmax输出有误，字符串没有加\\");
			}
			return result;
		}
		private static var tempQuat:Quaternion = new Quaternion();
		private static const _tempVector3d:Vector3D=new Vector3D();
		private static const _tempVector3d2:Vector3D=new Vector3D();
		private static function parseVector3D(_bytes:ByteArray,_target:Vector3D):void
		{
			_target.x = -_bytes.readFloat();
			_target.y = _bytes.readFloat();
			_target.z = _bytes.readFloat();

		}

		/**
		 * Retrieves the next quaternion in the data stream.
		 */
		private static function parseQuaternion(_bytes:ByteArray):Quaternion
		{
			var quat:Quaternion = new Quaternion();

			quat.x = _bytes.readFloat();
			quat.y = -_bytes.readFloat();
			quat.z = -_bytes.readFloat();

			// quat supposed to be unit length
			var t:Number = 1 - quat.x * quat.x - quat.y * quat.y - quat.z * quat.z;
			quat.w = t < 0 ? 0 : -Math.sqrt(t);

			var rotQuat:Quaternion = new Quaternion();
			rotQuat.multiply(rotationQuat, quat);
			return rotQuat;
		}

		private function parseMeshVert(hasNormal:Boolean):Vector.<VertexData>
		{
			var verticesNum:int = _bytes.readUnsignedShort()
			var vertexData:Vector.<VertexData> = new Vector.<VertexData>(verticesNum, true);
			if(hasNormal)
			{
				for (var i:int = 0; i < verticesNum; i++)
				{
					var vertex:VertexData = new VertexData();
					vertex.index = i
					vertex.s = _bytes.readFloat();
					vertex.t = _bytes.readFloat();
					vertex.startWeight = _bytes.readUnsignedShort()
					vertex.countWeight = _bytes.readUnsignedShort()
					parseVector3D(_bytes,_tempVector3d);
					vertex.pos = rotationQuat.rotatePoint(_tempVector3d);
					
					 parseVector3D(_bytes,_tempVector3d);
					vertex.normal = rotationQuat.rotatePoint(_tempVector3d);
					
					if (vertex.countWeight > _maxJointCount)
					{
						_maxJointCount = vertex.countWeight;
					}
					vertexData[i] = vertex;
				}
			}else
			{
				for (i = 0; i < verticesNum; i++)
				{
					vertex = new VertexData();
					vertex.index = i
					vertex.s = _bytes.readFloat();
					vertex.t = _bytes.readFloat();
					vertex.startWeight = _bytes.readUnsignedShort()
					vertex.countWeight = _bytes.readUnsignedShort()
					parseVector3D(_bytes,_tempVector3d);
					vertex.pos = rotationQuat.rotatePoint(_tempVector3d);
					if (vertex.countWeight > _maxJointCount)
					{
						_maxJointCount = vertex.countWeight;
					}
					vertexData[i] = vertex;
				}
			}
			
			return vertexData


		}

		private function parseMeshTriangle():Vector.<uint>
		{
			var triangleNum:int = _bytes.readUnsignedShort()
			var indices:Vector.<uint> = new Vector.<uint>(triangleNum * 3, true);
			for (var i:int = 0; i < triangleNum; i++)
			{
				var index:int = i * 3;
				indices[index] = _bytes.readUnsignedShort();
				indices[index + 1] = _bytes.readUnsignedShort()
				indices[index + 2] = _bytes.readUnsignedShort()
			}
			return indices;
		}

		private function parseMeshWeight():Vector.<JointData>
		{
			var weightsNum:int = _bytes.readUnsignedShort()
			var weights:Vector.<JointData> = new Vector.<JointData>(weightsNum, true);
			var i:int;
			var weight:JointData;
			
			for (i = 0; i < weightsNum; i++)
			{
				weight = new JointData();
				weight.index = i;
				weight.joint = _bytes.readUnsignedShort()
				weight.bias = _bytes.readFloat();
				//weight.pos = parseVector3D(_bytes);
				weights[i] = weight;
			}
			
			
			return weights;
		}

	}
}


