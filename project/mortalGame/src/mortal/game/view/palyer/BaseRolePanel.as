package mortal.game.view.palyer
{
	import Message.Public.SFightAttribute;
	
	import com.mui.controls.GSprite;
	import com.mui.utils.UICompomentPool;
	
	import mortal.component.window.Window;
	import mortal.game.mvc.GModuleEvent;
	
	public class BaseRolePanel extends GSprite
	{
		//数据
		private var _mode:String = GModuleEvent.Mode_Self;
		
		//显示对象
		/**人物属性信息*/
		private var _attributeInfoPart:AttributeInfoPart;
		/**人物装备信息**/
		private var _equipmentPart:EquipmentPart;
		
		private var _window:Window;
		
//		private var _equipPart
		
		public function BaseRolePanel(window:Window)
		{
			_window = window;
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_attributeInfoPart = UICompomentPool.getUICompoment(AttributeInfoPart);
			_attributeInfoPart.createDisposedChildren();
			_attributeInfoPart.x = 264;
			_attributeInfoPart.y = 62;
			this.addChild(_attributeInfoPart);
			
			_equipmentPart = UICompomentPool.getUICompoment(EquipmentPart,_window);
			_equipmentPart.createDisposedChildren();
			_equipmentPart.x = 17;
			_equipmentPart.y = 66;
			this.addChild(_equipmentPart);
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_attributeInfoPart.dispose(isReuse);
			_equipmentPart.dispose(isReuse);
			
			_attributeInfoPart = null;
			_equipmentPart = null;
			
			super.disposeImpl(isReuse);
		}
		
		public function get mode():String
		{
			return _mode;
		}
		
		public function set mode(value:String):void
		{
			_mode = value;
		}
		
		public function updateAttr():void
		{
//			_attributeInfoPart.updateAllInfo();
		}
		
		public function upDateAllInfo(data:SFightAttribute):void
		{
			_attributeInfoPart.updateAllInfo(data);
			_equipmentPart.upDataAllInfo();
		}
		
		public function updateLife(data:int):void
		{
			_attributeInfoPart.updateLife(data);
		}
		
		public function updateMana(data:int):void
		{
			_attributeInfoPart.updateMana(data);
		}
		
		public function upDateExp(data:int):void
		{
			_attributeInfoPart.updateExp(data);
		}
		
		public function updateLevel(value:int):void
		{
//			_equipmentPart.upDateLevel(value);
			_attributeInfoPart.updateLevel();
		}
		
		public function upDateEquipByType(type:int):void
		{
			_equipmentPart.upDateEquipByType(type);
		}
		
		public function upDateAllEquip():void
		{
			_equipmentPart.upDateAllEquip();
		}
		
		public function updateComBat():void
		{
			_attributeInfoPart.updateComBat();
		}
	}
}