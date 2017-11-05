package frEngine.loaders.resource.info
{
	import com.gengine.resource.info.DataInfo;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import frEngine.core.FrSurface3D;
	import frEngine.shader.filters.FilterName_ID;
	

	public class MeshInfo extends DataInfo
	{
		
		
		public var meshName:String;
		public var defaultMaterial:String;
		public var vertexNum:uint;
		public var faceNum:uint;
		public var version:uint;
		public var useAlpha:Boolean
		private var _surf:FrSurface3D;
		
		
		public function MeshInfo(object:Object)
		{
			super(object);
		}
		

		public function get surface3d():FrSurface3D
		{
			return _surf;
		}

		public override function dispose():void
		{
			if(_surf)
			{
				_surf.disposeImp();
				_surf=null;
			}
			super.dispose();
		}
		override public function set data(value:Object):void
		{
			super.data = value;
			_byteArray.position=0;
			_byteArray.endian=Endian.LITTLE_ENDIAN;
			
			var headId:uint= _byteArray.readUnsignedShort();
			version= _byteArray.readUnsignedShort();

			if(checkIsCompressMesh(headId,version))
			{
				_byteArray.position=0;
				_byteArray.uncompress();
				headId= _byteArray.readUnsignedShort();
				version= _byteArray.readUnsignedShort();
			}
			
			var hasNormal:Boolean= Boolean(headId & 0x1)
			useAlpha=Boolean(headId & 0x10);

			_surf=new FrSurface3D(this.name);
			
			parserNormaMesh(_surf,hasNormal,useAlpha);
			
			_byteArray=null;
		}
		
		public static function checkIsCompressMesh(head1:uint,head2:uint):Boolean
		{
			var isNormal:Boolean;
			if(head1==0 || head1==0x1000 || (head1 & 0x1) || (head1 &0x10))
			{
				if(head2==1)
				{
					isNormal=true;
				}else
				{
					isNormal=false;
				}
			}else
			{
				isNormal=false;
			}
			return !isNormal;
		}
		
		private function parserNormaMesh(surface:FrSurface3D,hasNormal:Boolean,hasAlpha:Boolean):FrSurface3D
		{
			
			meshName= readString(_byteArray);
			surface.name=meshName;
			defaultMaterial= readString(_byteArray);
			hasNormal= (_byteArray.readByte()==1 || hasNormal);
			vertexNum= _byteArray.readUnsignedShort();
			faceNum= _byteArray.readUnsignedShort();
			
			//trace(headId,version,objName,material,hasNormal,vertexNum,faceNum);

			var _targetVertexBytes:ByteArray=new ByteArray();
			_targetVertexBytes.endian=Endian.LITTLE_ENDIAN;
			var _targetIndexBytes:ByteArray=new ByteArray();
			_targetIndexBytes.endian=Endian.LITTLE_ENDIAN;
			
			var perNum:int=2;
			var vertextPerNum:int=hasAlpha?4:3;
			perNum+=vertextPerNum;
			hasNormal && (perNum+=3);
			
			_byteArray.readBytes(_targetVertexBytes,0,vertexNum*perNum*4);
			_byteArray.readBytes(_targetIndexBytes,0,faceNum*3*2);

			if(hasNormal)
			{
				surface.addVertexData(FilterName_ID.POSITION_ID,vertextPerNum,false,null);
				surface.addVertexData(FilterName_ID.UV_ID,2,false,null);
				surface.addVertexData(FilterName_ID.NORMAL_ID,3,false,null);
			}else
			{
				surface.addVertexData(FilterName_ID.POSITION_ID,vertextPerNum,false,null);
				surface.addVertexData(FilterName_ID.UV_ID,2,false,null);
			}
			
			surface.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexBytes=_targetVertexBytes;
			surface.indexBytes=_targetIndexBytes;
			
			
			return surface;

		}
		
		public static function readString(stream:ByteArray):String
		{
			var result:String;
			var n:int=0;
			var pos:uint=stream.position;
			var maxNum:int=10000;
			while(n<maxNum)
			{
				result=stream.readMultiByte(1,"gb2312")
				if (result == "\\")
				{
					var bytesNum:int=stream.position-pos-1;
					stream.position=pos;
					result=stream.readMultiByte(bytesNum,"gb2312");
					stream.position+=2;
					break;
				}
				n++;
			}
			if(n==maxNum)
			{
				throw new Error("3dmax输出有误，字符串没有加\\");
			}
			return result;
		}
		
	}
}