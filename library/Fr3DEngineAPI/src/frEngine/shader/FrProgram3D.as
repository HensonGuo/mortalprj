package frEngine.shader
{
	
	import flash.display3D.Program3D;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.shader.registType.FcParam;
	import frEngine.shader.registType.FsParam;
	import frEngine.shader.registType.MaxtrixParam;
	import frEngine.shader.registType.VaParam;
	import frEngine.shader.registType.VcParam;
	
	
	
	public class FrProgram3D
	{
		public var program:Program3D;
		public var VcParamsConstList:Vector.<VcParam>;
		public var FcParamsConstList:Vector.<FcParam>;
		public var paramsMaxtrixList:Vector.<MaxtrixParam>;
		public var textures:Vector.<FsParam>;
		public var VaParamsList:Vector.<VaParam>;
		public var textureRepeat:Boolean;
		private var _programeId:String;
		private var _instanceRegister:Program3dRegisterInstance;
		
		public function FrProgram3D($textureRepeat:Boolean,$pid:String,$instanceRegister:Program3dRegisterInstance)
		{
			textureRepeat=$textureRepeat;
			_programeId=$pid;
			instanceRegister=$instanceRegister;
		}
		public function get programeId():String
		{
			return _programeId;
		}
		public function set instanceRegister($instance:Program3dRegisterInstance):void
		{
			_instanceRegister=$instance;
			if(!$instance)
			{
				return;
			}
			
			program =_instanceRegister.program;
			VcParamsConstList=_instanceRegister.VcParamsConstList;
			FcParamsConstList=_instanceRegister.FcParamsConstList;
			paramsMaxtrixList=_instanceRegister.paramsMaxtrixList;
			textures=_instanceRegister.textures;
			VaParamsList=_instanceRegister.VaParamsList;
		}
		public function get instanceRegister():Program3dRegisterInstance
		{
			return _instanceRegister;
		}
		
		public function dispose():void
		{

			/*for each(var vc:VcParam in VcParamsConstList)
			{
				vc.dispose();
			}
			for each(var fc:FcParam in FcParamsConstList)
			{
				fc.dispose();
			}
			for each(var mc:MaxtrixParam in paramsMaxtrixList)
			{
				mc.dispose();
			}
			for each(var fs:FsParam in textures)
			{
				fs.dispose();
			}
			for each(var va:VaParam in VaParamsList)
			{
				va.dispose();
			}*/
			
			VcParamsConstList=null;
			FcParamsConstList=null;
			paramsMaxtrixList=null;
			textures=null;
			VaParamsList=null;
			Resource3dManager.instance.pushPrograme3DtoPool(_instanceRegister,this.textureRepeat);
			_instanceRegister=null;
			
		}
		public function getParamByName($name:String,isVertex:Boolean):*
		{
			if(!_instanceRegister)
			{
				return null;
			}else
			{
				return _instanceRegister.getParamByName($name,isVertex);
			}
			
		}
	}
}