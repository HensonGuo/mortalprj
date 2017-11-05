package frEngine.core
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Surface3D;
	
	import frEngine.shader.filters.FilterName_ID;

	public class FrSurface3D extends Surface3D 
	{
		
		/*public static const TANGENT0:String = "tangent0";
		public static const BITANGENT0:String = "bitangent0";
		public static const COLOR0:String = "color0";
		public static const PARTICLE0:String = "particle0";*/
		
		//public var vertexBuffers:Vector.<FrVertexBuffer3D>=new Vector.<FrVertexBuffer3D>();
		public var indexBufferFr:FrIndexBuffer3D;
		public var needUpdate:Boolean=true;

		public function FrSurface3D(name:String)
		{
			super(name);
			
		}
		
		public  function addVertexDataToTargetBuffer(vertexNameId:int, size:int,dataInfo:Data3dInfo,buffer:FrVertexBuffer3D):FrVertexBuffer3D
		{
			initTargetBuffer(buffer,vertexNameId,size,dataInfo,false);
			return buffer;
		}
		public  function addVertexData(vertexNameId:int, size:int,$isSingle:Boolean,dataInfo:Data3dInfo):FrVertexBuffer3D
		{
			var curBuffer:FrVertexBuffer3D;
			if($isSingle)
			{
				curBuffer=new FrVertexBuffer3D(this,$isSingle)
			}else
			{
				curBuffer=getNextValiableBuffer(vertexNameId,size);
				!curBuffer && (curBuffer=new FrVertexBuffer3D(this,$isSingle))
			}
			initTargetBuffer(curBuffer,vertexNameId,size,dataInfo,true);
			return curBuffer
		}

		private  function initTargetBuffer(targetBuffer:FrVertexBuffer3D,vertexNameId:int, size:int,dataInfo:Data3dInfo,toCheck:Boolean):void
		{
			var oldpersize:int=targetBuffer.sizePerVertex;
			targetBuffer.addVertexData(vertexNameId,size,dataInfo,toCheck);
			var _vo:BufferVo=targetBuffer.bufferVoMap[vertexNameId]
			this.bufferVoMap[vertexNameId]=_vo
			_vo.buffer=targetBuffer;
			
			this.sizePerVertex=this.sizePerVertex-oldpersize+targetBuffer.sizePerVertex;
			this.download();
		}

		public function getUseSameBufferVoList():Dictionary
		{
			var map:Dictionary=new Dictionary(false);
			for each( var vo:BufferVo in bufferVoMap)
			{
				var v:Array=map[vo.buffer]
				if(v==null)
				{
					map[vo.buffer]=v=new Array();
				}
				v.push(vo);
			}
			
			return map;
		}
		private function getNextValiableBuffer(vertexNameId:int,size:int=-1):FrVertexBuffer3D
		{
			var targetBuffer:FrVertexBuffer3D=getVertexBufferByNameId(vertexNameId);
			if(targetBuffer)
			{
				if(targetBuffer.bufferVoMap[vertexNameId].size==size)
				{
					throw new Error("请先删除后再添加："+vertexNameId);
				}
				return targetBuffer;
			}else
			{
				for each( var vo:BufferVo in this.bufferVoMap)
				{
					if(vo.buffer.canInsert(vertexNameId,size))
					{
						return vo.buffer;
					}
				}
				return null;
			}
			
		}

		[inline]
		final public function getVertexNum():int
		{
			for each(var vo:BufferVo in this.bufferVoMap)
			{
				if(vo.buffer && vo.buffer.sizePerVertex!=0)
				{
					return vo.buffer.vertexVector.length/vo.buffer.sizePerVertex;
				}
			}
			return 0;	
		}
		[inline]
		final public function getVertexBufferByNameId(flagNameID:int):FrVertexBuffer3D
		{
			if(bufferVoMap[flagNameID])
			{
				return bufferVoMap[flagNameID].buffer;
			}else
			{
				return null;
			}
			

		}
		public override function clone():Surface3D
		{
			var _local1:FrSurface3D = new FrSurface3D(this.name+"_clone");
			_local1.indexBufferFr=this.indexBufferFr;
			_local1.numTriangles = this.numTriangles;
			_local1.firstIndex = this.firstIndex;
			_local1.sizePerVertex=this.sizePerVertex;
			_local1.bufferVoMap=this.bufferVoMap;
			//_local1.material =this.material; 
			
			return (_local1);
		}
		
		
		public override function disposeImp():void
		{
			disposeVertextBuffer();
			indexBufferFr.dispose();
			indexBufferFr=null;
			super.disposeImp();
		}
		public override function clear():void
		{
			disposeVertextBuffer();
			indexBufferFr && indexBufferFr.dispose();
			indexBufferFr=new FrIndexBuffer3D(this);
			this.download();
			super.clear();
		}
		public override function get hasUpload():Boolean
		{
			return this.scene!=null && !needUpdate;
		}
		private function disposeVertextBuffer():void
		{
			if (this.bufferVoMap)
			{
				for each(var vo:BufferVo in this.bufferVoMap)
				{
					vo.buffer.dispose();
				}
			};
			this.bufferVoMap=new Dictionary(false);
		}
		public override function upload(_arg1:Scene3D):void
		{
			if(needUpdate)
			{
				_scene=null;
				needUpdate=false;
			}
			super.upload(_arg1);
		}
		protected override function contextEvent(e:Event=null):Boolean
		{
		
			if(!indexBufferFr)
			{
				return false;
			}
			var hasUploadSuccess:Boolean=true;
			
			for each(var vo:BufferVo in this.bufferVoMap)
			{
				if(vo.buffer._toUpdate)
				{
					hasUploadSuccess &&=vo.buffer.contextEvent(this.scene.context);
				}
			}

			if(indexBufferFr._toUpdate)
			{
				hasUploadSuccess &&=indexBufferFr.contextEvent(this.scene.context);
			}
			
			if(hasUploadSuccess)
			{
				dispatchEvent(new Event("upload"));
			}
			
			return hasUploadSuccess;
			
		}
		
		public override function updateBoundings():Boundings3D
		{
			var dx:Number;
			var dy:Number;
			var dz:Number;
			var temp:Number;
			var x:Number;
			var y:Number;
			var z:Number;
			
			this.bounds = new Boundings3D();
			this.bounds.min.setTo(10000000, 10000000, 10000000);
			this.bounds.max.setTo(-10000000, -10000000, -10000000);
			
			var __positionVertexBuffer:FrVertexBuffer3D=this.getVertexBufferByNameId(FilterName_ID.POSITION_ID);
			if(!__positionVertexBuffer)
			{
				return this.bounds;
			}
			
			var __vertexVector:Vector.<Number>=__positionVertexBuffer.vertexVector;
			
			var __sizePerVertex:int=__positionVertexBuffer.sizePerVertex;
			var l:int = __vertexVector.length;
			var i:int = __positionVertexBuffer.bufferVoMap[FilterName_ID.POSITION_ID].offset
			while (i < l)
			{
				x = __vertexVector[i];
				y = __vertexVector[(i + 1)];
				z = __vertexVector[(i + 2)];
				if (x < this.bounds.min.x)
				{
					this.bounds.min.x = x;
				};
				if (y < this.bounds.min.y)
				{
					this.bounds.min.y = y;
				};
				if (z < this.bounds.min.z)
				{
					this.bounds.min.z = z;
				};
				if (x > this.bounds.max.x)
				{
					this.bounds.max.x = x;
				};
				if (y > this.bounds.max.y)
				{
					this.bounds.max.y = y;
				};
				if (z > this.bounds.max.z)
				{
					this.bounds.max.z = z;
				};
				i = (i + __sizePerVertex);
			};
			
			
			this.bounds.length.x = (this.bounds.max.x - this.bounds.min.x);
			this.bounds.length.y = (this.bounds.max.y - this.bounds.min.y);
			this.bounds.length.z = (this.bounds.max.z - this.bounds.min.z);
			this.bounds.center.x = ((this.bounds.length.x * 0.5) + this.bounds.min.x);
			this.bounds.center.y = ((this.bounds.length.y * 0.5) + this.bounds.min.y);
			this.bounds.center.z = ((this.bounds.length.z * 0.5) + this.bounds.min.z);
			
			this.bounds.radius = int(this.bounds.length.length/2);
			return this.bounds;
		}
		

		public function get indexVector():Vector.<uint>
		{
			return indexBufferFr.indexVector;
		}
		public function set indexVector(_arg1:Vector.<uint>):void
		{
			indexBufferFr.indexVector=_arg1;
		}
		public function set indexBytes(value:ByteArray):void
		{
			indexBufferFr.indexBytes=value;
		}
	}
}

