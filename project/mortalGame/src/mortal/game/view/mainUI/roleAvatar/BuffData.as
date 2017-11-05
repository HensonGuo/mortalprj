package mortal.game.view.mainUI.roleAvatar
{
	import Message.DB.Tables.TBuff;
	import Message.Public.SBuff;
	
	import com.gengine.resource.info.ResourceInfo;
	
	import mortal.game.resource.ResConfig;
	import mortal.game.resource.tableConfig.BuffConfig;

	/**
	 * 储存buff的信息 
	 * @author Administrator
	 * 
	 */	
	public class BuffData
	{
		private var _sbuff:SBuff;   //服务器发过来的信息
		private var _tstate:TBuff;    //配置表的信息
		private var _stateId:int;
		private var _group:int;
		public var isSelfBuff:Boolean = false; //是否玩家的buff
		
		public function BuffData(sbuff:SBuff=null)
		{
			this.sbuff = sbuff;
		}

		/**
		 *Buff信息 
		 */
		public function get sbuff():SBuff
		{
			return _sbuff;
		}

		/**
		 * @private
		 */
		public function set sbuff(value:SBuff):void
		{
			_sbuff = value;
		}

		/**
		 *Buff状态详细信息 
		 */
		public function get tbuff():TBuff
		{
			if(_sbuff)
			{
				_tstate = BuffConfig.instance.getInfoById(_sbuff.buffId);
			}
			return _tstate;
		}
		
		public function set tbuff(value:TBuff):void
		{
			_tstate = value;
		}
		
		/**
		 *获取Buff图标路径 
		 * @return 
		 * 
		 */		
		public function getIconPath():String
		{
			var state:TBuff = tbuff;
			if(state && state.icon != 0)
			{
				return state.icon + ".jpg";
			}
			return "";
		}
		
		/**
		 * 获取Buff剩余时间(秒)
		 * @return 
		 * 
		 */		
		public function getLeavSeconds():Number
		{
			var seconds:Number = 0;
			if(_sbuff)
			{
				seconds = _sbuff.remainSec;
			}
			return seconds;
		}
		
		/**
		 *设置剩余时间 
		 * @param seconds
		 * @return 
		 * 
		 */		
		public function setLeavSeconds(seconds:int):void
		{
			if(_sbuff)
			{
				_sbuff.remainSec = seconds;
			}
		}

		public function get stateId():int
		{
			if(_sbuff)
			{
				_stateId = _sbuff.buffId;
			}
			return _stateId;
		}

		public function get group():int
		{
			if(_tstate)
			{
				_group = _tstate.group;
			}
			return _group;
		}

		public function set group(value:int):void
		{
			_group = value;
		}


	}
}