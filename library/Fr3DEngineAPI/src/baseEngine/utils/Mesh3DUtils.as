


//flare.utils.Mesh3DUtils

package baseEngine.utils
{
    import __AS3__.vec.Vector;
    
    import baseEngine.core.Mesh3D;
    import baseEngine.core.Pivot3D;
    import baseEngine.materials.Material3D;

    public class Mesh3DUtils 
    {

        public static function cloneMaterials(_arg1:Pivot3D):void
        {
            _arg1.forEach(cloneMaterialsAux, Mesh3D);
        }
        private static function cloneMaterialsAux(_arg1:Mesh3D):void
        {
            
        }
        public static function merge(_arg1:Vector.<Pivot3D>, _arg2:Boolean=true, _arg3:Material3D=null, _arg4:Boolean=false):Mesh3D
        {
            return null;
			
        }
        public static function split(_arg1:Mesh3D):void
        {
			
        }

    }
}//package flare.utils

