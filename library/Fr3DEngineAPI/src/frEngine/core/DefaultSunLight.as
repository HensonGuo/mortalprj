package frEngine.core
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Vector3D;
	
	import baseEngine.system.Device3D;
	
	import frEngine.shader.registType.FcParam;

	public class DefaultSunLight extends FrLight3D
	{
		private var FcDirLightRegister:FcParam
		private var FcDirColorRegister:FcParam
		private var FcAmbientColorRegister:FcParam
		
		private var dirLight:Vector.<Number>=new Vector.<Number>(4,true);
		public function DefaultSunLight()
		{
			super("Default Sun Light", FrLight3D.DIRECTIONAL);
			this.infinite = true;
			FcDirLightRegister=Device3D.FcDirLightRegister
			FcDirColorRegister=Device3D.FcDirColorRegister;
			FcAmbientColorRegister=Device3D.FcAmbientColorRegister
		}
		public function init():void
		{
			setColor(0x999999);
			setAmbientColor(0x999999);
			setDirLight(new Vector3D(1,1,-1));
		}
		public function setDirLight(dir:Vector3D):void
		{
			dir.normalize();
			dirLight[0] = dir.x;
			dirLight[1] = dir.y;
			dirLight[2] = dir.z;
			var _context:Context3D=Device3D.scene.context;
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, FcDirLightRegister.index, dirLight,1);
		}
		public function setColor($color:uint):void
		{
			var colorSclae:Number=1/ 0xFF
			this.color[0] = (($color & 0xFF0000) >> 16)*colorSclae ;
			this.color[1] = (($color & 0xFF00) >> 8)*colorSclae;
			this.color[2] = ($color & 0xFF)*colorSclae;
			
			var _context:Context3D=Device3D.scene.context;
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, FcDirColorRegister.index, this.color,1);
		}
		public function setAmbientColor($color:uint):void
		{
			var colorSclae:Number=1/ 0xFF
			this.ambientColor[0] = (($color & 0xFF0000) >> 16)*colorSclae ;
			this.ambientColor[1] = (($color & 0xFF00) >> 8)*colorSclae;
			this.ambientColor[2] = ($color & 0xFF)*colorSclae;
			
			var _context:Context3D=Device3D.scene.context;
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, FcAmbientColorRegister.index, this.ambientColor,1);
		}
	}
}