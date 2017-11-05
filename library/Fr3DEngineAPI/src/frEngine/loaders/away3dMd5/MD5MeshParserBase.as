package frEngine.loaders.away3dMd5
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import frEngine.core.Data3dInfo;
	import frEngine.core.FrSurface3D;
	import frEngine.loaders.away3dMd5.md5Data.JointData;
	import frEngine.loaders.away3dMd5.md5Data.VertexData;
	import frEngine.math.Quaternion;
	import frEngine.shader.filters.FilterName_ID;

	public class MD5MeshParserBase
	{
		
		
		public var materialUrl:String;

		//protected var _numJoints:int;
		protected var _maxJointCount : int = 0;

		public static var rotationQuat : Quaternion=initRotationQuat();
		public function MD5MeshParserBase()
		{
			super();
			
		}
		private static function initRotationQuat(additionalRotationAxis : Vector3D = null, additionalRotationRadians : Number = 0):Quaternion
		{
			var _rotationQuat:Quaternion = new Quaternion();
			
			_rotationQuat.fromAxisAngle(Vector3D.X_AXIS, -Math.PI * .5);
			
			if (additionalRotationAxis) {
				var quat : Quaternion = new Quaternion();
				quat.fromAxisAngle(additionalRotationAxis, additionalRotationRadians);
				_rotationQuat.multiply(_rotationQuat, quat);
			}
			return _rotationQuat;
		}
		protected function translateGeom(vertexData : Vector.<VertexData>, weights : Vector.<JointData>, md5Indices : Vector.<uint>,surface:FrSurface3D) :void
		{
			var triangleLen : int = md5Indices.length/3;
			var vertexNum:int;

			vertexNum=vertexData.length;

			var _curIndex0:int;
			var _curIndex1:int;
			var _curIndex2:int;
			
			var curIndex0:int;
			var curIndex1:int;
			var curIndex2:int;
			
			var vertices : Vector.<Number> = new Vector.<Number>(vertexNum * 3);
			var verticesNormal : Vector.<Number> = new Vector.<Number>(vertexNum * 3);
			var jointIndices : Vector.<Number> = new Vector.<Number>(vertexNum * _maxJointCount);
			var jointWeights : Vector.<Number> = new Vector.<Number>(vertexNum * _maxJointCount);
			var uvs : Vector.<Number> = new Vector.<Number>(vertexNum * 2);
			var indices:Vector.<uint>=new Vector.<uint>(triangleLen*3);
			
			var i : int = 0;

			var flag:Object=new Dictionary();
			for (i = 0; i < triangleLen; i++) 
			{
				curIndex0=i*3;
				curIndex1=curIndex0+1;
				curIndex2=curIndex0+2;
				
				_curIndex0=md5Indices[curIndex0];
				_curIndex1=md5Indices[curIndex1];
				_curIndex2=md5Indices[curIndex2];
				
				if(flag[_curIndex0]==null)
				{
					pushSanpleTrlData(vertices,verticesNormal,jointWeights,jointIndices,uvs,weights,vertexData,_curIndex0,_curIndex0);
					flag[_curIndex0]=true;
				}
				
				if(flag[_curIndex1]==null)
				{
					pushSanpleTrlData(vertices,verticesNormal,jointWeights,jointIndices,uvs,weights,vertexData,_curIndex1,_curIndex1);
					flag[_curIndex1]=true;
				}
				
				if(flag[_curIndex2]==null)
				{
					pushSanpleTrlData(vertices,verticesNormal,jointWeights,jointIndices,uvs,weights,vertexData,_curIndex2,_curIndex2);
					flag[_curIndex2]=true;
				}
				
				indices[curIndex0]=_curIndex0;
				indices[curIndex1]=_curIndex1;
				indices[curIndex2]=_curIndex2;
				
			}
			//calculateVertexNormal(verticesNormal,vertices,indices);
			setResultData(surface,indices,vertices,verticesNormal,uvs,jointWeights,jointIndices);
			
		}
		public function get maxJointCount():int
		{
			return _maxJointCount;
		}
		private function setResultData(surf:FrSurface3D,indices:Vector.<uint>,vertices:Vector.<Number>,verticesNormal:Vector.<Number>,uvs:Vector.<Number>,jointWeights:Vector.<Number>,jointIndices:Vector.<Number>):void
		{
			/*var grid:DebugWireframe=new DebugWireframe(createLine(verticesNormal,vertices),0xff0000,1,true,"testline");
			Device3D.scene.addChild(grid);
			grid.rotationY=180;*/
			var vertextNum:int=vertices.length/3;
			surf.addVertexData(FilterName_ID.POSITION_ID,3,true,new Data3dInfo(vertices,3,0,"float3"));
			surf.addVertexData(FilterName_ID.NORMAL_ID,3,true,new Data3dInfo(verticesNormal,3,0,"float3"));
			surf.addVertexData(FilterName_ID.UV_ID,2,true,new Data3dInfo(uvs,2,0,"float2"));
			surf.addVertexData(FilterName_ID.SKIN_WEIGHTS_ID,_maxJointCount,true,new Data3dInfo(jointWeights,_maxJointCount,0,"float"+_maxJointCount));
			surf.addVertexData(FilterName_ID.SKIN_INDICES_ID,_maxJointCount,true,new Data3dInfo(jointIndices,_maxJointCount,0,"float"+_maxJointCount));
			
			surf.indexVector=indices;

		}
		private function createLine(verticesNormal:Vector.<Number>,vertices:Vector.<Number>):Array
		{
			var verticesLen:int=vertices.length/3;
			var i:int=0;
			var arr:Array=new Array();
			var len:int=4;
			while(i<verticesLen)
			{
				var arr2:Array=new Array();
				arr.push(arr2);
				var n:int=i*3;
				arr2.push(vertices[n],vertices[n+1],vertices[n+2]);
				arr2.push(vertices[n]+verticesNormal[n]*len,vertices[n+1]+verticesNormal[n+1]*len,vertices[n+2]+verticesNormal[n+2]*len);
				i++
			}
			return arr;
		}
		private function calculateVertexNormal(verticesNormal:Vector.<Number>,vertices:Vector.<Number>,indices:Vector.<uint>):void
		{
			
			var verticesLen:int=vertices.length;
			var i:int=0;
			while(i<verticesLen)
			{
				verticesNormal[i]=0;
				i++
			}
			var triangleNum:uint=indices.length/3;
			var dic:Dictionary=new Dictionary(false);
			i=0;
			while(i<triangleNum)
			{
				var curIndex0:uint=i*3;
				var curIndex1:uint=curIndex0+1;
				var curIndex2:uint=curIndex0+2;
				curIndex0=indices[curIndex0]*3;
				curIndex1=indices[curIndex1]*3;
				curIndex2=indices[curIndex2]*3;
				var p0x:Number=vertices[curIndex0];
				var p0y:Number=vertices[curIndex0+1];
				var p0z:Number=vertices[curIndex0+2];
				
				var p1x:Number=vertices[curIndex1];
				var p1y:Number=vertices[curIndex1+1];
				var p1z:Number=vertices[curIndex1+2];
				
				var p2x:Number=vertices[curIndex2];
				var p2y:Number=vertices[curIndex2+1];
				var p2z:Number=vertices[curIndex2+2];
				
				var normal0x:Number=p0x-p1x;
				var normal0y:Number=p0y-p1y;
				var normal0z:Number=p0z-p1z;

				var normal1x:Number=p1x-p2x;
				var normal1y:Number=p1y-p2y;
				var normal1z:Number=p1z-p2z;
				
				var normal2x:Number=p2x-p0x;
				var normal2y:Number=p2y-p0y;
				var normal2z:Number=p2z-p0z;
				
				var r:Number=Math.sqrt(normal0x*normal0x+normal0y*normal0y+normal0z*normal0z)
				normal0x/=r;
				normal0y/=r;
				normal0z/=r;
				
				r=Math.sqrt(normal1x*normal1x+normal1y*normal1y+normal1z*normal1z)
				normal1x/=r;
				normal1y/=r;
				normal1z/=r;
				
				r=Math.sqrt(normal2x*normal2x+normal2y*normal2y+normal2z*normal2z)
				normal2x/=r;
				normal2y/=r;
				normal2z/=r;
				
				var targetx:Number;
				var targety:Number;
				var targetz:Number;

				
				if(dic[curIndex0+"_"+curIndex1]==null)
				{
					targetx=verticesNormal[curIndex0]+normal0x;
					targety=verticesNormal[curIndex0+1]+normal0y;
					targetz=verticesNormal[curIndex0+2]+normal0z;
					r=Math.sqrt(targetx*targetx+targety*targety+targetz*targetz)
					verticesNormal[curIndex0]=targetx/r;
					verticesNormal[curIndex0+1]=targety/r;
					verticesNormal[curIndex0+2]=targetz/r;
					dic[curIndex0+"_"+curIndex1]=true;
				}
				
				if(dic[curIndex1+"_"+curIndex0]==null)
				{
					targetx=verticesNormal[curIndex1]-normal0x;
					targety=verticesNormal[curIndex1+1]-normal0y;
					targetz=verticesNormal[curIndex1+2]-normal0z;
					r=Math.sqrt(targetx*targetx+targety*targety+targetz*targetz)
					verticesNormal[curIndex1]=targetx/r;
					verticesNormal[curIndex1+1]=targety/r;
					verticesNormal[curIndex1+2]=targetz/r;
					dic[curIndex1+"_"+curIndex0]=true
				}
				
				
				
				
				if(dic[curIndex1+"_"+curIndex2]==null)
				{
					targetx=verticesNormal[curIndex1]+normal1x;
					targety=verticesNormal[curIndex1+1]+normal1y;
					targetz=verticesNormal[curIndex1+2]+normal1z;
					r=Math.sqrt(targetx*targetx+targety*targety+targetz*targetz)
					verticesNormal[curIndex1]=targetx/r;
					verticesNormal[curIndex1+1]=targety/r;
					verticesNormal[curIndex1+2]=targetz/r;
					dic[curIndex1+"_"+curIndex2]=true;
				}
				
				if(dic[curIndex2+"_"+curIndex1]==null)
				{
					targetx=verticesNormal[curIndex2]-normal1x;
					targety=verticesNormal[curIndex2+1]-normal1y;
					targetz=verticesNormal[curIndex2+2]-normal1z;
					r=Math.sqrt(targetx*targetx+targety*targety+targetz*targetz)
					verticesNormal[curIndex2]=targetx/r;
					verticesNormal[curIndex2+1]=targety/r;
					verticesNormal[curIndex2+2]=targetz/r;
					dic[curIndex2+"_"+curIndex1]=true;
				}
				
				
				if(dic[curIndex2+"_"+curIndex0]==null)
				{
					targetx=verticesNormal[curIndex2]+normal2x;
					targety=verticesNormal[curIndex2+1]+normal2y;
					targetz=verticesNormal[curIndex2+2]+normal2z;
					r=Math.sqrt(targetx*targetx+targety*targety+targetz*targetz)
					verticesNormal[curIndex2]=targetx/r;
					verticesNormal[curIndex2+1]=targety/r;
					verticesNormal[curIndex2+2]=targetz/r;
					dic[curIndex2+"_"+curIndex0]=true;
				}
				if(dic[curIndex0+"_"+curIndex2]==null)
				{
					targetx=verticesNormal[curIndex0]-normal2x;
					targety=verticesNormal[curIndex0+1]-normal2y;
					targetz=verticesNormal[curIndex0+2]-normal2z;
					r=Math.sqrt(targetx*targetx+targety*targety+targetz*targetz)
					verticesNormal[curIndex0]=targetx/r;
					verticesNormal[curIndex0+1]=targety/r;
					verticesNormal[curIndex0+2]=targetz/r;
					dic[curIndex0+"_"+curIndex2]=true;
				}
				
				i++
				
			}
		}
		private function pushSanpleTrlData(va1Arr:Vector.<Number>,verticesNormal:Vector.<Number>, _boneWeightArr:Vector.<Number>, _boneIndexArr:Vector.<Number>, uvArr:Vector.<Number>,$weights:Vector.<JointData>,vertexdataMap:Vector.<VertexData>,vertexDataIndex:uint,indexVertex:uint) : void
		{
			var n:int = 0;
			var vertexdata:VertexData=vertexdataMap[vertexDataIndex];
			var boneNum:int = vertexdata.countWeight
			var bonex:Number=0;
			var boney:Number=0;
			var bonez:Number=0;

			
			var bindPose : Matrix3D;
			
			
			var startWeight:uint=vertexdata.startWeight;
			var normal:Vector3D=vertexdata.normal;
			var pos:Vector3D=vertexdata.pos;
			var boneWeight:Number;
			var boneIndex:int;
			var startIndex:int=indexVertex*_maxJointCount
			//var _bindPoses:Vector.<Matrix3D>=skeleton.bindPoses;
			while (n < _maxJointCount)
			{ 
				if (n < boneNum)
				{
					var weight:JointData=$weights[startWeight + n]
					var boneid:int=weight.joint;
					boneIndex=boneid * 3 ;
					boneWeight=weight.bias
					
					/*bindPose = _bindPoses[boneid];
					pos=bindPose.transformVector(weight.pos);

					bonex+=pos.x*boneWeight;
					boney+=pos.y*boneWeight;
					bonez+=pos.z*boneWeight;*/

					
				}
				else
				{
					boneIndex=0;
					boneWeight=0;
				}
				_boneWeightArr[startIndex+n]=boneWeight;
				_boneIndexArr[startIndex+n]=boneIndex;
				n++;
			}
			
			startIndex=indexVertex*3;
			va1Arr[startIndex]=pos.x;
			va1Arr[startIndex+1]=pos.y;
			va1Arr[startIndex+2]=pos.z;
			
			verticesNormal[startIndex]=normal.x;
			verticesNormal[startIndex+1]=normal.y;
			verticesNormal[startIndex+2]=normal.z;
			
			startIndex=indexVertex*2;
			uvArr[startIndex]=vertexdata.s;
			uvArr[startIndex+1]=vertexdata.t;
		}
	}
}
