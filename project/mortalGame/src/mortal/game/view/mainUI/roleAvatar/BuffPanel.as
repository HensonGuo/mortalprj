package mortal.game.view.mainUI.roleAvatar
{
	import Message.DB.Tables.TBuff;
	
	import com.gengine.utils.ObjectUtils;
	import com.mui.controls.GSprite;
	import com.mui.core.GlobalClass;
	import com.mui.utils.UICompomentPool;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.tableConfig.BuffConfig;
	import mortal.game.view.common.UIFactory;
	
	public class BuffPanel extends GSprite
	{
		private var _buffItemArray:Array = [];//buff显示对象数组
		
		private var _buffDcit:Dictionary = new Dictionary();
		private var _buffGroupDcit:Dictionary = new Dictionary();
		private var _isHideAfterFine:Boolean;
		
		public function BuffPanel()
		{
			super();
		}
		
		
		/**
		 *根据传入的BuffInfo数组更新Buffer。
		 * @param buffInfoArray 包含的是BuffInfo
		 * 
		 */		
		public function updateBufferByBuffInfoArray(buffInfoArray:Array):void
		{
			if(buffInfoArray)
			{
				clearBuff();
				if(buffInfoArray.length > 0)
				{
					var buffInfo:BuffData;
					var buffItem:BuffItem;
					for(var i:int ; i < buffInfoArray.length ; i++)
					{
						buffItem = UICompomentPool.getUICompoment(BuffItem);
						buffItem.createDisposedChildren();
						buffItem.x = (i%5) * 20;
						buffItem.y = Math.floor(i/5)*20
						buffItem.buffInfo = buffInfoArray[i] as BuffData;
						this.addChild(buffItem);
						_buffItemArray.push(buffItem);
					}
				}
			}
		}
		
		/**
		 *清空所有BUFF 
		 * 
		 */		
		private function clearBuff():void
		{
			for(var j:int=0;j<_buffItemArray.length;j++)
			{
				var buffer:BuffItem = _buffItemArray[j] as BuffItem;
				if(buffer)// && buffer.buffInfo
				{
					buffer.dispose(true);
				}
			}
			_buffItemArray = new Array();
		}
		
		/**
		 *隐藏5之后的BUFF 
		 * 
		 */		
		public function hideBuffAfterFine():void
		{
			if (_buffItemArray.length>5) 
			{
				for (var i:int = 5; i < _buffItemArray.length; i++) 
				{
					(_buffItemArray[i] as BuffItem).visible = false;
				}
				_isHideAfterFine = true;
			}
			else
			{
				_isHideAfterFine = false;
			}
		}
		
		/**
		 *显示5之后的buff 
		 * 
		 */		
		public function showBuffAfterFine():void
		{
			if (_buffItemArray.length>5) 
			{
				for (var i:int = 5; i < _buffItemArray.length; i++) 
				{
					(_buffItemArray[i] as BuffItem).visible = true;
				}
			}
			_isHideAfterFine = false;
		}
		
		/**
		 *根据传入的tStateId(BUFF的id)更新Buffer。用于更新所查看的实体的BUFF。
		 * @param stateIdArray 包含的是BUFF的id,即stateId
		 * 
		 */		
		public function updateBufferByTSateIdArray(buffIdArray:Array):void
		{
			var tmpBuffInfoArray:Array = [];
			clearDict();
			if(buffIdArray)
			{
				if(buffIdArray.length > 0)
				{
					var buffData:BuffData;
					var tbuff:TBuff;
					for(var i:int=0;i<buffIdArray.length;i++)
					{
						tbuff = BuffConfig.instance.getInfoById(buffIdArray[i]) as TBuff;
						if(tbuff && tbuff.icon != 0)//图标为空，不处理
						{
							if(tbuff)// && tstate.lastTime != -1去掉限制
							{
								buffData = new BuffData();
								//查看其他实体的BUFF时，按值处理
//								tstate.category = 3;
								buffData.tbuff = tbuff;
							}
							else
							{
								buffData = null;
							}
							
							if(_buffDcit[tbuff.buffId] == null && _buffGroupDcit[tbuff.group] == null)
							{
								//							buffItem.buffInfo = buffInfo;
								tmpBuffInfoArray.push(buffData);
								if(tbuff.group > 0)
								{
									_buffGroupDcit[tbuff.group] = buffData;
								}
								else
								{
									_buffDcit[tbuff.buffId] = buffData;
								}
							}
						}
					}
					updateBufferByBuffInfoArray2(tmpBuffInfoArray);
				}
				else
				{
					clearBuff();
				}
			}
		}
		
		/**
		 * 用于显示排列实体buff 
		 * @param buffInfoArray
		 * 
		 */		
		public function updateBufferByBuffInfoArray2(buffInfoArray:Array):void
		{
			if(buffInfoArray)
			{
				clearBuff();
				if(buffInfoArray.length > 0)
				{
					var buffInfo:BuffData;
					var buffItem:BuffItem;
					for(var i:int ; i < buffInfoArray.length ; i++)
					{
						buffItem = UICompomentPool.getUICompoment(BuffItem);
						buffItem.createDisposedChildren();
						buffItem.x = (i%5) * 20;
//						buffItem.y = Math.floor(i/5)*20;
						buffItem.y = 0;
						buffItem.buffInfo = buffInfoArray[i] as BuffData;
						this.addChild(buffItem);
						_buffItemArray.push(buffItem);
					}
				}
			}
		}
		
		/**
		 *清空Dict 
		 * 
		 */		
		private function clearDict():void
		{
			for (var i:String in _buffDcit)
			{
				delete _buffDcit[i];
			}
			for (var j:String in _buffGroupDcit)
			{
				delete _buffGroupDcit[j];
			}
		}
		
		public function clean():void
		{
			clearBuff();
		}
	}
}