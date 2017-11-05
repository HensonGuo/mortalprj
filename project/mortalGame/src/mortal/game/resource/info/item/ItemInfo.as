/**
 * 2013-12-31
 * @author chenriji
 **/

package mortal.game.resource.info.item
{
	import Message.DB.Tables.TItem;
	
	import com.gengine.utils.HTMLUtil;
	
	import mortal.game.resource.ColorConfig;

	/**
	 * 物品配置信息 
	 */
	public class ItemInfo
	{
		public var code : int;
		
		public var icon : String;
		
		public var dropIcon : String;
		
		public var codeUnbind : int;
		
		public var name : String;
		
		public var group : int;
		
		public var category : int;
		
		public var type : int;
		
		public var level : int;
		
		public var itemLevel : int;
		
		public var effect : int;
		
		public var effectEx : int;
		
		public var career : int;
		
		public var bind : int;
		
		public var sell : int;
		
		public var sellPrice : int;
		
		public var sellUnit : int;
		
		public var color : int;
		
		public var overlay : int;
		
		public var cdTime : int;
		
		public var useType : int;
		
		public var descStr : String;
		
		public var feedMount : int;
		
		public var hunqiFeed : int;
		
		public var market : int;
		
		public var beginTime : Date;
		
		public var endTime : Date;
		
		public function get url():String
		{
			return icon + ".jpg";
		}
		
		public function getExtendAtt( att:String ):*
		{
			return this[att];
		}
		
		public function ItemInfo()
		{
			
		}
		
		public function get normalTooltip():String
		{
			return "";
		}
		
		public function get tooltip1():String
		{
			return "";
		}
		public function get tooltip2():String
		{
			return "";
		}
		
		public function get htmlName():String
		{
			return HTMLUtil.addColor(name, colorStr);
		}
		
		public function get colorStr():String
		{
			return ColorConfig.instance.getItemColorString(color);
		}
	}
}
