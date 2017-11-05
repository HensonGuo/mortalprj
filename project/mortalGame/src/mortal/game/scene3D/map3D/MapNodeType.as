package mortal.game.scene3D.map3D
{
	import Message.Public.EMapPointType;

	/**
	 * 	0~3不可走区域
		0~2不可攻击区域
		0~1不可跳跃区域
		0~不可飞区域
		5-可走不安全区域
		6-透明区域
		7~11本服安全区域
		12-绝对安全区
		17-透明本服安全区
		18-透明绝对安全区
		
		 判断条件
		 * 可以移动 >=4
		 * 
		 * 可以飞行>=1
		 * 
		 * 可以跳>=2
		 * 
		 * 透明 == 6 || == 17 || == 18
		 * 
		 * 本服安全 7 - 18
		 * 
		 * 绝对安全 12 - 16 || 18
		 * 
		(>=30-怪物区域)
		只存在服务器端地图数据，客户端地图没有怪物数据）
 	
		<Type name="完全不可走 - 0" value="0" color="0x292421"/>
			<Type name="不可走，不可攻跳，可飞 - 1" value="1" color="0x87CEEB"/>
			<Type name="不可走、不可攻，可跳飞 - 2" value="2" color="0x385E0F"/>
			<Type name="不可走，可攻飞跳跃 - 3" value="3" color="0x708069"/>
			<Type name="可走不可靠近 - 4" value="4" color="0x9C661F"/>
	    <Type name="透明区域 - 6" value="6" color="0xC0C0C0"/>
			<Type name="游泳区域 - 7" value="7" color="0x40E0D0"/>
			<Type name="商业区 - 8" value="8" color="0x00FFFF"/>
			<Type name="修炼区 - 9" value="9" color="0xFFD700"/>
			<Type name="钓鱼区 - 10" value="10" color="0x0000FF"/>
			<Type name="绝对安全区 - 11" value="11" color="0x00C957"/>
			<Type name="本服安全区 - 12" value="12" color="0x00FF00"/>
			<Type name="阵营1复活 - 13" value="13" color="0x1E90FF"/>
	    <Type name="阵营2复活 - 14" value="14" color="0xA020F0"/>
	    <Type name="阵营3复活 - 15" value="15" color="0x00FF7F"/>
	    <Type name="阵营公共复活- 16" value="16" color="0xFF6100"/>
	    <!-- 17在客户端为本服透明安全区 -->
	    <!-- 18在客户端为绝对透明安全区 -->
	    <Type name="阵营1复活(可攻击) - 19" value="19" color="0x1E90FF"/> 
	    <Type name="阵营2复活(可攻击) - 20" value="20" color="0xA020F0"/> 
	    <Type name="阵营3复活(可攻击) - 21" value="21" color="0x00FF7F"/>
	    <Type name="阵营公共复活(可攻击) - 22" value="22" color="0xFF6100"/>
	    <!-- 30以下为客户端使用的数据，不包括30 -->
	 * @author jianglang
	 * 
	 */	
	public class MapNodeType
	{
		public function MapNodeType()
		{
		}
		/**
		 *走动所需的最小值
		 */		
		public static const WALK_MIN_VALUE:int = 5;
		/**
		 *飞行所需的最小值
		 */		
		public static const FLY_MIN_VALUE:int = 1;
		
		/**
		 * 是否可飞行
		 * @param type
		 * @return 
		 * 
		 */
		public static function isFly( type:int ):Boolean
		{
			return type >= FLY_MIN_VALUE || type < 0;
		}
		
		/**
		 * 是否可攻击
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isAttack( type:int ):Boolean
		{
			return type >= 3;
		}
		
		/**
		 * 是否可走 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isWalk( type:int ):Boolean
		{
			return type >= WALK_MIN_VALUE || type < 0;
		}
		
		/**
		 * 是否人物透明
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isAlpha( type:int ):Boolean
		{
			return type == 6 || type == 17 || type == 18;
		}
		
		/**
		 * 是否本服安全 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isSameServerSafe( type:int ):Boolean
		{
			return type >= 7 && type <= 18;
		}
		
		/**
		 * 是否跨服安全 
		 * @param type
		 * @return 
		 * 
		 */		
		public static function isAllServerSafe( type:int ):Boolean
		{
			return (type == 12 && type <= 16) || type == 18;
		}
	}
}