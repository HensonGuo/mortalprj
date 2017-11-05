package mortal.game.view.mount.data
{
	import Message.DB.Tables.TItemMount;
	import Message.DB.Tables.TMountUp;
	import Message.Public.SPublicMount;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.info.item.ItemExInfo;
	import mortal.game.resource.info.item.ItemMountInfo;
	import mortal.game.resource.tableConfig.MountConfig;

	public class MountData
	{
		
		private var _itemMountInfo:ItemMountInfo;
		
		private var _sPublicMount:SPublicMount;
		
		/**
		 * 该坐骑宝具列表 
		 */		
		public var toolList:Vector.<MountToolData>;
		
		public function MountData(data:*)
		{
			if(data is SPublicMount)
			{   
				sPublicMount = data;
			}
			else if(data is int)
			{
				_itemMountInfo = MountConfig.instance.getMountInfoById(data);
			}
			else if(data is ItemMountInfo)
			{
				_itemMountInfo = data;
			}
		}

		/**
		 * 是否拥有该坐骑 
		 * @return 
		 * 
		 */		
		public function get isOwnMount():Boolean
		{
			return _sPublicMount == null? false:true;
		}
		
		public function set itemMountInfo(value:ItemMountInfo):void
		{
			_itemMountInfo = value;
			
		}
		
		public function set sPublicMount(value:SPublicMount):void
		{
			if(value == null)//空代表删除坐骑
			{
				_sPublicMount = null;
				toolList.length = 0;
			}
			else
			{
				_sPublicMount = value;
				toolList = new Vector.<MountToolData>;
				_itemMountInfo = MountConfig.instance.getMountInfoById(_sPublicMount.code);
				
				var arr:Array = JSON.parse(value.tool) as Array;
				var nameList:Vector.<String> = MountConfig.instance.vcAttribute;
				var index:int = 0;
				for each(var i:String in nameList)
				{
					
					if(_itemMountInfo[i])
					{
						toolList.push(new MountToolData(i,arr[index]));
						index++;
					}
					else
					{
						continue;
					}
				}
			}
			
			_atrribuiteObj = null;//重新设置mount的属性后,清空属性列表,让它重新计算属性值
		}
		
		private var _atrribuiteObj:Object;   //属性加成词典
		
		/**
		 * 获取该坐骑属性加成列表 
		 * @return 
		 * 
		 */		
		public function get atrribuiteObj():Object
		{
			if(_atrribuiteObj)
			{
				return _atrribuiteObj;
			}
			else
			{
				_atrribuiteObj = new Object();
				var vcAttributeName:Vector.<String> = MountConfig.instance.attribute;
				for (var i:int = 0; i < vcAttributeName.length; i++)
				{
					var extr:int = 0;
					
					if(this.isOwnMount)
					{
						var tmountUp:TMountUp = MountConfig.instance.getMountUpByLevel(_sPublicMount.level) as TMountUp;
						
						if(tmountUp.hasOwnProperty(vcAttributeName[i]))  //计算等级属性加成
						{
							if(_sPublicMount.level > 0)
							{
								extr += tmountUp[vcAttributeName[i]];
							}
						}
						
						for each(var n:MountToolData in toolList)  //计算777属性加成
						{
							if(n.name.toLocaleLowerCase() == "add" + vcAttributeName[i])
							{
								extr += (MountConfig.instance.getMountToolLevel(n.level).add / 10000)*_itemMountInfo[n.name]
							}
						}
					}
					
					_atrribuiteObj[vcAttributeName[i]] = _itemMountInfo[vcAttributeName[i]] + extr;
				}
			}
			
			return _atrribuiteObj;
		}
		
		public function get sPublicMount():SPublicMount
		{
			return _sPublicMount;
		}
		
		public function get itemMountInfo():ItemMountInfo
		{
			return _itemMountInfo;
		}
	}
}