package mortal.game.model
{
	public class QuickRegisterInfo
	{
		
		private var _userName:String;
		private var _passWord:String;
		private var _rePassWord:String;
		private var _email:String;
		
		
		public function QuickRegisterInfo()
		{
		}

		public function get email():String
		{
			return _email;
		}

		public function set email(value:String):void
		{
			_email = value;
		}

		public function get rePassWord():String
		{
			return _rePassWord;
		}

		public function set rePassWord(value:String):void
		{
			_rePassWord = value;
		}

		public function get passWord():String
		{
			return _passWord;
		}

		public function set passWord(value:String):void
		{
			_passWord = value;
		}

		public function get userName():String
		{
			return _userName;
		}

		public function set userName(value:String):void
		{
			_userName = value;
		}

	}
}