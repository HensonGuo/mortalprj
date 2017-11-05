package mortal.game.scene3D.layer3D
{
	import Message.Public.SEntityId;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.MathUitl;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.layer3D.utils.EntityUtil;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.player.item.ItemPlayer;
	import mortal.game.utils.PlayerUtil;

	public class DropItemDictionary
	{
		private var _map:Dictionary;
		
		public function DropItemDictionary( weakKeys:Boolean = false )
		{
			_map = new Dictionary( weakKeys );
		}
		
		public function addDropItem( dropItemId:SEntityId , dropItem:ItemPlayer ):ItemPlayer
		{
			_map[ EntityUtil.toString(dropItemId) ] = dropItem;
			return dropItem;
		}
		
		public function removeDropItem(  dropItemId:SEntityId ):ItemPlayer
		{
			var dropItem:ItemPlayer = getDropItem( dropItemId );
			if( dropItem )
			{
				delete _map[ EntityUtil.toString(dropItemId) ];
			}
			return dropItem;
		}
		
		public function getDropItem( dropItemId:SEntityId ):ItemPlayer
		{
			return _map[ EntityUtil.toString(dropItemId) ];
		}
		
		public function get map():Dictionary
		{
			return _map;
		}
		
		/**
		 * 获取 范围内的 实体对象 
		 * @param rect
		 * @param type  type == 0 全部实体 
		 * @return 
		 * 
		 */		
		public function getEntityByRangle( rect:Rectangle = null ,isSelfOnly:Boolean = false):Array
		{
			if(!rect)
			{
				rect = SceneRange.display;
			}
			var ary:Array = new Array();
			for each( var item:ItemPlayer in _map  )
			{
				if( rect.contains(item.x2d,item.y2d) && (!isSelfOnly || EntityUtil.isSelf(item.dropEntityInfo.ownerEntityId)))
				{
					ary.push(item);
				}
			}
			return ary;
		}
		
		public function getRandomDropItem(isSelfOnly:Boolean = false):ItemPlayer
		{
			var ary:Array = getEntityByRangle(SceneRange.display,isSelfOnly);
			if( ary.length == 0 )
			{
				return null;
			}
			return ary[ MathUitl.random(0,ary.length-1) ];
		}
		
		public function removeAll():void
		{
			_map = new Dictionary();
		}
	}
}
