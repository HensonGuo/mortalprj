package com.gengine.utils
{
	public class ChatFraudFilter
	{
		private static var _source:Array = [
//			{rep:/(元.*?宝)/ig,point:0.5},
//			{rep:/(出.*?售)/ig,point:0.5},
//			{rep:/(销.*?售)/ig,point:1.0},
//			{rep:/(经.*?销)/ig,point:0.5},
//			{rep:/(商.*?人)/ig,point:0.5},
//			{rep:/(代.*?理)/ig,point:0.8},
//			{rep:/(信.*?誉)/ig,point:0.5},
//			{rep:/(购.*?买)/ig,point:0.5},
//			{rep:/(咨.*?询)/ig,point:0.5},
//			{rep:/(联.*?系)/ig,point:0.5},
//			{rep:/(货.*?到)/ig,point:0.8},
//			{rep:/(付.*?款)/ig,point:0.8},
//			{rep:/(热.*?线)/ig,point:0.5},
//			{rep:/(认.*?准)/ig,point:0.8},
//			{rep:/(安全交易)/ig,point:0.8},
//			{rep:/(交易安全)/ig,point:0.8}
		];
		
		private static const LIMITVALUE:Number = 1;

		
		public function ChatFraudFilter()
		{
			
		}
		/**
		 * value 格式：[	{rep:/(元.*?宝)/ig,point:0.5},{rep:/(出.*?售)/ig,point:0.5}] 
		 * reg 是正则，point 是权限
		 * @param value
		 * 
		 */
		public static function set source( value:Array ):void
		{
			if( value != null )
			{
				_source = value;
				for  each ( var obj:Object in _source)
				{
					obj.rep = new RegExp(obj.rep,"ig");
					obj.point = parseFloat(obj.point);
				}					
			}
		}
		/**
		 * 是否是骗子买元宝发言 
		 * @return 
		 * 
		 */		
		public static function isChatFraud( value:String ):Boolean
		{
			var num:Number=0;
			for  each ( var obj:Object in _source)
			{
				if(value.search(obj.rep) > -1)
				{
					num += obj.point;
					if( num >= LIMITVALUE )
					{
						return true;
					}
				}
			}
			return false;
		}
		
		private static var reg:RegExp = new RegExp("[\\s█﹦﹢【】〖〗﹝﹞〔〕﹜﹛﹢＋≒＝（）]","img");
		
		private static var DelReg:RegExp = new RegExp("[^IOlZz1234567890１２３４５６７８９０①②③④⑤⑥⑦⑧⑨⒈⒉⒊⒋⒌⒍⒎⒏⒐ⅠⅡⅢⅣⅤⅥⅦⅧⅨ㈠㈡㈢㈣㈤㈥㈦㈧㈨⑴⑵⑶⑷⑸⑹⑺⑻⑼零壹贰叁肆伍陆柒捌玖一二三四五六七八九—十万百]","img");
		/**
		 *  是否包含QQ信息
		 * @param value
		 * @return 
		 * 
		 */		
		private static var regIndex:int = 0;
		public static function hasQQInfo( value:String ):Boolean
		{
			var testReg:RegExp = new RegExp("[IO1234567890１２３４５６７８９０①②③④⑤⑥⑦⑧⑨⒈⒉⒊⒋⒌⒍⒎⒏⒐ⅠⅡⅢⅣⅤⅥⅦⅧⅨ㈠㈡㈢㈣㈤㈥㈦㈧㈨⑴⑵⑶⑷⑸⑹⑺⑻⑼零壹贰叁肆伍陆柒捌玖一二三四五六七八九]{7,13}","img");
			return testReg.test(value);
		}
		/**
		 * 删除特殊符号 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function delSpecialSymbols( value:String ):String
		{
			return value.replace(DelReg,"");
		}
	}
}