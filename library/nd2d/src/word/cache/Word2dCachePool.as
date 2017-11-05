package word.cache
{
	import flash.display.BitmapData;
	
	import de.nulldesign.nd2d.materials.Sprite2DMaterial;

	public class Word2dCachePool
	{
		public static const instance:Word2dCachePool=new Word2dCachePool();
		public var miniMapBitmapData:BitmapData;
		public var sprite2dMat:Sprite2DMaterial=new Sprite2DMaterial();
		public function Word2dCachePool()
		{
		}
	}
}