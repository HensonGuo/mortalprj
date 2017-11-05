package baseEngine.core.interfaces
{
	import baseEngine.core.Pivot3D;

	public interface IFrame
	{
		function cloneFrame():IFrame;
		function seting(targetMesh:Pivot3D):void
	}
}