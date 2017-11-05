


//flare.utils.Surface3DUtils

package baseEngine.utils
{
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import __AS3__.vec.Vector;
	
	import baseEngine.core.Poly3D;
	import baseEngine.core.Surface3D;
	import baseEngine.system.Device3D;
	
	import frEngine.core.BufferVo;
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.shader.filters.FilterName_ID;
	
	
	public class Surface3DUtils 
	{
		
		public static function buildPolys(_arg1:FrSurface3D,_offset:Matrix3D, _arg2:Boolean=false):Vector.<Poly3D>
		{
			
			var _local3:Vector3D;
			var _local4:Vector3D;
			var _local5:Vector3D;
			var _local13:uint;
			var _local14:uint;
			var _local15:uint;
			var _local16:Poly3D;
			
			if (((_arg1.polys) && ((_arg2 == false))))
			{
				return (_arg1.polys);
			};
			
			if(!_offset)
			{
				_offset=new Matrix3D();
			}
			_arg1.polys = new Vector.<Poly3D>();
			if (_arg1.numTriangles == -1)
			{
				_arg1.numTriangles = (_arg1.indexVector.length / 3);
			};
			var frVertexBurfer:FrVertexBuffer3D=_arg1.getVertexBufferByNameId(FilterName_ID.POSITION_ID)
			var _local6:Vector.<uint> = _arg1.indexVector;
			var _local7:Vector.<Number> =frVertexBurfer .vertexVector;
			var _local8:int;
			var _local9:int = _arg1.indexVector.length;
			var _local10:int = frVertexBurfer.bufferVoMap[FilterName_ID.POSITION_ID].offset;
			var _local11:int = frVertexBurfer.bufferVoMap[FilterName_ID.UV_ID].offset;
			var _local12:int;
			var sizePerVertex:int=frVertexBurfer.sizePerVertex;
			while (_local12 < _local9)
			{
				_local13 = (_local6[_local12++] * sizePerVertex);
				_local14 = (_local6[_local12++] * sizePerVertex);
				_local15 = (_local6[_local12++] * sizePerVertex);
				_local3 = new Vector3D(_local7[(_local15 + _local10)], _local7[((_local15 + 1) + _local10)], _local7[((_local15 + 2) + _local10)]);
				_local4 = new Vector3D(_local7[(_local14 + _local10)], _local7[((_local14 + 1) + _local10)], _local7[((_local14 + 2) + _local10)]);
				_local5 = new Vector3D(_local7[(_local13 + _local10)], _local7[((_local13 + 1) + _local10)], _local7[((_local13 + 2) + _local10)]);
				
				_local3=_offset.transformVector(_local3);
				_local4=_offset.transformVector(_local4);
				_local5=_offset.transformVector(_local5);
				
				_local16 = new Poly3D(_local3, _local4, _local5);
				if (_local11 != -1)
				{
					_local16.uv0 = new Point(_local7[(_local15 + _local11)], _local7[((_local15 + 1) + _local11)]);
					_local16.uv1 = new Point(_local7[(_local14 + _local11)], _local7[((_local14 + 1) + _local11)]);
					_local16.uv2 = new Point(_local7[(_local13 + _local11)], _local7[((_local13 + 1) + _local11)]);
				};
				_arg1.polys.push(_local16);
			};
			_arg1.updateBoundings();
			return (_arg1.polys);
		}
		
		
		public static function buildTangentsAndBitangents(_arg1:FrSurface3D):void
		{
			var _local31:int;
			var _local32:int;
			var _local33:int;
			var _local34:int;
			var _local35:int;
			var _local36:int;
			var _local37:int;
			var _local38:int;
			var _local39:int;
			var _local40:Number;
			var _local41:Number;
			var _local42:Number;
			var _local43:Number;
			var _local44:Number;
			var _local45:Number;
			var _local46:Number;
			var _local47:Number;
			var _local48:Number;
			var _local49:Number;
			var _local50:Number;
			var _local51:int;
			var _local52:int;
			var _local2:Dictionary = _arg1.bufferVoMap;
			
			if (((!((_local2[FilterName_ID.TANGENT_ID].offset == -1))) || (!((_local2[FilterName_ID.BITANGENT_ID].offset == -1)))))
			{
				return;
			};
			
			var _local3:Vector.<Number> = _arg1.getVertexBufferByNameId(FilterName_ID.TANGENT_ID).vertexVector;
			var _local4:Vector.<uint> = _arg1.indexVector;
			var _local5:int = _arg1.sizePerVertex;
			
			var _local6:Vector.<Number> = new Vector.<Number>(((_local3.length / _local5) * 3));
			var _local7:Vector.<Number> = new Vector.<Number>(((_local3.length / _local5) * 3));
			var _local8:Vector3D = new Vector3D();
			var _local9:Vector3D = new Vector3D();
			var _local10:Vector3D = new Vector3D();
			var _local11:Vector3D = new Vector3D();
			var _local12:Vector3D = new Vector3D();
			var _local13:Point = new Point();
			var _local14:Point = new Point();
			var _local15:Point = new Point();
			var _local16:int = _local2[FilterName_ID.POSITION_ID].offset;
			var _local17:int = _local2[FilterName_ID.UV_ID].offset;
			var _local18:int = _local2[FilterName_ID.NORMAL_ID].offset;
			var _local19:int = _local4.length;
			var _local20:int;
			while (_local20 < _local19)
			{
				_local31 = _local4[_local20];
				_local32 = _local4[(_local20 + 1)];
				_local33 = _local4[(_local20 + 2)];
				_local34 = ((_local31 * _local5) + _local16);
				_local35 = ((_local32 * _local5) + _local16);
				_local36 = ((_local33 * _local5) + _local16);
				_local37 = ((_local31 * _local5) + _local17);
				_local38 = ((_local32 * _local5) + _local17);
				_local39 = ((_local33 * _local5) + _local17);
				_local8.setTo(_local3[_local34], _local3[(_local34 + 1)], _local3[(_local34 + 2)]);
				_local9.setTo(_local3[_local35], _local3[(_local35 + 1)], _local3[(_local35 + 2)]);
				_local10.setTo(_local3[_local36], _local3[(_local36 + 1)], _local3[(_local36 + 2)]);
				_local40 = (_local9.x - _local8.x);
				_local41 = (_local10.x - _local8.x);
				_local42 = (_local9.y - _local8.y);
				_local43 = (_local10.y - _local8.y);
				_local44 = (_local9.z - _local8.z);
				_local45 = (_local10.z - _local8.z);
				_local13.setTo(_local3[_local37], -(_local3[(_local37 + 1)]));
				_local14.setTo(_local3[_local38], -(_local3[(_local38 + 1)]));
				_local15.setTo(_local3[_local39], -(_local3[(_local39 + 1)]));
				_local46 = (_local14.x - _local13.x);
				_local47 = (_local15.x - _local13.x);
				_local48 = (_local14.y - _local13.y);
				_local49 = (_local15.y - _local13.y);
				_local50 = (1 / ((_local46 * _local49) - (_local47 * _local48)));
				_local11.setTo((((_local49 * _local40) - (_local48 * _local41)) * _local50), (((_local49 * _local42) - (_local48 * _local43)) * _local50), (((_local49 * _local44) - (_local48 * _local45)) * _local50));
				_local12.setTo((((_local46 * _local41) - (_local47 * _local40)) * _local50), (((_local46 * _local43) - (_local47 * _local42)) * _local50), (((_local46 * _local45) - (_local47 * _local44)) * _local50));
				_local6[(_local31 * 3)] = (_local6[(_local31 * 3)] + _local11.x);
				_local6[((_local31 * 3) + 1)] = (_local6[((_local31 * 3) + 1)] + _local11.y);
				_local6[((_local31 * 3) + 2)] = (_local6[((_local31 * 3) + 2)] + _local11.z);
				_local6[(_local32 * 3)] = (_local6[(_local32 * 3)] + _local11.x);
				_local6[((_local32 * 3) + 1)] = (_local6[((_local32 * 3) + 1)] + _local11.y);
				_local6[((_local32 * 3) + 2)] = (_local6[((_local32 * 3) + 2)] + _local11.z);
				_local6[(_local33 * 3)] = (_local6[(_local33 * 3)] + _local11.x);
				_local6[((_local33 * 3) + 1)] = (_local6[((_local33 * 3) + 1)] + _local11.y);
				_local6[((_local33 * 3) + 2)] = (_local6[((_local33 * 3) + 2)] + _local11.z);
				_local7[(_local31 * 3)] = (_local7[(_local31 * 3)] + _local12.x);
				_local7[((_local31 * 3) + 1)] = (_local7[((_local31 * 3) + 1)] + _local12.y);
				_local7[((_local31 * 3) + 2)] = (_local7[((_local31 * 3) + 2)] + _local12.z);
				_local7[(_local32 * 3)] = (_local7[(_local32 * 3)] + _local12.x);
				_local7[((_local32 * 3) + 1)] = (_local7[((_local32 * 3) + 1)] + _local12.y);
				_local7[((_local32 * 3) + 2)] = (_local7[((_local32 * 3) + 2)] + _local12.z);
				_local7[(_local33 * 3)] = (_local7[(_local33 * 3)] + _local12.x);
				_local7[((_local33 * 3) + 1)] = (_local7[((_local33 * 3) + 1)] + _local12.y);
				_local7[((_local33 * 3) + 2)] = (_local7[((_local33 * 3) + 2)] + _local12.z);
				_local20 = (_local20 + 3);
			};
			var _local21:FrSurface3D = new FrSurface3D("tangents/bitangents");
			//_local21.addVertexData(Surface3D.TANGENT, 3, _local6);
			//_local21.addVertexData(Surface3D.BITANGENT, 3, _local7);
			var _local22:Vector.<Number> = _local21.getVertexBufferByNameId(FilterName_ID.TANGENT_ID).vertexVector;

			var _local23:int;
			var _local24:int = 3;
			var _local25:Vector3D = new Vector3D();
			var _local26:Vector3D = new Vector3D();
			var _local27:Vector3D = new Vector3D();
			var _local28:Vector3D = new Vector3D();
			var _local29:int;
			var _local30:int = (_local3.length / _local5);
			_local20 = _local29;
			while (_local20 < _local30)
			{
				_local51 = (_local20 * _local5);
				_local52 = (_local20 * 6);
				_local25.setTo(_local3[(_local51 + _local18)], _local3[((_local51 + _local18) + 1)], _local3[((_local51 + _local18) + 2)]);
				_local26.setTo(_local22[(_local52 + _local23)], _local22[((_local52 + _local23) + 1)], _local22[((_local52 + _local23) + 2)]);
				_local27.setTo(_local22[(_local52 + _local24)], _local22[((_local52 + _local24) + 1)], _local22[((_local52 + _local24) + 2)]);
				_local28.copyFrom(_local25);
				_local28.scaleBy(_local25.dotProduct(_local26));
				_local26 = _local26.subtract(_local28);
				_local26.normalize();
				_local28.copyFrom(_local25);
				_local28.scaleBy(_local25.dotProduct(_local27));
				_local27 = _local27.subtract(_local28);
				_local27.normalize();
				_local22[((_local20 * 6) + _local23)] = _local26.x;
				_local22[(((_local20 * 6) + _local23) + 1)] = _local26.y;
				_local22[(((_local20 * 6) + _local23) + 2)] = _local26.z;
				_local22[((_local20 * 6) + _local24)] = _local27.x;
				_local22[(((_local20 * 6) + _local24) + 1)] = _local27.y;
				_local22[(((_local20 * 6) + _local24) + 2)] = _local27.z;
				_local20++;
			};
		}

		private static var addNum:int=0;
		private static function addVertex(oldIndex:int,newIndex:int,vertexBuffersMap:Dictionary):void
		{
			addNum++;
			for(var vertexBuffer:Object in vertexBuffersMap)
			{
				var index:int = 0;
				var sizePerVertex:int = vertexBuffer.sizePerVertex;
				var vector:Vector.<Number> = vertexBuffer.vertexVector;
				if( vector.length < (newIndex+1)*sizePerVertex )
				{
					vector.length=(newIndex+1)*sizePerVertex;
				}
				while (index < sizePerVertex)
				{
					vector[newIndex*sizePerVertex + index]=vector[oldIndex * sizePerVertex + index]
					index++;
				}
			}
		}
		public static function split(targetSurface:FrSurface3D):SplitSurfaceInfo
		{
			addNum=0;
			var _hasPushBoneMap:Dictionary;
			var newBoneList:Array;
			var _startIndex:int;
			var _endIndex:int;
			
			
			var _vertex0:uint;
			var _vertex1:uint;
			var _vertex2:uint;
			var _boneIndexVector:int;
			var _old1:int;
			var _old2:int;
			var _old3:int;
			
			var splitInfo:SplitSurfaceInfo=new SplitSurfaceInfo();
			var skinData:Vector.<Vector.<int>>= splitInfo.skinData;
			var startIndex:Array = splitInfo.startIndex;
			var triangleNum:Array = splitInfo.triangleNum;
			
			var maxBonesPerSurface:int = Device3D.maxBonesPerSurface;
			
			var boneBuffer:FrVertexBuffer3D = targetSurface.getVertexBufferByNameId(FilterName_ID.SKIN_INDICES_ID);
			_hasPushBoneMap = new Dictionary();
			newBoneList = [];
			if (targetSurface.numTriangles == -1)
			{
				targetSurface.numTriangles = (targetSurface.indexVector.length / 3);
			}
			
			var _triangleStart:int = 0;
			_startIndex = targetSurface.firstIndex;
			_endIndex = (_startIndex + (targetSurface.numTriangles * 3));
			
			var _oldIndexVect:Vector.<Number> = boneBuffer.vertexVector;
			var _newBoneVector:Vector.<Number> = new Vector.<Number>(_oldIndexVect.length);
			var triangleList:Vector.<uint> = targetSurface.indexVector;
			var sizePerVertex:int = boneBuffer.sizePerVertex;
			
			var numVertex:int=_oldIndexVect.length/sizePerVertex;
			var bone0:uint;
			var bone1:uint;
			var bone2:uint;
			var curSurfaceId:int=1;
			var maxVertexNum:int=int(numVertex*1.5);
			var boneInSurfMap:Vector.<uint>=new Vector.<uint>(maxVertexNum);
			var newVertexId:Vector.<uint>=new Vector.<uint>(maxVertexNum);
			var _newV0:int,_newV1:int,_newV2:int;
			var vertexBuffersMap:Dictionary=targetSurface.getUseSameBufferVoList();
			while (_startIndex < _endIndex)
			{
				_vertex0 = triangleList[_startIndex++];
				_vertex1 = triangleList[_startIndex++];
				_vertex2 = triangleList[_startIndex++];
				
				if(boneInSurfMap[_vertex0]==0 )
				{
					boneInSurfMap[_vertex0]=curSurfaceId;
					_newV0=newVertexId[_vertex0]=_vertex0
				}else if(boneInSurfMap[_vertex0]!=curSurfaceId)
				{
					addVertex(_vertex0,numVertex,vertexBuffersMap);
					triangleList[_startIndex-3]=newVertexId[_vertex0]=_newV0=numVertex;
					boneInSurfMap[_vertex0]=curSurfaceId;
					_newBoneVector.length+=sizePerVertex;
					numVertex++;
				}else
				{
					_newV0=newVertexId[_vertex0];
					triangleList[_startIndex-3]=_newV0;
				}
				
				if(boneInSurfMap[_vertex1]==0)
				{
					boneInSurfMap[_vertex1]=curSurfaceId;
					_newV1=newVertexId[_vertex1]=_vertex1
				}else if(boneInSurfMap[_vertex1]!=curSurfaceId)
				{
					addVertex(_vertex1,numVertex,vertexBuffersMap);
					triangleList[_startIndex-2]=newVertexId[_vertex1]=_newV1=numVertex;
					boneInSurfMap[_vertex1]=curSurfaceId;
					_newBoneVector.length+=sizePerVertex;
					numVertex++;
				}else
				{
					_newV1=newVertexId[_vertex1];
					triangleList[_startIndex-2]=_newV1;
				}
				
				if(boneInSurfMap[_vertex2]==0)
				{
					boneInSurfMap[_vertex2]=curSurfaceId;
					_newV2=newVertexId[_vertex2]=_vertex2;
				}else if(boneInSurfMap[_vertex2]!=curSurfaceId)
				{
					addVertex(_vertex2,numVertex,vertexBuffersMap);
					triangleList[_startIndex-1]=newVertexId[_vertex2]=_newV2=numVertex;
					boneInSurfMap[_vertex2]=curSurfaceId;
					_newBoneVector.length+=sizePerVertex;
					numVertex++;
				}else
				{
					_newV2=newVertexId[_vertex2];
					triangleList[_startIndex-1]=_newV2;
				}
				
				_boneIndexVector = 0;
				while (_boneIndexVector < sizePerVertex)
				{
					bone0 = _vertex0 * sizePerVertex + _boneIndexVector;
					bone1 = _vertex1 * sizePerVertex + _boneIndexVector;
					bone2 = _vertex2 * sizePerVertex + _boneIndexVector;
					
					_old1 = _oldIndexVect[bone0];
					_old2 = _oldIndexVect[bone1];
					_old3 = _oldIndexVect[bone2];
					
					if (_hasPushBoneMap[_old1] == null)
					{
						_hasPushBoneMap[_old1] = newBoneList.length*3;
						newBoneList.push((_old1 / 3));
					}
					
					if (_hasPushBoneMap[_old2] == null)
					{
						_hasPushBoneMap[_old2] = newBoneList.length*3;
						newBoneList.push((_old2 / 3));
					}
					
					if (_hasPushBoneMap[_old3] == null)
					{
						_hasPushBoneMap[_old3] = newBoneList.length*3;
						newBoneList.push((_old3 / 3));
					}
					
					
					_newBoneVector[_newV0 * sizePerVertex + _boneIndexVector] = _hasPushBoneMap[_old1];
					_newBoneVector[_newV1 * sizePerVertex + _boneIndexVector] = _hasPushBoneMap[_old2];
					_newBoneVector[_newV2 * sizePerVertex + _boneIndexVector] = _hasPushBoneMap[_old3];
					
					_boneIndexVector++;
				}
				
				if ((((newBoneList.length > maxBonesPerSurface)) || ((_startIndex == _endIndex))))
				{
					if (newBoneList.length > maxBonesPerSurface)
					{
						_startIndex -= 3;
						newBoneList.length = maxBonesPerSurface;
					}
					
					if (newBoneList.length > 0)
					{
						skinData.push(Vector.<int>(newBoneList));
						startIndex.push(_triangleStart);
						triangleNum.push((_startIndex - _triangleStart) / 3);
						curSurfaceId++;
					}
					
					_hasPushBoneMap = new Dictionary(false);
					newBoneList = [];
					_triangleStart = _startIndex;
					
				}
				
				
			}
			boneBuffer.vertexVector=_newBoneVector;
			trace("新增顶点数："+addNum,"surfaceNum:"+skinData.length);
			return splitInfo;
			
		}

	}
}//package flare.utils

