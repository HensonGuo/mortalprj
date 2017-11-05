package frEngine.core
{
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	public class FrIndexBuffer3D extends EventDispatcher
	{
		public var indexBuffer:IndexBuffer3D;
		public var _toUpdate:Boolean=true;
		public var numTriangles:int = -1;
		private var _indexBytes:ByteArray;
		private var _indexVector:Vector.<uint>;
		private var _vertexVector:Vector.<Number>;
		private var _parentFrSurface:FrSurface3D;
		public function FrIndexBuffer3D($parentFrSurface:FrSurface3D)
		{
			super();
			_parentFrSurface=$parentFrSurface;
		}
		public function toUpdate():void
		{
			_toUpdate=true;
			if(_parentFrSurface)
			{
				_parentFrSurface.needUpdate=true;
			}
			
		}
		public function contextEvent(context:Context3D):Boolean
		{
			if(!_toUpdate)
			{
				return true;
			}
			
			if(this.indexBuffer)
			{
				this.indexBuffer.dispose();
				this.indexBuffer=null;
			}
			if (this._indexVector)
			{
				this.indexBuffer = context.createIndexBuffer(this._indexVector.length);
				this.indexBuffer.uploadFromVector(this._indexVector, 0, this._indexVector.length);
				if (this.numTriangles == -1)
				{
					this.numTriangles = (this._indexVector.length / 3);
				}
				_toUpdate=false;
				return true;
			}
			else if(this._indexBytes)
			{
				this.indexBuffer = context.createIndexBuffer((this._indexBytes.length / 2));
				this.indexBuffer.uploadFromByteArray(this._indexBytes, 0, 0, (this._indexBytes.length / 2));
				if (this.numTriangles == -1)
				{
					this.numTriangles = ((this._indexBytes.length / 2) / 3);
				}
				_toUpdate=false;
				return true;
			}else
			{
				return false;
			}
			
		}
		public function get indexVector():Vector.<uint>
		{
			
			if (!this._indexVector)
			{
				this._indexVector = new Vector.<uint>();
				if (_indexBytes)
				{
					_indexBytes.position = 0;
					while (_indexBytes.bytesAvailable > 0)
					{
						this._indexVector.push(_indexBytes.readUnsignedShort(), _indexBytes.readUnsignedShort(), _indexBytes.readUnsignedShort());
					}
				}
			}
			return (this._indexVector);
		}
		
		public function set indexBytes(value:ByteArray):void
		{
			_indexBytes=value;
		}
		public function set indexVector(_arg1:Vector.<uint>):void
		{
			
			this._indexVector = _arg1;
			toUpdate();
			
		}
		public function dispose():void
		{
			if(this.indexBuffer)
			{
				this.indexBuffer.dispose();
			}
			this.indexBuffer=null;
			_parentFrSurface=null;
		}
	}
}