package frEngine.shader.registType
{

	import baseEngine.basic.Scene3D;
	import baseEngine.core.Texture3D;
	
	import frEngine.shader.registType.base.RegistParam;

	public class FsParam extends RegistParam
	{

		public function FsParam($index:int,$newVarName:String,$defaultValue:Texture3D)
		{
			super("fs"+$index,$index,$newVarName,false,$defaultValue);
		}
		
		public function clone():FsParam
		{
			return new FsParam(this.index,this.paramName,null);
		}
		public function upload(scene:Scene3D,toCheck:Boolean=true):void
		{
			if(value==null)
			{
				return;
			}
			if(value.texture==null)
			{
				value.upload(scene,toCheck);
			}
		}

	}
}