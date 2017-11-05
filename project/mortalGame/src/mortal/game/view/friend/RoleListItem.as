package mortal.game.view.friend
{
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	
	import mortal.game.view.common.UIFactory;
	
	/**
	 * 单个角色列表项
	 * @date   2014-2-21 下午2:30:53
	 * @author dengwj
	 */	 
	public class RoleListItem extends GSprite
	{
		/** 角色门派 */
		private var _roleMartial:GTextFiled;
		/** 角色名字 */
		private var _roleName:GTextFiled;
		/** 战斗力 */
		private var _fightValue:GTextFiled;
		
		public function RoleListItem()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_roleMartial = UIFactory.gTextField("逍遥",63,11,35,20,this);
			_roleName = UIFactory.gTextField("玩家名字七个字",100,11,96,20,this);
			_fightValue = UIFactory.gTextField("99999",209,11,48,20,this);
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_roleMartial.dispose(isReuse);
			_roleName.dispose(isReuse);
			_fightValue.dispose(isReuse);
			
			_roleMartial = null;
			_roleName = null;
			_fightValue = null;
		}
	}
}