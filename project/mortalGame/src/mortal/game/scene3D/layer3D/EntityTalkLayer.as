/**
 * @heartspeak
 * 2014-4-11 
 */   	

package mortal.game.scene3D.layer3D
{
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.UILayer;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.head.TalkSprite;
	
	public class EntityTalkLayer extends UILayer
	{
		protected var entityList:Vector.<IEntity> = new Vector.<IEntity>();
		public function EntityTalkLayer()
		{
			super();
		}
		
		/**
		 * 添加对话 
		 * @param entity
		 * @param talkText
		 * 
		 */		
		public function addTalk(entity:IEntity,text:String,time:int = 5000):void
		{
			var index:int = entityList.indexOf(entity);
			if(index < 0)
			{
				entityList.push(entity);
			}
			entity.talk(text,time);
		}
		
		/**
		 * 删除对话 
		 * @param entity
		 * 
		 */
		public function removeTalk(entity:IEntity):void
		{
			var index:int = entityList.indexOf(entity);
			if(index >= 0)
			{
				entityList.splice(index,1);
			}
			entity.clearTalk();
		}
		
		/**
		 * 更新对话坐标 
		 * 
		 */
		public function updateTalkPosition():void
		{
			var length:int = entityList.length;
			for(var i:int = 0;i < length;i++)
			{
				entityList[i].updateTalkXY();
			}
		}
		
		/**
		 * 清理 
		 * 
		 */
		public function clear():void
		{
			entityList = new Vector.<IEntity>();
		}
	}
}