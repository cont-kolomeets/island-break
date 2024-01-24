/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.utils
{
	
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class EncryptUtil
	{
		private static const ENCRYPT_SEPARATOR:String = "f2f0a21f-21fd-4b3b-b6b8-93a284c1c172";
		
		private static const ENCRYPT_TABLE:Object =
		{
			"a" : "f383b248-5b67-442e-9f27-87f3b351affd",
			"b" : "3f8cae8d-f174-4832-9006-1413e3ab88e7",
			"c" : "dac25d09-06f4-4ff0-89de-63e7bc35735c",
			"d" : "07d9fd5d-482e-4a46-98fd-346a91240bf3",
			"e" : "61603c0e-2cbb-47ec-bb61-8891e6012ca2",
			"f" : "ee40f87a-da73-46c1-8adb-f7d2ec5e3acc",
			"g" : "bfc15176-64f3-499f-87b5-333825d4a2dd",
			"h" : "488737c0-6c16-4617-a0ca-24fdcca673b6",
			"i" : "95266b6d-a573-40e4-bdc8-24ca70cf3185",
			"k" : "25f5dbbd-e301-4732-8d3d-557c1542851f",
			"l" : "991bff1d-576c-4f3f-8fcb-e57d6e86a3e6",
			"m" : "efd23091-14db-4cac-9a81-ed8f9d215b97",
			"n" : "1c8c4e07-a3e7-4c32-9728-b294e1a0fe33",
			"o" : "fea77ef3-99ee-4547-97fc-91ddcf501571",
			"p" : "1d96af0c-7158-4a6c-810e-a8765ba46c7d",
			"q" : "280bd1ea-fba0-4cc1-9d3e-53fcc1368df4",
			"r" : "986e93f0-6d13-410c-97f5-ec0ab7c569a8",
			"s" : "458d28e7-74d7-45b3-b4b3-b20d79a7b093",
			"t" : "cf21905b-3206-4831-a55e-950612e1832a",
			"u" : "bbec2c82-c557-4488-9fd7-8701714af83d",
			"v" : "79ca0131-0dc9-41e0-ac77-0d7667b5de8b",
			"w" : "a784a0ae-dd70-4e11-a3e8-2d8643fc614f",
			"x" : "ab254759-fbb2-42ce-862e-8c7137724496",
			"y" : "cd7595b4-1ddb-4d64-a672-eacb374a2e98",
			"z" : "88c786e6-6244-424e-9c7c-2ef970c0ab5e"
			
			/*"а" : "a1ad275c-6eb4-441b-b967-f80493a046bf",
			"б" : "844827dd-b8af-46a7-90a0-75763f8a01b9",
			"в" : "1aee9dee-5d49-4f21-91b6-b0f34da11847",
			"г" : "8372c36e-fa1e-4778-b7de-998842819ee9",
			"д" : "350c6972-d644-47b8-808a-adb4072f879b",
			"е" : "ae8eb386-5778-4fbd-93f3-a654804e2ecf",
			"ё" : "97d5b311-7ce8-4bb1-afd8-0ddac7b9b14b",
			"ж" : "fc9b0ca5-e696-4cc8-b019-e90eb115c376",
			"з" : "f1d61679-43f5-4179-8c3a-9d39e849c513",
			"и" : "4b31b364-b650-4e74-958e-3a13568f003f",
			"к" : "80180e74-aecb-4e1c-9007-a679ebaae59b",
			"л" : "6ec0dc87-5725-4eaf-aabf-ddd6569c4b07",
			"м" : "d2f3b82a-5866-4182-a614-67c8fba83faa",
			"н" : "6312e13a-3cad-412e-a42f-8b121f69b1b0",
			"о" : "f78a1759-b5eb-4924-86e2-69a3b4239e6e",
			"п" : "effa9abd-2241-46e0-907a-4205da58ae8b",
			"р" : "c9f5d778-5240-48ed-ae10-f98db1ea4809",
			"с" : "6077ce02-42e6-4ffc-8025-e9acda96b10f",
			"т" : "cc6b874c-65c2-46fa-b6de-f2184df8242c",
			"у" : "e5e91c07-91f6-4996-a63a-98a7446b6dc3",
			"ф" : "ab5a4de7-6a0f-42d6-8af1-3d8f245bb6d3",
			"х" : "2f0a2301-e9b3-4d10-bcb3-0129a791a244",
			"ц" : "2490a20a-2f11-45d6-be6f-54af56995e7a",
			"ч" : "9ed92cf5-5e33-4984-8f1a-c86b579e86fb",
			"ш" : "41a9f6bc-7d24-4751-8c86-6cb9f501254f",
			"щ" : "ef8388a1-1d68-4ee8-86ea-03e3b951110b",
			"ъ" : "9bd581ad-cfdc-42d1-a70e-d8888f53c492",
			"ы" : "51f4eff8-e856-46ed-8153-238fe21b5955",
			"ь" : "bcf08fd9-733a-4b6b-b9c3-4e21ec75d543",
			"э" : "1fdd5b8c-974d-46ba-8f32-215f82d7ca38",
			"ю" : "99285797-d31b-4cfe-8413-4dca388d1233",
			"я" : "7791ce35-9798-4ebf-8914-e5ad403937ca"*/
		}
		
		public static function encryptText(text:String):String
		{
			var symbols:Array = text.split("");
			var result:String = "";
			
			for (var i:int = 0; i < symbols.length; i++)
			{
				result += encodeSymbol(symbols[i]);
				if (i < (symbols.length - 1))
					result += ENCRYPT_SEPARATOR;
			}
			
			return result;
		}
		
		public static function decodeText(text:String):String
		{
			var symbols:Array = text.split(ENCRYPT_SEPARATOR);
			var result:String = "";
			
			for (var i:int = 0; i < symbols.length; i++)
				result += decodeSymbol(symbols[i]);
			
			return result;
		}
		
		private static function encodeSymbol(s:String):String
		{
			if (ENCRYPT_TABLE[s])
				return ENCRYPT_TABLE[s];
			
			return s;
		}
		
		private static function decodeSymbol(s:String):String
		{
			for (var key:String in ENCRYPT_TABLE)
				if (ENCRYPT_TABLE[key] == s)
					return key;
			
			return s;
		}
	
	}

}