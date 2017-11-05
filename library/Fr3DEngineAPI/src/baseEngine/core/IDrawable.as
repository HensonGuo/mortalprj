


//flare.core.IDrawable

package baseEngine.core
{
    import frEngine.shader.ShaderBase;

    public interface IDrawable 
    {

        function draw(_arg1:Boolean=true, _arg2:ShaderBase=null):void;
        function get inView():Boolean;

    }
}//package flare.core

