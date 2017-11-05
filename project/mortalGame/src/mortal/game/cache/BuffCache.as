/**
 * @heartspeak
 * 2014-1-21 
 */   	

package mortal.game.cache
{
	import Message.DB.Tables.TBuff;
	import Message.Public.EBuffUpdateType;
	import Message.Public.SBuff;
	import Message.Public.SBuffUpdate;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.tableConfig.BuffConfig;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.mainUI.roleAvatar.BuffData;

	public class BuffCache
	{
		private var _updateType:int;//更新类型
		private var _sBufferMsg:SBuffUpdate; 
		private var _buffers:Array = [];
		
		/**
		 *拥有的buff数组 
		 */		
		private var _buffDataArray:Array = [];
		
		/**
		 * 需要显示的buff 
		 */		
		private var _showBuffArray:Array = []; 
		
		/**
		 * 拥有的buff
		 */		
		private var _buffDcit:Dictionary = new Dictionary();  
		
		/**
		 * buff组
		 */		
		private var _buffGroupDcit:Dictionary = new Dictionary();    
		
		public function BuffCache()
		{
		}
		
		/**
		 * 更新buff 
		 * @param sBufferMsg
		 * 
		 */
		public function updateBuff(sBufferMsg:SBuffUpdate):void
		{
			_sBufferMsg = sBufferMsg;
			updateType = _sBufferMsg.op;
			if(sBufferMsg)
			{
				buffers = sBufferMsg.buffs;
				var len:int = buffers.length
				var buffInfo:BuffData;
				var sBuffer:SBuff;
		
				for(var i:int ; i < len ; i++)
				{
					var cdData:CDData = null;
					sBuffer = sBufferMsg.buffs[i] as SBuff;
					buffInfo = new BuffData(sBuffer);
					buffInfo.isSelfBuff = true;
					var tbuff:TBuff = BuffConfig.instance.getInfoById(sBuffer.buffId);
					if(tbuff.icon != 0)//图标为空，不处理
					{
						if(updateType == EBuffUpdateType._EBuffUpdateTypeAdd)
						{
							if(_buffDcit[tbuff.buffId] == null)
							{
								//增加BUFF
								_buffDataArray.push(buffInfo);
								if(_buffGroupDcit[tbuff.group] == null)
								{
									_showBuffArray.push(buffInfo);
									if(tbuff.lastTime > 0)
									{
										cdData = Cache.instance.cd.registerCDData(CDDataType.backPackLock, sBuffer.buffId.toString(), cdData) as CDData;
//										cdData.beginTime = sBuffer.remainSec;
										var ll:String = sBuffer.buffId.toString();
										if(sBuffer.remainSec == 0)
										{
											cdData.totalTime = tbuff.lastTime;
										}
										else
										{
											cdData.totalTime = sBuffer.remainSec*1000;
										}
									
										cdData.startCoolDown();
									}
								}
								
								if(tbuff.group > 0)
								{
									_buffGroupDcit[tbuff.group] = buffInfo;
								}
								else
								{
									_buffDcit[tbuff.buffId] = buffInfo;
								}
							}
						}
						else if(updateType == EBuffUpdateType._EBuffUpdateTypeUpdate)
						{
							if(tbuff.group > 0)
							{
								_buffGroupDcit[tbuff.group] = buffInfo;
							}
							else
							{
								_buffDcit[tbuff.buffId] = buffInfo;
							}
							
							//更新BUFF
							var uBuffData:BuffData;
							for(var j:int=0;j < _buffDataArray.length;j++)
							{
								uBuffData = _buffDataArray[j] as BuffData;
								if(uBuffData)
								{
									if(sBuffer.buffId == uBuffData.tbuff.buffId)
									{//需更新
										uBuffData.sbuff = sBuffer;
										if(sBuffer.remainSec > 0)
										{
											cdData = Cache.instance.cd.registerCDData(CDDataType.backPackLock, sBuffer.buffId.toString(), cdData) as CDData;
											cdData.stopCoolDown();
											cdData.beginTime = 0;
											cdData.totalTime = sBuffer.remainSec*1000;
											cdData.startCoolDown();
										}
										break;
									}
								}
							}
							
						}
						else if(updateType == EBuffUpdateType._EBuffUpdateTypeRemove)
						{
							if(tbuff.group > 0)
							{
								delete _buffGroupDcit[tbuff.group];
							}
							else
							{
								delete _buffDcit[tbuff.buffId];
								Cache.instance.cd.unregisterCDData(CDDataType.backPackLock, sBuffer.buffId.toString()) as CDData;
							}
							deleteBuff(sBuffer,_buffDataArray);
							deleteBuff(sBuffer,_showBuffArray);
						}
					}
				}
			}
		}
	
		/**
		 *将sBuffer从buffArray中删除
		 * @param sBuffer
		 * @param buffArray
		 * 
		 */		
		private function deleteBuff(sBuffer:SBuff,buffArray:Array):void
		{
			var dBuffInfo:BuffData;
			for(var k:int=0;k < buffArray.length;k++)
			{
				dBuffInfo = buffArray[k] as BuffData;
				if(dBuffInfo)
				{
					if(sBuffer.buffId == dBuffInfo.tbuff.buffId)
					{
						//需删除
						var index:int = buffArray.indexOf(dBuffInfo);
						buffArray.splice(index,1);
						break;
					}
				}
			}
		}
		
		/**
		 *保存所有BUFF信息 
		 */
		public function get buffInfoArray():Array
		{
			return _buffDataArray;
		}
		
		public function get showBuffArray():Array
		{
			return _showBuffArray
		}
		
		public function get updateType():int
		{
			return _updateType;
		}
		
		public function set updateType(value:int):void
		{
			_updateType = value;
		}
		
		public function get buffers():Array
		{
			return _buffers;
		}
		
		public function set buffers(value:Array):void
		{
			_buffers = value;
		}
		
		public function getBuffById(buffId:int):BuffData
		{
			return _buffDcit[buffId] as BuffData;
		}
	}
}