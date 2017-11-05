package utils
{
	public class RandomName_tw
	{
		public static const Man:int = 0;
		public static const Woman:int = 1;
		
		private static var firstNames:Array = ["司馬", "歐陽", "端木", "上官", "獨孤", "夏侯", "尉遲", "赫連", "皇甫", "公孫", "慕容", "長孫", "宇文", "司徒", "軒轅", "百裡", "呼延", "令狐", "諸葛", "南宮", "東方", "西門", "李", "王", "張", "劉", "陳", "楊", "趙", "黃", "周", "胡", "林", "梁", "宋", "鄭", "唐", "馮", "董", "程", "曹", "袁", "許", "沈", "曾", "彭", "呂", "蔣", "蔡", "魏", "葉", "杜", "夏", "汪", "田", "方", "石", "熊", "白", "秦", "江", "孟", "龍", "萬", "段", "雷", "武", "喬", "洪", "魯", "葛", "柳", "岳", "梅", "辛", "耿", "關", "苗", "童", "項", "裴", "鮑", "霍", "甘", "景", "包", "柯", "阮", "華", "滕", "穆", "燕","敖","冷","卓", "花", "藍", "楚", "荊"];
		
		private static var secondMan0:Array = ["峰", "不", "近",  "千", "萬", "百", "億","一", "求", "笑", "雙", "淩", "伯", "仲", "叔", "震", "飛", "曉", "昌", "霸", "沖", "志", "留", "九", "子", "立", "小", "雲", "文", "安", "博", "才", "光", "弘", "華", "清", "燦", "俊", "凱", "樂", "良", "明", "健", "輝", "天", "星", "永", "英", "真", "修", "義", "嘉", "成", "傲", "欣", "逸", "飄", "淩", "青", "火", "森", "傑", "思", "智", "辰", "元", "夕", "蒼", "勁", "巨", "瀟", "邪", "塵"];
		
		private static var secondMan1:Array = ["敗", "悔", "南", "寶", "仞", "刀", "斐", "德", "雲", "天", "仁", "岳", "宵", "忌", "爵", "權", "敏", "陽", "狂", "冠", "康", "平", "強", "凡", "邦", "福", "歌", "國", "和", "康", "瀾", "民", "寧", "然", "順", "翔", "晏", "宜", "易", "志", "雄", "佑", "斌", "河", "元", "墨", "松", "林", "之", "翔", "竹", "宇", "軒", "榮", "哲", "風", "霜", "山", "炎", "罡", "盛", "睿", "達", "洪", "武", "耀", "磊", "寒", "冰", "瀟", "痕", "空"];
		
		private static var secondWoman0:Array = ["思", "冰", "夜", "癡", "依", "小", "香", "綠", "映", "含", "曼", "春", "醉", "之", "新", "雨", "天", "如", "若", "涵", "亦", "採", "冬", "安", "芷", "綺", "雅", "飛", "又", "寒", "憶", "曉", "樂", "笑", "妙", "元", "碧", "翠", "初", "懷", "幻", "慕", "秋", "語", "覓", "幼", "靈", "傲", "冷", "沛", "念", "水", "紫", "惜", "詩", "青", "雁", "盼", "爾", "以", "雪", "夏", "凝", "丹", "迎", "宛", "夢", "憐", "聽", "巧", "靜", "採", "淩", "芊", "琪"];
		
		private static var secondWoman1:Array =  ["煙", "琴", "藍", "夢", "丹", "柳", "萍",  "寒", "霜", "白", "絲", "真", "露", "雲", "芙", "容", "香", "荷", "風", "兒", "雪", "巧", "蕾", "芹", "靈", "卉", "夏", "嵐", "蓉", "萱", "珍", "彤", "蕊", "曼", "蘭", "晴", "珊", "青", "春", "玉", "瑤", "文", "雙", "竹", "凝", "桃", "菡", "綠", "梅", "旋", "之", "蝶", "蓮", "薇", "翠", "槐", "秋", "雁", "夜", "芊", "冬", "菲", "琪"];
		
		public function RandomName_tw()
		{
		}
		
		public static function getName(type:int):String
		{
			var _fname:String = firstNames[random(0,firstNames.length-1)];
			var _sname:String = "";
			var randomNum:int = random( 1,10000000 );
			var temp:int = randomNum % 8;
			if( type == Man )
			{
				if( temp == 1)
				{
					_sname += secondMan0[random(0,secondMan0.length-1)];
				}
				else if( temp == 2 )
				{
					_sname += secondMan1[random(0,secondMan1.length-1)];
				}
				else
				{
					_sname += secondMan0[random(0,secondMan0.length-1)];
					_sname += secondMan1[random(0,secondMan1.length-1)];
				}
			}
			else
			{
				if( temp == 1)
				{
					_sname += secondWoman0[random(0,secondWoman0.length-1)];
				}
				else if( temp == 2 )
				{
					_sname += secondWoman1[random(0,secondWoman1.length-1)];
				}
				else
				{
					_sname += secondWoman0[random(0,secondWoman0.length-1)];
					_sname += secondWoman1[random(0,secondWoman1.length-1)];
				}
			}
			
			return _fname+_sname;
		}
		
		
		public static function random(min:int,max:int):int
		{
			var num:int = max - min;
			return Math.round(Math.random()*num) + min;
		}
	}
}