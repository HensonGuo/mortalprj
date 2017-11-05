package frEngine.loaders.away3dMd5.md5Data
{
	import flash.geom.Vector3D;

	public class VertexData
	{
		private static const defaultNormal:Vector3D=new Vector3D();
		public var index : int;
		public var s : Number;
		public var t : Number;
		public var startWeight : int;
		public var countWeight : int;
		public var pos:Vector3D;
		public var normal:Vector3D=defaultNormal;
		
	}
}