package Framework.Serialize
{
	import Framework.Util.Exception;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SerializeStream
	{
		public function SerializeStream()
		{
			byteArray = new ByteArray();
		}
		
		public function readByte():int
		{
			var iTemp:int = _byteArray.readByte();
			if(iTemp < 0)
			{
				return iTemp + 256;
			}
			else
			{
				return iTemp;
			}
		}
		
		public function readByteSeq() : Array
		{
			var array:Array = new Array();
			var size : int = readSize();
			for( var i : int = 0 ; i < size ; i ++ )
			{
				array.push( readByte() );
			}
			return array;
		}
		
		public function writeByte(v:int):void
		{
			_byteArray.writeByte(v);
		}
		
		public function writeByteSeq( v : Array ) : void
		{
			if( v == null )
			{
				writeSize( 0 );
				return;
			}
			writeSize( v.length );
			for( var i : int = 0 ; i < v.length ; i ++ )
			{
				this.writeByte( v[i] );
			}
		}
		
		public function writeBool(v:Boolean):void
		{
			if(v){
				_byteArray.writeByte(1);
			}else{
				_byteArray.writeByte(0);	
			} 	
		}
		
		public function writeBoolSeq( v : Array ) : void
		{
			if( v == null )
			{
				writeSize( 0 );
				return;
			}
			writeSize( v.length );
			for( var i : int = 0 ; i < v.length ; i ++ )
			{
				this.writeBool( v[i] );
			}
		}
		
		public function readBool():Boolean
		{
			var v : int = _byteArray.readByte();
			return !v == 0;	
		}
		public function readBoolSeq():Array
		{
			var array:Array = new Array();
			var size : int = readSize();
			for( var i : int = 0 ; i < size ; i ++ )
			{
				array.push( readBool() );
			}
			return array;
		}
		  
		public function readSize() : int 
		{
			var size : int = _byteArray.readUnsignedByte();
			if( size == 255 )
			{
				return _byteArray.readInt();
			}
			return size;
		}
		
		public function writeSize( v : int ) : void
		{
			if( v < 255 )
			{
				_byteArray.writeByte( v );
			}
			else
			{
				_byteArray.writeByte( 255 );
				_byteArray.writeInt( v );
			}
		}
		
		public function readInt() : int
		{
			return _byteArray.readInt();
		}
		
		public function readIntSeq():Array
		{
			var array:Array = new Array();
			var size : int = readSize();
			for( var i : int = 0 ; i < size ; i ++ )
			{
				array.push( readInt() );
			}
			return array;
		}
		
		public function writeInt( v : int ) : void
		{
			_byteArray.writeInt( v );
		}
		
		public function writeIntSeq( v : Array ) : void
		{
			if( v == null )
			{
				writeSize( 0 );
				return;
			}
			writeSize( v.length );
			for( var i : int = 0 ; i < v.length ; i ++ )
			{
				writeInt( v[i] );
			}
		}
		
		public function readShort() : int
		{		
			return _byteArray.readShort() ;
		}
		
		public function readShortSeq() : Array
		{
			var array : Array = new Array();
			var size : int = readSize();
			for( var i : int = 0 ; i < size ; i ++ )
			{
				array.push( this.readShort() );
			}
			return array;
		}
		
		public function writeShort( v : int ) : void
		{
			_byteArray.writeShort( v );
		}
		
		public function writeShortSeq( v : Array ) : void
		{
			if( v == null )
			{
				writeSize( 0 );
				return;
			}
			writeSize( v.length );
			for( var i : int = 0 ; i < v.length ; i ++ )
			{
				writeShort( v[i] );
			}
		}
		
		public function readLong() : Number
		{
			var small : uint = _byteArray.readInt();
			var big : int = _byteArray.readInt() ;
			return big * ( uint.MAX_VALUE + 1 ) + small;
		}
		
		public function readLongSeq() : Array
		{
			var array:Array = new Array();
			var size : int = readSize();
			for( var i : int = 0 ; i < size ; i ++ )
			{
				array.push( this.readLong() );
			}
			return array;
		}
		
		public function writeLong( v : Number ) : void
		{
			
			var small : uint =  v % ( uint.MAX_VALUE + 1 ) ;
			var big : int = v / ( uint.MAX_VALUE + 1 ) ;
			if( v >= 0 )
			{
				_byteArray.writeUnsignedInt( small );
				_byteArray.writeInt( big );
			}
			else
			{
				if( big == 0 )
				{
					_byteArray.writeUnsignedInt( v );
					_byteArray.writeInt( -1 );
				}
				else
				{
					_byteArray.writeUnsignedInt( small );
					_byteArray.writeInt( big );
				}
			}
			
		}
		
		public function writeLongSeq( v : Array ) : void
		{
			if( v == null )
			{
				writeSize( 0 );
				return;
			}
			writeSize( v.length );
			for( var i : int = 0 ; i < v.length ; i ++ )
			{
				writeLong( v[i] );
			}
		}
		
		public function readString() : String 
		{
			var size : int = readSize();
			return this._byteArray.readUTFBytes( size );
		}
		
		public function readStringSeq() : Array 
		{
			var array : Array = new Array();
			var size : int = readSize();
			for( var i : int = 0 ; i < size ; i ++ )
			{
				array.push( readString() );
			}
			return array;
		}
		
		public function writeString( v : String ) : void
		{
			if( null == v )
			{
				this.writeSize( 0 );
				return;
			}
			var array : ByteArray = new ByteArray();
			array.writeUTFBytes( v );
			writeSize( array.length );
			_byteArray.writeBytes( array );
		}
		
		public function writeStringSeq( v : Array ) : void
		{
			if( null == v )
			{
				this.writeSize( 0 );
				return;
			}
			writeSize( v.length );
			for( var i : int = 0 ; i < v.length ; i ++ )
			{
				writeString( v[i] );
			}
		}
		
		public function readFloat():Number
		{
			return _byteArray.readFloat();
		}
		
		public function readFloatSeq() : Array
		{
			var array : Array = new Array();
			var size : int = readSize();
			for( var i : int = 0 ; i < size ; i ++ )
			{
				array.push( readFloat() );
			}
			return array;
		}
		
		public function writeFloat(v:Number):void
		{
			_byteArray.writeFloat(v);	
		}
		
		public function writeFloatSeq( v : Array ) : void
		{
			if( v == null )
			{
				writeSize( 0 );
				return;
			}
			writeSize( v.length );
			for( var i : int = 0 ; i < v.length ; i ++ )
			{
				writeFloat( v[i] );
			}
		}
		
		public function readDouble():Number
		{
			return _byteArray.readDouble();
		}
		
		public function readDoubleSeq() : Array
		{
			var array : Array = new Array();
			var size : int = readSize();
			for( var i : int = 0 ; i < size ; i ++ )
			{
				array.push( readDouble() );
			}
			return array;
		}
		
		public function writeDouble(v:Number):void
		{
			_byteArray.writeDouble(v);	
		}
		
		public function writeDoubleSeq( v : Array ) : void
		{
			if( v == null )
			{
				writeSize( 0 );
				return;
			}
			writeSize( v.length );
			for( var i : int = 0 ; i < v.length ; i ++ )
			{
				writeDouble( v[i] );
			}
		}
		
		public function readDate():Date
		{
			return new Date( readInt()*1000 );
		}
		
		public function readDateSeq() : Array
		{
			var array : Array = new Array();
			var size : int = readSize();
			for( var i : int = 0 ; i < size ; i ++ )
			{
				array.push( readDate() );
			}
			return array;
		}
		
		public function writeDate(v:Date):void
		{
			_byteArray.writeInt( v.time / 1000 );	
		}
		
		public function writeDateSeq( v : Array ) : void
		{
			if( v == null )
			{
				writeSize( 0 );
				return;
			}
			writeSize( v.length );
			for( var i : int = 0 ; i < v.length ; i ++ )
			{
				writeDate( v[i] );
			}
		}
		
		public function writeByteArray( v : SerializeStream ):void
		{
			byteArray.writeBytes( v.byteArray );
		}
		
		public function writeException( ex:Exception ):void
		{
			this.writeString( ex.message );
			this.writeInt( ex.code );
		}
		
		public function readException( ex:Exception ):void
		{
			ex.message = this.readString();
			ex.code = this.readInt();
		}
		

		public function startSeq(  numElements : int , minSize : int ) : void
		{
			if( numElements == 0 )
			{
				return;
			}
		    var sd : SeqData = new SeqData(numElements, minSize);
		    sd.previous = _seqDataStack;
		    _seqDataStack = sd;
			
		    var bytesLeft : int = this.getBytesLeft();
			
		    if( _seqDataStack.previous == null )
		    {
				if( numElements * minSize > bytesLeft ) 
				{
					throw new SerializeException();
				}
		    }
		    else
		    {
				checkSeqLen(bytesLeft);
		    }
		}
		
		public function checkSeq() : void
		{
			 checkSeqLen( getBytesLeft() );
		}
		
		public function checkSeqLen( bytesLeft : int ) : void
		{
		    var size : int = 0;
		    var sd : SeqData = _seqDataStack;
		    do
		    {
				size += (sd.numElements - 1) * sd.minSize;
				sd = sd.previous;
		    }
		    while( sd != null );
			
		    if(size > bytesLeft)
		    {
				throw new SerializeException();
		    }
		}
		
		public function endElement() : void
		{
			--_seqDataStack.numElements;
		}
		
		public function endSeq( sz : int) : void
		{
			if(sz == 0) // Pop only if something was pushed previously.
		    {
				return;
		    }
		    _seqDataStack = _seqDataStack.previous;
		}
		
		public function checkFixedSeq( numElements : int , elemSize : int ) : void
		{
			var bytesLeft : int = getBytesLeft();
		    if( _seqDataStack == null )
		    {
				if(numElements * elemSize > bytesLeft) 
				{
					throw new SerializeException();
				}
		    }
		    else
		    {
				checkSeqLen (bytesLeft - numElements * elemSize);
		    }
		}
		
		public function getBytesLeft() : int
		{
			return byteArray.length - byteArray.position;
		}
		public function clear():void
		{
			this.byteArray = new ByteArray();
		}
		
		private var _byteArray : ByteArray;
		private var _seqDataStack : SeqData = null;
		
		public function set byteArray( v : ByteArray ) : void
		{
			_byteArray = v;
			_byteArray.endian = Endian.LITTLE_ENDIAN;
		}
		public function get byteArray() : ByteArray
		{
			return _byteArray;
		}
	}
}