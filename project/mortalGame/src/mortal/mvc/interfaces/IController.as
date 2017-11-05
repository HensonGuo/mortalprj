/**
 * @date	2011-3-4 下午03:31:38
 * @author  jianglang
 *
 */	

package mortal.mvc.interfaces
{
	public interface IController
	{
		function get view():IView;
		function set view(value:IView):void;
		function popup():void;
		function get isViewShow():Boolean;
	}
}

