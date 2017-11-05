package mortal.component.ui
{
	public class ConsumeData
	{
		public static const ItemType:String = "ItemType";
		
		public static const MoneyType:String = "MoneyType";
		
		public var type:String;
		
		public var num:int;
		
		public var code:int;
		
		public function ConsumeData(code:int,num:int)
		{
			this.code = code;
			this.num = num;
		}
		
		
	}
}