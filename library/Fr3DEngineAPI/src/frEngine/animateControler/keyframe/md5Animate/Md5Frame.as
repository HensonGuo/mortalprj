package frEngine.animateControler.keyframe.md5Animate
{
	import baseEngine.core.Pivot3D;
	import baseEngine.core.interfaces.IFrame;
	import baseEngine.system.Device3D;

	public class Md5Frame implements IFrame
	{
		public var boneList:Array;
		private var frameId:int=0;
		public function Md5Frame($frameId:int,$boneList:Array)
		{
			boneList=$boneList;
			frameId=$frameId;
			
		}
		
		public function cloneFrame():IFrame
		{
			return null;
		}
		
		public function seting(targetMesh:Pivot3D):void
		{
			var len:int=boneList.length;
			for (var i:int=0;i<len;i++)
			{
				boneList[i].boneResultMatrix3D.copyRawDataTo(Device3D.bones, (i * 12), true);
			};
			
		}
		
		public function get callback():Function
		{
			return null;
		}
		
		public function set callback(value:Function):void
		{
		}
	}
}