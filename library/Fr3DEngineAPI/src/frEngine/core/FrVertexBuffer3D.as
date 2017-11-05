package frEngine.core
{
	import flash.display3D.Context3D;
	import flash.display3D.VertexBuffer3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class FrVertexBuffer3D 
	{
		
		public var sizePerVertex:int = 0;
		public var bufferVoMap:Dictionary=new Dictionary(false);
		public var vertexBuffer:VertexBuffer3D;
		public var _toUpdate:Boolean=true;
		private var _parentFrSurface:FrSurface3D;
		private var _vertexVector:Vector.<Number>;
		private var _vertexBytes:ByteArray;

		public var isSingle:Boolean;
		public function FrVertexBuffer3D($parentFrSurface:FrSurface3D,$isSingle:Boolean)
		{
			super();
			_parentFrSurface=$parentFrSurface;
			isSingle=$isSingle;
		}
		public function set vertexBytes(value:ByteArray):void
		{
			_vertexBytes=value;
		}
		public function clone(_parentFrSurface:FrSurface3D):FrVertexBuffer3D
		{
			var __new:FrVertexBuffer3D=new FrVertexBuffer3D(_parentFrSurface,isSingle);
			__new.bufferVoMap=this.bufferVoMap;
			__new.sizePerVertex=this.sizePerVertex;
			__new._vertexVector=this._vertexVector;
			__new._vertexBytes=this._vertexBytes;
			return __new;
		}
		public function toUpdate():void
		{
			_toUpdate=true;
			if(_parentFrSurface)
			{
				_parentFrSurface.needUpdate=true;
			}
			
		}
		public function canInsert(vertexNameId:int, size:int):Boolean
		{
			if(sizePerVertex>0 && isSingle)
			{
				return false;
			}
			var format:String=("float" + size);
			var _caninsert:Boolean;
			if(this.bufferVoMap[vertexNameId]!=null)
			{
				var oldSize:int=int(this.bufferVoMap[vertexNameId].size);
				_caninsert=this.sizePerVertex-oldSize+size<=16;
			}else
			{
				_caninsert=this.sizePerVertex+size<=16;
			}
			return _caninsert;
		}
		public  function addVertexData(vertexNameId:int, size:int,dataInfo:Data3dInfo,check:Boolean):int
		{
			if(check && isSingle && sizePerVertex>0)
			{
				throw new Error("error in FrVertexBuffer3D.as");
				return 0;
			}
			var vo:BufferVo=this.bufferVoMap[vertexNameId]
			var format:String=("float" + size);
			var oldDataInfo:Data3dInfo;
			if (vo != null)
			{
				var oldFortmat:String=vo.format;
				if(dataInfo)
				{
					oldDataInfo=new Data3dInfo(this.vertexVector,sizePerVertex,vo.offset,oldFortmat);
					this.vertexVector=insertData(size,oldDataInfo,dataInfo);
					setOtherOffsets(vo.size,size,vo.offset);
				}
				vo.format = format;
				vo.size=size;
				this.sizePerVertex = this.sizePerVertex-int(oldFortmat.charAt(5)) + size;
				return vo.offset;
			}else
			{
				if (dataInfo)
				{
					oldDataInfo=new Data3dInfo(this.vertexVector,sizePerVertex,sizePerVertex,"float0");
					this.vertexVector=insertData(size,oldDataInfo,dataInfo);
				};
				vo=new BufferVo(this,vertexNameId);
				vo.format = format;
				vo.offset = this.sizePerVertex;
				vo.size=size;
				this.sizePerVertex = (this.sizePerVertex + size);
				bufferVoMap[vertexNameId]=vo;
				return vo.offset;
			}
		}
		private function setOtherOffsets(oldSize:int,newSize:int,oldOffsetValue:int):void
		{
			if(oldSize==newSize)return;
			var dis:int=newSize-oldSize;
			for(var p:Object in bufferVoMap)
			{
				var vo:BufferVo=bufferVoMap[p];
				if(vo.offset>oldOffsetValue)
				{
					vo.offset+=dis;
				}
			}
		}
		public function insertData(targetSize:int,baseDataInfo:Data3dInfo,dataInfo:Data3dInfo=null):Vector.<Number>
		{
			var $baseData:Vector.<Number>=baseDataInfo.data;
			var $baseDataPersize:int=baseDataInfo.dataPerSize;
			var $baseDataOffset:int=baseDataInfo.dataOffset;
			var $baseDataFortmat:String=baseDataInfo.dataFormat;
			var $baseSize:int=int($baseDataFortmat.charAt(5));

			var $data:Vector.<Number>=dataInfo.data;
			var $dataPersize:int=dataInfo.dataPerSize;
			var $dataOffset:int=dataInfo.dataOffset;
			var $dataFortmat:String=dataInfo.dataFormat;
			var $dataSize:int=int($dataFortmat.charAt(5));

			var targetLen:int;
			if($baseDataPersize==0)
			{
				if($dataPersize==targetSize && $dataSize==targetSize)
				{
					return $data;
				}else
				{
					targetLen = ($data.length / $dataPersize);
					return createNewVect(targetSize,targetLen,baseDataInfo,dataInfo);
				}
			}else
			{
				if($baseSize==targetSize)
				{
					return replaceOldVect(baseDataInfo,dataInfo);
				}else
				{
					targetLen = ($baseData.length / $baseDataPersize);
					return createNewVect(targetSize,targetLen,baseDataInfo,dataInfo);
				}
			}
		}
		private function replaceOldVect(baseDataInfo:Data3dInfo,dataInfo:Data3dInfo=null):Vector.<Number>
		{
			var $baseData:Vector.<Number>=baseDataInfo.data;
			var $baseDataPersize:int=baseDataInfo.dataPerSize;
			var $baseDataOffset:int=baseDataInfo.dataOffset;
			var $baseDataFortmat:String=baseDataInfo.dataFormat;
			var $baseSize:int=int($baseDataFortmat.charAt(5));

			var $data:Vector.<Number>=dataInfo.data;
			var $dataPersize:int=dataInfo.dataPerSize;
			var $dataOffset:int=dataInfo.dataOffset;
			var $dataFortmat:String=dataInfo.dataFormat;
			var $dataSize:int=int($dataFortmat.charAt(5));
			
			var startN:int;
			var dataStartN:int;
			var length:int = ($baseData.length / $baseDataPersize);
			var i:int = 0;
			var k:int = 0;
			while (i < length)
			{
				startN=i * $baseDataPersize +$baseDataOffset;
				dataStartN=i * $dataPersize+$dataOffset;
				k=0;
				while (k < $baseSize)
				{
					if(k>=$dataSize)
					{
						$baseData[startN+ k] = 1;
					}else
					{
						$baseData[startN+ k] = $data[dataStartN+k];
					}
					k++;
				};
				i++;
			};
			return $baseData;
		}
		private function createNewVect(targetSize:int,targetLen:int,baseDataInfo:Data3dInfo,dataInfo:Data3dInfo=null):Vector.<Number>
		{
			var $baseData:Vector.<Number>=baseDataInfo.data;
			var $baseDataPersize:int=baseDataInfo.dataPerSize;
			var $baseDataOffset:int=baseDataInfo.dataOffset;
			var $baseDataFortmat:String=baseDataInfo.dataFormat;
			var $baseSize:int=int($baseDataFortmat.charAt(5));
			
			var $data:Vector.<Number>=dataInfo.data;
			var $dataPersize:int=dataInfo.dataPerSize;
			var $dataOffset:int=dataInfo.dataOffset;
			var $dataFortmat:String=dataInfo.dataFormat;
			var $dataSize:int=int($dataFortmat.charAt(5));
			
			var i:int;
			var k:int;
			var step:int;
			
			var newVec:Vector.<Number>;
			var startN:int;
			var dataStartN:int;
			step = ($baseDataPersize-$baseSize + targetSize);
			
			newVec = new Vector.<Number>((targetLen * step));
			i = 0;
			while (i < targetLen)
			{
				k = 0;
				startN=i * step;
				dataStartN=i * $baseDataPersize
				while (k < $baseDataOffset)
				{
					newVec[startN + k] = $baseData[dataStartN + k];
					k++;
				};
				k=0;
				startN=i * step +$baseDataOffset;
				dataStartN=i * $dataPersize+$dataOffset
				while (k < targetSize)
				{
					if(k>=$dataSize)
					{
						newVec[startN+ k] = 1;
					}else
					{
						newVec[startN+ k] = $data[dataStartN+k];
					}
					k++;
				};
				k=0;
				startN=i * step +$baseDataOffset+targetSize;
				dataStartN=i * $baseDataPersize+$baseDataOffset+$baseSize;
				var leftNum:int=$baseDataPersize-($baseDataOffset+$baseSize);
				while (k < leftNum)
				{
					newVec[startN+ k] = $baseData[dataStartN+k];
					k++;
				};
				
				i++;
			};
			return newVec;
		}
		final public function get vertexVector():Vector.<Number>
		{
			if (!this._vertexVector)
			{
				this._vertexVector=new Vector.<Number>()
				if(this._vertexBytes)
				{
					this._vertexBytes.position = 0;
					while (this._vertexBytes.bytesAvailable)
					{
						this._vertexVector.push(this._vertexBytes.readFloat());
					}
				}
				
			}
			return (this._vertexVector);
		}
		final public function set vertexVector(value:Vector.<Number>):void
		{
			if(value!=this._vertexVector)
			{
				this._vertexVector = value;
				toUpdate();
			}
			
		}
		public function dispose():void
		{
			if(this.vertexBuffer)
			{
				this.vertexBuffer.dispose();
			}
			this.vertexBuffer=null;
			_vertexBytes=null;
			_vertexVector=null;
			_parentFrSurface=null;
		}
		public function contextEvent(context:Context3D):Boolean
		{
			if(!_toUpdate)
			{
				return true;
			}
			
			if(this.vertexBuffer)
			{
				this.vertexBuffer.dispose();
				this.vertexBuffer=null;
			}
			var vertexNum:int;
			if (this._vertexVector)
			{
				vertexNum=this._vertexVector.length / this.sizePerVertex;
				this.vertexBuffer = context.createVertexBuffer(vertexNum, this.sizePerVertex);
				this.vertexBuffer.uploadFromVector(this._vertexVector, 0, vertexNum);
				_toUpdate=false;
				return true;
			}
			else if (this._vertexBytes && this._vertexBytes.length > 0)
			{
				vertexNum=this._vertexBytes.length/4 / this.sizePerVertex
				this.vertexBuffer = context.createVertexBuffer(vertexNum, this.sizePerVertex);
				this.vertexBuffer.uploadFromByteArray(this._vertexBytes, 0, 0, vertexNum);
				_toUpdate=false;
				return true;
			}else 
			{
				return false;
			}
			
			
		}
	}
}