package frEngine.shader.filters
{
	import baseEngine.core.Texture3D;
	
	import frEngine.shader.Program3dRegisterInstance;

	public class FilterBase
	{

		/*public var vertexCode:String="";
		public var framentCode:String="";*/
		public var texture3DList:Vector.<Texture3D>;
		public var type:int=0;
		
		private var _priority:int=0;
		public static const ATLFormat:Array=["",",dxt1",",dxt5","",""];

		public function setRegisterParams(program:Program3dRegisterInstance):void
		{
			throw new Error("请覆盖重写getParams方法<from FilerBase.as>");
			return null;
		}
		public function FilterBase(_type:int,$priority:int,$texture3DList:Array=null)
		{
			type=_type;
			_priority=$priority;
			$texture3DList=$texture3DList?$texture3DList:[];
			texture3DList=Vector.<Texture3D>($texture3DList);
		}
		public function get programeId():String
		{
			throw new Error("请覆盖重写getParams方法<from FilerBase.as>");
			return null;
		}
		public function get priority():int
		{
			return _priority;
		}
		public function getParams():XML
		{
			throw new Error("请覆盖重写getParams方法<from FilerBase.as>");
			return null;
		}
		public function dispose():void
		{
			if(texture3DList)
			{
				for(var i:int=0;i<texture3DList.length;i++)
				{
					var t:Texture3D=texture3DList[i];
					t.dispose();
				}
			}
			
			texture3DList=null;
		}
		public function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			return "";
		}
		public function createFragmentUvCoord(frprogram:Program3dRegisterInstance):String
		{
			return "";
		}
		public function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			return "";
		}
		
		public static function getSmapleString(fsName:String,format:int,uvRepeart:Boolean,mip:int):String
		{
			var typeMode:String=true ?"2d":"cube";
			var linear:String="linear";//mip==Texture3D.MIP_LINEAR ?"linear":"nearest";
			var mipFalg:String=(mip==Texture3D.MIP_NONE ?"mipnone":"miplinear");
			var repeart:String=uvRepeart ? "repeat":"clamp";
			var atlFormat:String=ATLFormat[format];
			return fsName+" <"+typeMode+","+linear+","+mipFalg+","+repeart+atlFormat+">";
		}
		
		public function clone():FilterBase
		{
			return this;
		}
		
	}
}