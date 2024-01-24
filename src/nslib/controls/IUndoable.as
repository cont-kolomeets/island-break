/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.controls 
{
	/**
	 * ...
	 * @author Kolomeets Alexander
	 */
	public interface IUndoable 
	{
		function undo():void;
		function redo():void;
	}

}