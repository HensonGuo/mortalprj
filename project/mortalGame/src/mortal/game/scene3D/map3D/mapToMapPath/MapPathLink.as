/**
 * 2014-2-18
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.mapToMapPath
{
	import Message.Public.SPassPoint;

	public class MapPathLink
	{
		public function MapPathLink()
		{
		}
		
		public var parent:MapPathLink;
		public var value:SPassPoint;
		public var distance:int = 0;
	}
}