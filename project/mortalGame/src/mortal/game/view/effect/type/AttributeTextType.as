package mortal.game.view.effect.type
{
	import extend.language.Language;

	public class AttributeTextType
	{
		//属性名称
		private var _typeName:String;
		
		public static const experience:AttributeTextType = new AttributeTextType(Language.getString(11000));
		public static const gold:AttributeTextType = new AttributeTextType(Language.getString(11001));
		public static const coin:AttributeTextType = new AttributeTextType(Language.getString(11002));
		public static const attack:AttributeTextType = new AttributeTextType(Language.getString(11005));
		public static const life:AttributeTextType = new AttributeTextType(Language.getString(11006));
		public static const physDefense:AttributeTextType = new AttributeTextType(Language.getString(11007));
		public static const magicDefense:AttributeTextType = new AttributeTextType(Language.getString(11008));
		public static const penetration:AttributeTextType = new AttributeTextType(Language.getString(11009));
		public static const jouk:AttributeTextType = new AttributeTextType(Language.getString(11010));
		public static const hit:AttributeTextType = new AttributeTextType(Language.getString(11011));
		public static const crit:AttributeTextType = new AttributeTextType(Language.getString(11012));
		public static const toughness:AttributeTextType = new AttributeTextType(Language.getString(11013));
		public static const block:AttributeTextType = new AttributeTextType(Language.getString(11014));
		public static const expertise:AttributeTextType = new AttributeTextType(Language.getString(11015));
		public static const damageReduce:AttributeTextType = new AttributeTextType(Language.getString(11016));
		
		public function AttributeTextType(typeName:String)
		{
			_typeName = typeName;
		}

		public function get typeName():String
		{
			return _typeName;
		}

		public function set typeName(value:String):void
		{
			_typeName = value;
		}
		
		public static function getAttribTextTypeByName(cnName:String):AttributeTextType
		{
			var attribType:AttributeTextType = null;
			switch(cnName)
			{
				case "attack":
					attribType = AttributeTextType.attack;
					break;
				case "maxLife":
					attribType = AttributeTextType.life;
					break;
				case "physDefense":
					attribType = AttributeTextType.physDefense;
					break;
				case "magicDefense":
					attribType = AttributeTextType.magicDefense;
					break;
				case "penetration":
					attribType = AttributeTextType.penetration;
					break;
				case "jouk":
					attribType = AttributeTextType.jouk;
					break;
				case "hit":
					attribType = AttributeTextType.hit;
					break;
				case "crit":
					attribType = AttributeTextType.crit;
					break;
				case "toughness":
					attribType = AttributeTextType.toughness;
					break;
				case "block":
					attribType = AttributeTextType.block;
					break;
				case "expertise":
					attribType = AttributeTextType.expertise;
					break;
				case "damageReduce":
					attribType = AttributeTextType.damageReduce;
					break;
			}
			return attribType;
		}


	}
}