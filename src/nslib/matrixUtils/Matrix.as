/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.matrixUtils
{
	
	public class Matrix
	{
		
		public var _values:Array = [];
		
		public function Matrix(col:int, row:int)
		{
			fillEmptyMatrix(col, row);
		}
		
		public static function createColumnMatrixEmpty(row:int):Matrix
		{
			return new Matrix(1, row);
		}
		
		public static function createColumnMatrixFromArray(data:Array):Matrix
		{
			var m:Matrix = new Matrix(1, data.length);
			
			for (var i:int = 0; i < data.length; i++)
			{
				
				m.setValueAt(data[i], 0, i);
			}
			
			return m;
		}
		
		public static function createRowMatrixFromArray(data:Array):Matrix
		{
			
			var m:Matrix = new Matrix(data.length, 1);
			
			for (var i:int = 0; i < data.length; i++)
			{
				
				m.setValueAt(data[i], i, 0);
			}
			
			return m;
		}
		
		public static function createRowMatrixEmpty(col:int):Matrix
		{
			return new Matrix(col, 1);
		}
		
		public function fillEmptyMatrix(col:int, row:int):void
		{
			
			var temp:Array;
			
			if (col > 0 && row > 0)
			{
				for (var c:int = 0; c < col; c++)
				{
					
					temp = new Array();
					
					for (var r:int = 0; r < row; r++)
					{
						
						temp.push(0);
					}
					_values.push(temp);
				}
			}
			else
			{
				new Error("Cannot create such a matrix!");
			}
		
		}
		
		public function convertToLine():Array
		{
			
			var _length:int = this.getNOfColumns() * this.getNOfRows();
			var _result:Array = [];
			var _index:int = 0;
			
			for (var r:int = 0; r < this.getNOfRows(); r++)
			{
				for (var c:int = 0; c < this.getNOfColumns(); c++)
				{
					
					_result[_index] = this.getValueAt(c, r);
					_index++;
				}
			}
			
			return _result;
		}
		
		public function createSquareMatrixFromLine(_line:Array, _dimentions:int):Matrix
		{
			var m:Matrix = new Matrix(_dimentions, _dimentions);
			var _index:int = 0;
			
			for (var r:int = 0; r < m.getNOfRows(); r++)
				for (var c:int = 0; c < m.getNOfColumns(); c++)
				{
					
					m.setValueAt(_line[_index], c, r);
					_index++;
				}
			
			return m;
		}
		
		public function createMatrixFromLine(_line:Array, _columns:int, _rows:int):Matrix
		{
			var m:Matrix = new Matrix(_columns, _rows);
			var _index:int = 0;
			
			for (var r:int = 0; r < m.getNOfRows(); r++)
				for (var c:int = 0; c < m.getNOfColumns(); c++)
				{
					
					m.setValueAt(_line[_index], c, r);
					_index++;
				}
			
			return m;
		}
		
		public function clearMatrix():void
		{
			
			var col:int = this.getNOfColumns();
			var row:int = this.getNOfRows();
			
			_values = [];
			
			fillEmptyMatrix(col, row);
		
		}
		
		public function getNOfColumns():int
		{
			
			return _values.length;
		}
		
		public function getNOfRows():int
		{
			
			if (_values.length > 0)
			{
				return (_values[0] as Array).length;
			}
			else
			{
				return 0;
			}
		
		}
		
		public function getValueAt(col:int, row:int):Number
		{
			
			var _result:Number = 0;
			_result = Number((_values[col] as Array)[row]);
			
			return _result;
		
		}
		
		public function setValueAt(val:Number, col:int, row:int):void
		{
			
			(_values[col] as Array)[row] = val;
		}
		
		public function printOut():void
		{
			
			var line:String;
			
			trace("Matrix " + this.getNOfColumns() + "x" + this.getNOfRows() + " printing");
			
			for (var r:int = 0; r < this.getNOfRows(); r++)
			{
				line = "";
				for (var c:int = 0; c < this.getNOfColumns(); c++)
				{
					line += this.getValueAt(c, r) + "  ";
				}
				trace(line);
			}
		}
		
		public function getColumn(n:int):Matrix
		{
			
			var m1:Matrix = new Matrix(1, this.getNOfRows());
			
			for (var r:int = 0; r < this.getNOfRows(); r++)
			{
				m1.setValueAt(this.getValueAt(n, r), 0, r);
			}
			
			return m1;
		}
		
		public function getRow(n:int):Matrix
		{
			
			var m1:Matrix = new Matrix(this.getNOfColumns(), 1);
			
			for (var c:int = 0; c < this.getNOfColumns(); c++)
			{
				m1.setValueAt(this.getValueAt(c, n), c, 0);
			}
			
			return m1;
		}
		
		public function isColumnMatrix():Boolean
		{
			
			if (this.getNOfColumns() == 1)
			{
				return true;
			}
			
			return false;
		}
		
		public function isRowMatrix():Boolean
		{
			
			if (this.getNOfRows() == 1)
			{
				return true;
			}
			
			return false;
		}
	
	}

}