package com.gengine.utils
{
	import com.gengine.debug.Log;
	import com.gengine.utils.FilterTextValue;

	/**
	 * 作用：加载过滤文本文件作为字符串 作为过滤字符串规则
	 * @author huangliang
	 */
	public class FilterTextEx
	{
		private static var _instance:FilterTextEx;

		public static function get instance():FilterTextEx
		{
			if(_instance == null){
				_instance = new FilterTextEx();
			}
			return _instance;
		}
		private var _wordMap:FilterTextValue;

		/**
		 *
		 */
		public function FilterTextEx()
		{
			_wordMap=new FilterTextValue();
		}

		/**
		 *
		 * @param str
		 */
		public function setFilterStr(str:String):void
		{
			var tempAry:Array=str.split("\r\n");
			var len:int=tempAry.length;
			Log.system("关键词：", len, "条");
			for (var i:int=0; i < len; i++)
			{
				addWord(tempAry[i]);
			}
		}
		/**
		 * 增加一个词到词库
		 * @param value
		 *
		 */
		private function addWord(value:String):void
		{
			initTree(value, _wordMap);
		}

		/**
		 * 初始化索引树
		 * @param value 文本内容
		 * @param parent 父节点
		 * @return 当前节点
		 *
		 */
		private function initTree(value:String, parent:FilterTextValue):FilterTextValue
		{
			var key:String=value.charAt(0);
			value=value.substr(1, value.length - 1);

			var dic:FilterTextValue=parent[key] as FilterTextValue;
			if (!dic)
			{
				//初始化节点
				parent[key]=new FilterTextValue();
				dic=parent[key] as FilterTextValue;
			}
			if (value != "")
			{
				//递归初始化为索引树
				initTree(value, dic);
			}
			else
			{
				//当前已经是关键词的最后一个字，设定当前层为关键词
				dic.isFilterContent=true;
			}
			return dic;
		}

		/**
		 * 获取过滤后的字符串
		 * @param str
		 * @return
		 *
		 */
		public function getFilterStr(str:String):String
		{
			if(str == null || str == "" ) return "";
			var len:int=str.length;
			var s:String;
			for (var i:int=0; i < len; i++)
			{
				s=str.charAt(i);
				if (s != "*")
				{
					var ps:FilterTextValue=_wordMap[s] as FilterTextValue;
					if (ps)
					{
						//需要替换的字符个数
						var cs:FilterTextValue=ps;
						var targetMatchStr:String="*";
						//检测单个字是否过滤字
						if (cs.isFilterContent)
						{
							str=str.replace(s, targetMatchStr);
						}
						else
						{
							for (var j:int=i + 1; j < str.length; j++)
							{
								var checkChar:String=str.charAt(j);
								cs=cs[checkChar] as FilterTextValue;
								targetMatchStr+="*"
								if (!cs)
								{ //未找到，跳出
									break;
								}
								else if (cs.isFilterContent)
								{
									//匹配成功
									//替换并跳出
									var matchLen:int=j - i + 1;
									var preMatchStr:String=str.substr(i, matchLen);
									str=str.replace(preMatchStr, targetMatchStr);
									break;
								}
							}
						}
					}
				}
			}
			return str;
		}
	}
}