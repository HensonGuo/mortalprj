/**
 * 2013-12-25
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.sceneInfo
{
	/**
	 * 
	 	<Type label="全部" value="1"/>
		<Type label="时装" value="2"/>
		<Type label="武器时装" value="4"/>
		<Type label="翅膀" value="8"/>
		<Type label="脚印" value="16"/>
		<Type label="名称" value="32"/>
		<Type label="阵营" value="64"/>
		<Type label="称号" value="128"/>
	 * 
	 */
	public class ScenePlayerShowPartsInfo
	{
		
		private var _showPartsValue:int;
		public function ScenePlayerShowPartsInfo()
		{
		}

		public function get showPartsValue():int
		{
			return _showPartsValue;
		}

		public function set showPartsValue(value:int):void
		{
			_showPartsValue = value;
		}

		/**
		 * 显示全部  
		 * @return 
		 * 
		 */		
		public function showAll():Boolean
		{
			return ((_showPartsValue & 1) == 1);
		}
		
		/**
		 * 显示时装 
		 * @return 
		 * 
		 */		
		public function showShizhuang():Boolean
		{
			return ((_showPartsValue & 2) == 2);
		}
		
		/**
		 * 显示武器时装 
		 * @return 
		 * 
		 */		
		public function showWuqiShiZhuang():Boolean
		{
			return ((_showPartsValue & 4) == 4);
		}
		
		/**
		 * 显示翅膀 
		 * @return 
		 * 
		 */		
		public function showChibang():Boolean
		{
			return ((_showPartsValue & 8) == 8);
		}
		
		/**
		 * 显示脚印 
		 * @return 
		 * 
		 */		
		public function showJiaoyin():Boolean
		{
			return ((_showPartsValue & 16) == 16);
		}
		
		/**
		 * 显示名称 
		 * @return 
		 * 
		 */		
		public function showName():Boolean
		{
			return ((_showPartsValue & 32) == 32);
		}
		
		/**
		 * 显示阵营 
		 * @return 
		 * 
		 */		
		public function showCampName():Boolean
		{
			return ((_showPartsValue & 64) == 64); 
		}
		
		/**
		 * 显示称号 
		 * @return 
		 * 
		 */		
		public function showTitle():Boolean
		{
			return ((_showPartsValue & 128) == 128);
		}
		
		public function showxxx():Boolean
		{
			return ((_showPartsValue & 256) == 256);
		}
	}
}