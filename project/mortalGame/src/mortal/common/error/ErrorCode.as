package mortal.common.error
{
	import Engine.error.RMIErrorCode;
	import Engine.error.SystemErrorCode;
	
	import Message.DB.Tables.TErrorCode;
	
	import extend.language.PreLanguage;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.ErrorCodeConfig;

	public class ErrorCode
	{
		public static const ErrorLogin_NoRole:int = 32001; //账号没有角色
		public static const ErrorCell_FightToEntityNotOnline:int = 38006;//目标不存在
		public static const ErroeCell_CollectToEntityNotOnline:int = 38050;//采集目标不存在
		public static const ErrorCell_ModeSetPeaceModeCdError:int = 38031;//设置和平模式冷却时间未到
		public static const ErrorPublic_CopyGroupNotExsit:int = 31255;//队伍不存在，请刷新队伍列表
		public static const ErrorPublic_PlayerNotOnline:int = 40001;//玩家不在线
		public static const ErrorCell_EscortIsAttacked:int = 38105;//护送目标正被攻击
		public static const ErrorCell_ObstructNotFight:int = 38034;//阻挡不可以攻击
		public static const ErrorCell_CollectHasOwner:int = 38052;//目标正在采集中
		public static const ErrorGate_ZazenPlayerReject:int = 35852;//对方拒绝双修邀请
		public static const ErrorCell_FightTooFar:int = 38005;//距离太远不可攻击
		public static const ErrorCell_SkillTooFar:int = 38082;//释放技能距离太远无法攻击
		public static const ErrorCell_CollectDistanceTooFar:int = 38056;//距离太远无法采集
		public static const ErrorCell_InputPointError:int = 38024;//输入坐标错误
		public static const ErrorGate_TransportHadTask:int = 35484;//执行灵兽护送或护送任务中
		public static const ErrorGate_BagBagIsFull:int = 35340;//背包已满，销毁或寄存仓库可腾出空间
		public static const ErrorGate_BagSlotNotEnough:int = 35341;//背包空间不足，请清理部分物品
		public static const ErrorGate_FriendFriendAmountLimite:int = 35267;//好友已满，请整理好友列表

		public static const ErrorPublic_CannotGetPetCpnReward:int = 31686;//不能领取宠物争霸累积奖励
		
		public function ErrorCode()
		{
		}
		
		public static function init():void
		{
			new RMIErrorCode();
			initRMIError();
			
			new SystemErrorCode();
			initSystemErroe();
		}
		
		public static function getErrorStringByCode( code:int ):String
		{
			if( SystemErrorCode.isInError(code) )
			{
				return SystemErrorCode.getErrorByCode(code);
			}
			else if( RMIErrorCode.isInError(code) )
			{
				return RMIErrorCode.getErrorByCode(code);
			}
		
			return ErrorCodeConfig.instance.getErrorStringByCode(code);
		}
		
		public static function getErrorByLogin( code:int ):String
		{
			if( SystemErrorCode.isInError(code) )
			{
				return SystemErrorCode.getErrorByCode(code);
			}
			else if( RMIErrorCode.isInError(code) )
			{
				return RMIErrorCode.getErrorByCode(code);
			}
			
			return code+"";
		}
		
		private static function initRMIError():void
		{
			var map:Dictionary = RMIErrorCode.map;
			
			map[RMIErrorCode.ExceptionCodeRMI] = PreLanguage.getString(127); //"RMI基础错误";
			map[RMIErrorCode.ExceptionCodeNotSupported]=PreLanguage.getString(128); //"RMI框架不支持此操作";
			map[RMIErrorCode.ExceptionCodeInvoke]=PreLanguage.getString(129); //"RMI框架不支持这种调用";
			map[RMIErrorCode.ExceptionCodeTimeOut] = PreLanguage.getString(130); //"网络连接超时";
			map[RMIErrorCode.ExceptionCodeConnectionNotConnect] = PreLanguage.getString(131); //"服务器连接失败";
			map[RMIErrorCode.ExceptionCodeConnectionClosed] = PreLanguage.getString(132); //"服务器连接断开";
			map[RMIErrorCode.ExceptionCodeConnectionWrite] = PreLanguage.getString(133); //"网络数据IO错误";
			map[RMIErrorCode.ExceptionCodeObjectNotExist] = PreLanguage.getString(134); //"服务对象不存在";
			map[RMIErrorCode.ExceptionCodeOperationNotExist] = PreLanguage.getString(135); //"服务方法不存在";
			map[RMIErrorCode.ExceptionCodeNotInstantiation] = PreLanguage.getString(136); //"服务没有实例化";
			
			map[RMIErrorCode.ErrorDb_PlayerIdError] =PreLanguage.getString(137); //"玩家ID错误";//	2	0
			map[RMIErrorCode.ErrorDb_PlayerCreateUserNameExsit]=PreLanguage.getString(138); //"账号已存在";//	2	0
			map[RMIErrorCode.ErrorDb_PlayerCreateRoleNameExsit]=PreLanguage.getString(139); //"角色名已经存在";//	2	0
			
			map[RMIErrorCode.ErrorLogin_NeedLoginFromPlatform]=PreLanguage.getString(140); //"登陆超时,请刷新重试";//	2	0
			map[RMIErrorCode.ErrorLogin_NoRole]=PreLanguage.getString(141); //"账号没有角色";//	2	0
			map[RMIErrorCode.ErrorLogin_RoleNameIsToLong]=PreLanguage.getString(142); //"角色名太长";//	2	0
			map[RMIErrorCode.ErrorLogin_CreateRoleNameError]=PreLanguage.getString(143); //"角色名错误";//2	0
			map[RMIErrorCode.ErrorLogin_CreateRoleDataError]=PreLanguage.getString(144); //"创建角色数据不正确";//	2	0
			map[RMIErrorCode.ErrorLogin_UserNameError]=PreLanguage.getString(145); //"错误的账号";//	2	0
			map[RMIErrorCode.ErrorGate_LoginNotLogin]=PreLanguage.getString(146); //"您还没有登陆，请刷新重试";//	2	0
			map[RMIErrorCode.ErrorGate_LoginIsLogin]=PreLanguage.getString(147); //"已经登陆服务器";//	2	0
			map[RMIErrorCode.ErrorGate_OperNotCD]=PreLanguage.getString(148); //"您的操作太快了";//	2	0
			
			map[RMIErrorCode.ErrorLogin_ErrorCodeVersion]=PreLanguage.getString(149); //"版本号不一致";
		}
		
		private static function initSystemErroe():void
		{
			var map:Dictionary = SystemErrorCode.map;
			
			map[SystemErrorCode.ExceptionCodeUnkown]= PreLanguage.getString(116); //"未知异常";
			map[SystemErrorCode.ExceptionOutOffMemery] = PreLanguage.getString(117); //"内存不足";
			map[SystemErrorCode.ExceptionCodeBase] = PreLanguage.getString(118); //"基础库异常";
			map[SystemErrorCode.ExceptionCodeStd] = PreLanguage.getString(119); //"标准库异常";
			map[SystemErrorCode.ExceptionCodeDateTime] = PreLanguage.getString(120); //"日期格式异常";
			map[SystemErrorCode.ExceptionCodeFunction] = PreLanguage.getString(121); //"基本函数异常";
			map[SystemErrorCode.ExceptionCodeNullHandle] = PreLanguage.getString(122); //"空句柄异常";
			map[SystemErrorCode.ExceptionCodeDB]= PreLanguage.getString(123); //"数据库异常";
			map[SystemErrorCode.ExceptionCodeSerialize] = PreLanguage.getString(124); //"序列化异常";
			map[SystemErrorCode.ExceptionCodeLang] = PreLanguage.getString(125); //"语言包异常";
			map[SystemErrorCode.ExceptionCodeXml] = PreLanguage.getString(126); //"XML异常";
		}
		
	}
}
