/**
 * 2014-1-8
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view
{
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	
	import flash.geom.Point;
	
	import mortal.common.DisplayUtil;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.view.common.UIFactory;
	
	public class SmallMapPathShower extends GSprite
	{
		private var _iconSelf:GBitmap;
		private var _paths:Array = [];
		
		public function SmallMapPathShower()
		{
			super();
		}
		
		public function updateSelfPlace(xx:int, yy:int):void
		{
			_iconSelf.x = xx - 2;
			_iconSelf.y = yy - 15;
		}
		
		public function showHideSelfIcon(isShow:Boolean):void
		{
			_iconSelf.visible = isShow;
		}
		
		public function showPath(path:Array, scale:Number):void
		{
			for(var i:int = 0; i < path.length; i++)
			{
				var p:Point = path[i];
				var gp:GBitmap = _paths[i];
				if(gp == null)
				{
					gp = UIFactory.gBitmap(ImagesConst.MapPoint_Path, 0, 0, this);
					_paths.push(gp);
				}
				if(gp.parent == null)
				{
					this.addChild(gp);
				}
				gp.x = p.x * scale * GameMapUtil.tileWidth - gp.width/2;
				gp.y = p.y * scale * GameMapUtil.tileHeight - gp.height/2;
			}
			for(;i < _paths.length; i++)
			{
				gp = _paths[i];
				DisplayUtil.removeMe(gp);
			}
		}
		
		public function clearPaths():void
		{
			if(_paths == null)
			{
				return;
			}
			for(var i:int = 0; i < _paths.length; i++)
			{
				var p:GBitmap = _paths[i];
				if(p != null)
				{
					p.dispose(true);
				}
			}
			_paths = [];
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_iconSelf = UIFactory.gBitmap(ImagesConst.MapPoint_Self2, 0, 0, this);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_iconSelf.dispose(isReuse);
			_iconSelf = null;
		}
	}
}