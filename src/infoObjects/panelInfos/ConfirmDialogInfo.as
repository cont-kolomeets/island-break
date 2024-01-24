/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package infoObjects.panelInfos 
{
	/**
	 * ...
	 * @author Kolomeets A. V., Russia, Novosibirsk, 2012.
	 */
	public class ConfirmDialogInfo 
	{
		public var message:String;
		
		public var modal:Boolean;
		
		public function ConfirmDialogInfo(message:String, modal:Boolean) 
		{
			this.message = message;
			this.modal = modal;
		}
		
	}

}