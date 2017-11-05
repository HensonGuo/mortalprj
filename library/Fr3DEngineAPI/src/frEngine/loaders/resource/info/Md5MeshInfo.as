package frEngine.loaders.resource.info
{
	import com.gengine.resource.info.DataInfo;
	
	import frEngine.core.FrSurface3D;
	import frEngine.loaders.away3dMd5.MD5MeshByteArrayParser;
	import frEngine.loaders.away3dMd5.Skeleton;
	
	
	public class Md5MeshInfo extends DataInfo
	{
		public var materialName:String;
		public var defaultMaterial:String;
		public var vertexNum:uint;
		public var faceNum:uint;
		private var _surf:FrSurface3D;
		private var _skeleton:Skeleton;
		private var _isCompress:int=-1;
		public function Md5MeshInfo(object:Object)
		{
			super(object);
		}
		
		
		public function get surface3d():FrSurface3D
		{
			return _surf;
		}
		public function get skeleton():Skeleton
		{
			return _skeleton;
		}
		

		
		public override function dispose():void
		{
			if(_surf)
			{
				_surf.disposeImp();
				_surf=null;
			}
			if(_skeleton)
			{
				_skeleton.dispose();
				_skeleton=null;
			}
			
			super.dispose();
		}
		public override function clearCacheBytes():void
		{
			super.clearCacheBytes();
			_isCompress=-1
		}

		override public function set data(value:Object):void
		{

			super.data = value;

			_surf=new FrSurface3D("");

			var md5Parser:MD5MeshByteArrayParser=new MD5MeshByteArrayParser();
			_skeleton=md5Parser.proceedParsing(_byteArray,_surf,_isCompress);

			if(_isCompress==-1)
			{
				_isCompress=_skeleton.isCompress?1:0;
			}
			_byteArray=null;
		}
		

	}
}

