


//flare.system.Device3D

package baseEngine.system
{
    import flash.display.BitmapData;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DTriangleFace;
    import flash.geom.Matrix3D;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    import __AS3__.vec.Vector;
    
    import baseEngine.basic.Scene3D;
    import baseEngine.core.Camera3D;
    import baseEngine.materials.Material3D;
    
    import frEngine.shader.filters.FilterName;
    import frEngine.shader.registType.FcParam;
    import frEngine.shader.registType.MaxtrixParam;
    import frEngine.shader.registType.VcParam;
    import frEngine.shader.registType.base.ConstParamBase;

    public final class Device3D 
    {
		public static var openSunLight:Boolean=false;
		public static var isOpenGL:Boolean = false;
        public static const global:Matrix3D = new Matrix3D();
        public static const invGlobal:Matrix3D = new Matrix3D();
        public static const view:Matrix3D = new Matrix3D();
        public static const cameraGlobal:Matrix3D = new Matrix3D();
       
        public static const worldViewProj:Matrix3D = new Matrix3D();
        public static const worldView:Matrix3D = new Matrix3D();
        public static const proj:Matrix3D = new Matrix3D();
		public static const temporal0:Matrix3D = new Matrix3D();
		
		private static const _vcConst1:Vector.<Number>=Vector.<Number>([0,0.5,1,2]);
		private static const _fcConst1:Vector.<Number>=Vector.<Number>([0,0.001,1,0.5]);
		public static const viewPortWH:Vector.<Number> = Vector.<Number>([1024,600,0.01,0.1]);
		public static var  viewPortW:Number = 1024;
		public static var  viewPortH:Number = 600;
        /*public static const special0:Matrix3D = new Matrix3D();
        public static const special1:Matrix3D = new Matrix3D();
        public static const special2:Matrix3D = new Matrix3D();
        public static const temporal1:Matrix3D = new Matrix3D();*/
        public static const bones:Vector.<Number> = new Vector.<Number>(((maxBonesPerSurface * 4) * 3));
       // public static const random:Vector.<Number> = new Vector.<Number>(4, true);

      //  public static const sin_time:Vector.<Number> = new Vector.<Number>(4, true);
      //  public static const cos_time:Vector.<Number> = new Vector.<Number>(4, true);
       // public static const mouse:Vector.<Number> = new Vector.<Number>(4, true);
       // public static const cam:Vector.<Number> = new Vector.<Number>(4, true);
      //  public static const nearFar:Vector.<Number> = new Vector.<Number>(4, true);
      //  public static const screen:Vector.<Number> = new Vector.<Number>(4, true);
		
		
		
		public static var animateSpeedFrame:int = 33;
        public static var profile:String = "baseline";
		public static var scene:Scene3D;
		
        public static var camera:Camera3D;
        
        public static var drawCalls3d:int;
		public static var drawCalls2d:int;
		
        public static var trianglesDrawn:int;
        public static var objectsDrawn:int;
        private static var _maxBonesPerVertex:int = 2;
        public static var maxBonesPerSurface:int = 37;
        public static var nullBitmapData:BitmapData = new BitmapData(64, 64, false, 0xFF0000);
        private static var h:int = 0;
        private static var v:int;
        public static var maxTextureSize:int = 0x0800;
       // public static var frameCount:int;

        public static const defaultCullFace:String = Context3DTriangleFace.BACK;//"back"
        public static var usedSamples:int;
        public static var usedBuffers:int;
        public static var lastMaterial:Material3D;
        public static var invertCullMode:Boolean = false;
        public static var ignoreStates:Boolean = false;
		
		public static var fps:uint=0;
        {
            while (h < 8)
            {
                v = 0;
                while (v < 8)
                {
                    nullBitmapData.fillRect(new Rectangle((h * 8), (v * 8), 8, 8), ((((((h % 2) + (v % 2)) % 2) == 0)) ? 0xFFFFFF : 0xB0B0B0));
                    v++;
                };
                h++;
            };
        }

        public static function get maxBonesPerVertex():int
        {
            return (_maxBonesPerVertex);
        }
        public static function set maxBonesPerVertex(_arg1:int):void
        {
            if ((((_arg1 < 1)) || ((_arg1 > 4))))
            {
                throw (new Error(("maxBonesPerVertex should be from 1 to 4 but was set to " + _arg1)));
            };
            _maxBonesPerVertex = _arg1;
        }
		
		public static var  viewProjValue:Matrix3D=new Matrix3D();
		
		public static const VcConst1Register2:VcParam=new VcParam(122,FilterName.viewPortRect,false,viewPortWH)
		public static const CameraViewProjRegister:MaxtrixParam=new MaxtrixParam(Context3DProgramType.VERTEX,123,FilterName.viewProj,false,viewProjValue);
		public static const VcConst1Register:VcParam=new VcParam(127,FilterName.vcConst1,false,_vcConst1)
		
		public static const FcConst1Register:FcParam=new FcParam(27,FilterName.fcConst1,false,_fcConst1);
		
		public static const FcDirLightRegister:FcParam=new FcParam(26,FilterName.dirLight,false,null);
		public static const FcDirColorRegister:FcParam=new FcParam(25,FilterName.dirColor,false,null);
		public static const FcAmbientColorRegister:FcParam=new FcParam(24,FilterName.ambientColor,false,null);
		
		/*public static function get viewProjValue():Matrix3D
		{
			return _viewProjValue;
		}*/
		public static function setViewProj(value:Matrix3D):void
		{
			viewProjValue.copyFrom(value);
			
			if(scene.context)
			{
				var m:MaxtrixParam=Device3D.CameraViewProjRegister;
				scene.context.setProgramConstantsFromMatrix(m.type, m.index, m.value, true);
			}
		}
		
		public static function setViewPortRect(w:int,h:int):void
		{
			viewPortWH[0]=viewPortW=w;
			viewPortWH[1]=viewPortH=h;
			if(scene.context)
			{
				var param:ConstParamBase=Device3D.VcConst1Register2;
				scene.context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, param.index, param.value,1);
			}
			
		}
		
		public static function setVcConst(index:int,value:Number):void
		{
			_vcConst1[index]=value;
			if(scene.context)
			{
				var param:ConstParamBase=Device3D.VcConst1Register;
				scene.context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, param.index, param.value,1);
			}
		}
		
		public static function setFcConst(index:int,value:Number):void
		{
			_fcConst1[index]=value;
			if(scene.context)
			{
				var param:ConstParamBase=Device3D.FcConst1Register;
				scene.context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, param.index, param.value,1);
			}
		}
		public static function uploadGlobleParams():void
		{
			
			var _context:Context3D=scene.context;
			var m:MaxtrixParam=Device3D.CameraViewProjRegister;
			_context.setProgramConstantsFromMatrix(m.type, m.index, m.value, true);
			var param:ConstParamBase=Device3D.FcConst1Register;
			_context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, param.index, param.value,1);
			param=Device3D.VcConst1Register;
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, param.index, param.value,1);
			param=Device3D.VcConst1Register2;
			_context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, param.index, param.value,1);
		}
		private static const vcReg:RegExp=new RegExp(FilterName.viewProj+"|"+FilterName.viewPortRect+"|"+FilterName.vcConst1,"gi");
		private static const fcReg:RegExp=new RegExp(FilterName.fcConst1+"|"+FilterName.dirLight+"|"+FilterName.dirColor+"|"+FilterName.ambientColor,"gi");
		
		private static var _globleRegistsMap:Dictionary;
		private static function get globleRegistsMap():Dictionary
		{
			if(!_globleRegistsMap)
			{
				_globleRegistsMap=new Dictionary(false);
				_globleRegistsMap[FilterName.viewProj]=Device3D.CameraViewProjRegister.registName;
				_globleRegistsMap[FilterName.viewPortRect]=Device3D.VcConst1Register2.registName;
				_globleRegistsMap[FilterName.vcConst1]=Device3D.VcConst1Register.registName;
				
				_globleRegistsMap[FilterName.fcConst1]=Device3D.FcConst1Register.registName;
				_globleRegistsMap[FilterName.dirLight]=Device3D.FcDirLightRegister.registName;
				_globleRegistsMap[FilterName.dirColor]=Device3D.FcDirColorRegister.registName;
				_globleRegistsMap[FilterName.ambientColor]=Device3D.FcAmbientColorRegister.registName;
			}
			return _globleRegistsMap;
		}
		public static function replaceVertexCode(vertexCode:String):String
		{
			var arr:Array=vertexCode.match(vcReg);
			var _map:Dictionary=globleRegistsMap
			for each(var p:String in arr)
			{
				var reg:RegExp=new RegExp(p,"gi");
				vertexCode=vertexCode.replace(reg,_map[p]);
			}
			return vertexCode;
		}
		public static function replaceFragmentCode(fragmentCode:String):String
		{
			var arr:Array=fragmentCode.match(fcReg);
			var _map:Dictionary=globleRegistsMap
			for each(var p:String in arr)
			{
				var reg:RegExp=new RegExp(p,"gi");
				fragmentCode=fragmentCode.replace(reg,_map[p]);
			}
			return fragmentCode;
		}
    }
}//package flare.system

