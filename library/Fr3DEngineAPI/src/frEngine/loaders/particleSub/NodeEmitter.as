package frEngine.loaders.particleSub
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Mesh3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.shader.filters.FilterName_ID;

	public class NodeEmitter extends EmitterObject
	{

		
		private var _areaValueList:Array;
		
		private var _targetMesh:Mesh3D;
		private var _maxY:Number = -100000000;
		private var _minY:Number = 100000000;

		public function NodeEmitter($targetMesh:Mesh3D,emitterPosType:String,$randnomArr:Array)
		{
			super(emitterPosType,$randnomArr);
			_targetMesh=$targetMesh;
			var _targetSurface:FrSurface3D=_targetMesh.getSurface(0);
			if(_targetSurface)
			{
				initData(null,_targetSurface);
			}else
			{
				initComplete=false;
				_targetMesh.addEventListener(Engine3dEventName.SetMeshSurface,initData);
			}
			
		}
		private function initData(e:Event,_targetSurface:FrSurface3D=null):void
		{
			if(e!=null)
			{
				var mesh:Mesh3D=e.currentTarget as Mesh3D;
				_targetSurface=mesh.getSurface(0);
				mesh.removeEventListener(Engine3dEventName.SetMeshSurface,initData);
			}
			var buffer:FrVertexBuffer3D=_targetSurface.getVertexBufferByNameId(FilterName_ID.POSITION_ID)
			posVector=buffer.vertexVector;
			indexVector=_targetSurface.indexBufferFr.indexVector;
			sizePerVertex=buffer.sizePerVertex;
			positionOffset=buffer.bufferVoMap[FilterName_ID.POSITION_ID].offset;
			
			buffer = _targetSurface.getVertexBufferByNameId(FilterName_ID.UV_ID);
			uvPosVector = buffer.vertexVector;
			uvSizePerVectex = buffer.sizePerVertex;
			uvOffset = buffer.bufferVoMap[FilterName_ID.UV_ID].offset;
			initComplete=true;
			this.dispatchEvent(new Event(Engine3dEventName.InitComplete));
		}

		public override function getObject3d():*
		{
			return _targetMesh;
		}
		public override function dispose():void
		{
			super.dispose();
			_targetMesh.removeEventListener(Engine3dEventName.SetMeshSurface,initData);
			posVector=null;
			indexVector=null;
		}
		
		protected override function processAxis(index:int):void
		{
			_vect3d.x = 0;
			_vect3d.z = 0;
//			initMaxH();
			_vect3d.y = 0;//(_maxY - _minY) * Math.random() + _minY; 
		}
		
		protected override function processVolume(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			
			processCurve(index);
			var rand:Number = _rand1;
			_vect3d.x *= rand;
//			_vect3d.y *= rand;
			_vect3d.z *= rand;
		}
		
		protected override function processEdage(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];

			var faceIndex:int = randomFaceIndex(index,_rand1);
			// 3个点中随机2个
			var rand:Number = _rand1 * 3;
			var index0:int;
			var index1:int
			if(rand < 1)// 0 1
			{
				index0 = indexVector[faceIndex*3]*sizePerVertex+positionOffset;
				index1 = indexVector[faceIndex*3 + 1]*sizePerVertex+positionOffset;
			}
			else if(rand < 2)//0 2
			{
				index0 = indexVector[faceIndex*3]*sizePerVertex+positionOffset;
				index1 = indexVector[faceIndex*3 + 2]*sizePerVertex+positionOffset;
			}
			else//1 2
			{
				index0 = indexVector[faceIndex*3 + 1]*sizePerVertex+positionOffset;
				index1 = indexVector[faceIndex*3 + 2]*sizePerVertex+positionOffset;
			}
			
			pointA.x=posVector[index0];
			pointA.y=posVector[index0+1];
			pointA.z=posVector[index0+2];
			
			pointB.x=posVector[index1];
			pointB.y=posVector[index1+1];
			pointB.z=posVector[index1+2];
			
			pointB = pointB.subtract(pointA);
			rand = _rand2;
			pointB.x *= rand;
			pointB.y *= rand;
			pointB.z *= rand;
			_vect3d = pointA.add(pointB);
		}
		
		protected override function processVertex(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];

			var len:int=posVector.length - positionOffset;
			len /= sizePerVertex;
			var index:int = int(len * _rand1) * sizePerVertex + positionOffset;
			_vect3d.x = posVector[index];
			_vect3d.y = posVector[index + 1];
			_vect3d.z = posVector[index + 2];
		}

		protected override function processCurve(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];
			var _rand3:Number = randnomArr[index+2];
			
			var faceIndex:int=randomFaceIndex(index,_rand1)
			
			findTargetFaceXYZ(faceIndex,_rand1,_rand2,_rand3);
		}
		
		private function randomFaceIndex(index:int,_rand1:Number):int
		{

			if(!_areaValueList)
			{
				initArea();
			}
			var targetIndex:int=0;
			var num:Number=_rand1;
			var len:int=_areaValueList.length;
			for(var i:int=0;i<len;i++)
			{
				if(_areaValueList[i]>num)
				{
					targetIndex=i;
					break;
				}
			}
			return targetIndex;
		}
		
		private function initMaxH():void
		{
			if(_maxY != -100000000)
			{
				return;
			}
			var len:int=posVector.length - positionOffset;
			var value:Number;
			for(var i:int = positionOffset; i < len; i += sizePerVertex)
			{
				value = posVector[i+1];
				_maxY = value > _maxY?value:_maxY;
				_minY = value < _minY?value:_minY;
			}
		}
		
		private function initArea():void
		{
			_areaValueList=new Array();
			var len:int=indexVector.length;
			var totalArea:Number=0;
			for(var i:int=0;i<len;i+=3)
			{
				var index0:int=indexVector[i]*sizePerVertex+positionOffset;
				var index1:int=indexVector[i+1]*sizePerVertex+positionOffset;
				var index2:int=indexVector[i+2]*sizePerVertex+positionOffset;
				
				pointA.x=posVector[index0];
				pointA.y=posVector[index0+1];
				pointA.z=posVector[index0+2];
				
				pointB.x=posVector[index1];
				pointB.y=posVector[index1+1];
				pointB.z=posVector[index1+2];
				
				pointC.x=posVector[index2];
				pointC.y=posVector[index2+1];
				pointC.z=posVector[index2+2];
				
				pointA=pointA.subtract(pointC);
				pointB=pointB.subtract(pointC);
				
				pointC=pointA.crossProduct(pointB);
				
				var areaNum:Number=pointC.length/2;
				_areaValueList.push(areaNum);
				
				totalArea+=areaNum;
			}
			len=_areaValueList.length;
			var preAreaNum:Number=0;
			for(i=0;i<len;i++)
			{
				var rate:Number=_areaValueList[i]/totalArea;
				preAreaNum=rate+preAreaNum;
				_areaValueList[i]=preAreaNum
			}
		}
		
		private function findTargetFaceXYZ(faceIndex:int,_rand1:Number,_rand2:Number,_rand3:Number):void
		{
			
			
			var index0:int=indexVector[faceIndex*3]*sizePerVertex+positionOffset;
			var index1:int=indexVector[faceIndex*3+1]*sizePerVertex+positionOffset;
			var index2:int=indexVector[faceIndex*3+2]*sizePerVertex+positionOffset;
			
			pointA.x=posVector[index0];
			pointA.y=posVector[index0+1];
			pointA.z=posVector[index0+2];
			
			pointB.x=posVector[index1];
			pointB.y=posVector[index1+1];
			pointB.z=posVector[index1+2];
			
			pointC.x=posVector[index2];
			pointC.y=posVector[index2+1];
			pointC.z=posVector[index2+2];
			
			var temp:Vector3D=pointC.subtract(pointA);
			var len:Number=temp.normalize()*_rand1;
			temp.scaleBy(len);
			pointC=pointA.add(temp);
			
			temp=pointB.subtract(pointA);
			len=temp.normalize()*_rand2;
			temp.scaleBy(len);
			pointB=pointA.add(temp);
			
			temp=pointC.subtract(pointB);
			len=temp.normalize()*_rand3;
			temp.scaleBy(len);
			temp=pointB.add(temp);
			
			_vect3d.x = temp.x;
			_vect3d.y = temp.y;
			_vect3d.z = temp.z;
		}
	}
}