


//flare.core.IComponent

package baseEngine.core
{
    public interface IComponent 
    {

        function added(_arg1:Pivot3D):Boolean;
        function removed():Boolean;
		function get type():int;
		function editTargetFrame(frameIndex:int,...params):void;

    }
}//package flare.core

